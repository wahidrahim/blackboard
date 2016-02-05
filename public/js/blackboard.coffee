socket = io()
canvas = new fabric.Canvas 'canvas',
  backgroundColor: '#222'
  width: 1800
  height: 720
  isDrawingMode: true

actions = []
actions.last = ->
  this[this.length - 1]

randomColor = ->
  '#'+Math.floor(Math.random()*16777215).toString(16)

canvas.on 'path:created', (e) ->
  actions.push e.path
  socket.emit 'add path', e.path.toJSON()
  socket.emit 'save canvas', canvas.toJSON()
  socket.emit 'save actions', actions

$('.upper-canvas').mousemove (e) ->
  radius = $('#width').val()
  socket.emit 'user move',
    x: e.pageX - (radius / 2)
    y: e.pageY - (radius / 2)
    size: radius
    color: $('#color').val()

$('#undo').click (e) ->
  if !actions.length then return

  canvas.remove actions.last()
  socket.emit 'remove path', actions.last().toJSON()
  actions.pop()

$('#color').change (e) ->
  val = $('#color').val()
  canvas.freeDrawingBrush.color = val

$('#width').on 'input', (e) ->
  val = $('#width').val()
  $('#widthField').val val
  $('#brush').css
    'height': val
    'width': val
  canvas.freeDrawingBrush.width = val
  
$('#messageForm').submit ->
  message = $('#message').val()
  $('#message').val('')
  socket.send message

  return false

$('#color').val(randomColor())
$('#color').change()
$('#width').trigger 'input'
