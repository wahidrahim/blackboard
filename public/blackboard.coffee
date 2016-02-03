socket = io()
canvas = new fabric.Canvas 'canvas',
  backgroundColor: '#222'
  width: 1152
  height: 720
  isDrawingMode: true

actions = []
actions.last = () -> return this[this.length - 1]

canvas.on 'path:created', (e) ->
  actions.push e.path
  socket.emit 'add path', e.path.toJSON()
  socket.emit 'save canvas', canvas.toJSON()

$('#undo').click (e) ->
  if !actions.length then return
  canvas.remove actions.last()
  socket.emit 'remove path', actions.last().toJSON()
  actions.pop()

$('#color').change (e) ->
  val = $('#color').val()

  canvas.freeDrawingBrush.color = val
  $('#brush-style').css 'background': val

$('#width').on 'input', (e) ->
  val = $('#width').val()

  canvas.freeDrawingBrush.width = val
  $('#widthField').val val
  $('#brush-style').css
    'height': val
    'width': val

$('#color').change()
$('#width').trigger 'input'
