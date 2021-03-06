// Generated by CoffeeScript 1.10.0
var actions, canvas, randomColor, socket;

socket = io();

canvas = new fabric.Canvas('canvas', {
  backgroundColor: '#222',
  width: 1800,
  height: 720,
  isDrawingMode: true
});

actions = [];

actions.last = function() {
  return this[this.length - 1];
};

randomColor = function() {
  return '#' + Math.floor(Math.random() * 16777215).toString(16);
};

canvas.on('path:created', function(e) {
  actions.push(e.path);
  socket.emit('add path', e.path.toJSON());
  socket.emit('save canvas', canvas.toJSON());
  return socket.emit('save actions', actions);
});

$('.upper-canvas').mousemove(function(e) {
  var radius;
  radius = $('#width').val();
  return socket.emit('user move', {
    x: e.pageX - (radius / 2),
    y: e.pageY - (radius / 2),
    size: radius,
    color: $('#color').val()
  });
});

$('#undo').click(function(e) {
  if (!actions.length) {
    return;
  }
  canvas.remove(actions.last());
  socket.emit('remove path', actions.last().toJSON());
  return actions.pop();
});

$('#color').change(function(e) {
  var val;
  val = $('#color').val();
  return canvas.freeDrawingBrush.color = val;
});

$('#width').on('input', function(e) {
  var val;
  val = $('#width').val();
  $('#widthField').val(val);
  $('#brush').css({
    'height': val,
    'width': val
  });
  return canvas.freeDrawingBrush.width = val;
});

$('#messageForm').submit(function() {
  var message;
  message = $('#message').val();
  $('#message').val('');
  socket.send(message);
  return false;
});

$('#color').val(randomColor());

$('#color').change();

$('#width').trigger('input');
