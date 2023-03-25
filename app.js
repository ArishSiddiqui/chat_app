const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
// const messages = [];

io.on('connection', (socket) => {
    const name = socket.handshake.query.name;
    // console.log('Connected', name);
    console.log('Connected', socket.id);
    socket.on('message', (data) => {
        // console.log(data);
        const message = {
            message: data.message,
            sender: name,
        };
        // messages.push(message);
        io.emit('message', message);
    })
});

server.listen(3000, () => {
    console.log('Listening on Port : 3000');
});
