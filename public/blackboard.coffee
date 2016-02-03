canvas = new fabric.Canvas 'canvas',
  backgroundColor: '#222'
  width: 1152
  height: 720
  isDrawingMode: true

# initial blank canvas state
states = [canvas.toJSON()]

canvas.on 'path:created', (e) ->
  states.push canvas.toJSON()

$('#undo').click (e) ->
  if states.length > 1
    states.pop()
    canvas.loadFromJSON states[states.length - 1]

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
