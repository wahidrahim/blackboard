var express = require('express');
var logger = require('morgan');
var stylus = require('stylus');
var path = require('path');
var io = require('socket.io')();

var app = express();

app.set('port', 3000);
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(stylus.middleware(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
  res.render('index');
});

io.listen(app.listen(app.get('port'), function() {
  console.log('app is listening on http://localhst:' + app.get('port'));
}));

var users = [];

io.on('connect', function(socket) {
  users.push(socket.id);
  socket.emit('connected users', users.length);
  socket.broadcast.emit('user connected', {total: users.length, id: socket.id});

  socket.on('disconnect', function() {
    users.splice(users.indexOf(socket.id), 1);
    socket.broadcast.emit('user disconnected', {total: users.length, id: socket.id});
  })
})
