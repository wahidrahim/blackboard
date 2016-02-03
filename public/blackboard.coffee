socket = io()
canvas = new fabric.Canvas 'canvas',
  backgroundColor: '#222'
  width: 1152
  height: 720
  isDrawingMode: true

# user draws something
canvas.on 'path:created', (e) ->
  console.log e.path.toSVG()
  socket.emit 'add path', e.path.toJSON()

$('#undo').click (e) ->
  # TODO

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
