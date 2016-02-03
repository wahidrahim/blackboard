// Generated by CoffeeScript 1.10.0
var app, canvas_state, express, io, logger, path, stylus, user_actions, users;

express = require('express');

logger = require('morgan');

stylus = require('stylus');

path = require('path');

io = require('socket.io')();

app = express();

app.set('port', 3000);

app.set('view engine', 'jade');

app.use(logger('dev'));

app.use(stylus.middleware(path.join(__dirname, 'public')));

app.use(express["static"](path.join(__dirname, 'public')));

app.get('/', function(req, res) {
  return res.render('index');
});

io.listen(app.listen(app.get('port'), function() {
  return console.log('app is listening on http://localhost:' + app.get('port'));
}));

users = [];

user_actions = {};

canvas_state = void 0;

io.on('connect', function(socket) {
  console.log('connection');
  users.push(socket.id);
  socket.emit('load canvas', {
    num_users: users.length,
    canvas_state: canvas_state
  });
  socket.broadcast.emit('user connected', {
    total: users.length,
    id: socket.id
  });
  socket.on('add path', function(path) {
    if (!user_actions[socket.id]) {
      user_actions[socket.id] = [];
    }
    user_actions[socket.id].push(path);
    return socket.broadcast.emit('add path', path);
  });
  socket.on('remove path', function(path) {
    return socket.broadcast.emit('remove path', path);
  });
  socket.on('clear actions', function(actions) {
    return socket.broadcast.emit('clear actions', actions);
  });
  socket.on('save canvas', function(canvas) {
    canvas_state = canvas;
    return console.log(canvas_state);
  });
  return socket.on('disconnect', function() {
    console.log('disconnection');
    console.log(user_actions[socket.id]);
    users.splice(users.indexOf(socket.id), 1);
    return socket.broadcast.emit('user disconnected', {
      total: users.length,
      id: socket.id,
      actions: user_actions[socket.id]
    });
  });
});
