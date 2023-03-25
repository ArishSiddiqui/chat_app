import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    Message({
        required this.message,
        required this.sender,
    });

    String message;
    String sender;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"],
        sender: json["sender"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "sender": sender,
    };
}
