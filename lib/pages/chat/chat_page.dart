import 'package:chat_app/pages/chat/message_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String name;
  const ChatPage({required this.name, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageInputController = TextEditingController();
  late IO.Socket _socket;

  List<Message> allMessages =[];

  _sendMessage() {
    _socket.emit(
      'message',
      {
        'message': _messageInputController.text,
        'sender': widget.name,
      },
    );
    _messageInputController.clear();
  }

  _connectSocket() {
    _socket
        .onConnect((data) => print('Connection Established with data : $data'));
    _socket.onConnectError((data) => print('Connection Error : $data'));
    _socket.onDisconnect((data) => print('Server Disconnected : $data'));
    _socket.on('message', (data) => addMessage(Message.fromJson(data)));
  }

  addMessage(Message message) {
    setState(() {
      allMessages.add(message);
    });
    // ref.read(allMessages.notifier).state.add(message);
    // print(ref.watch(allMessages).length);
  }

  @override
  void initState() {
    _socket = IO.io(
      'http://192.168.43.196:3000',
      IO.OptionBuilder()
          .setTransports(['websocket']).setQuery({'name': widget.name}).build(),
    );
    // print(widget.name);
    _connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Wrap(
                    alignment: allMessages[index].sender == widget.name
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: [
                      Card(
                        color: allMessages[index].sender == widget.name
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                allMessages[index].sender == widget.name
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Text(allMessages[index].message),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: allMessages.length,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageInputController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageInputController.text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
