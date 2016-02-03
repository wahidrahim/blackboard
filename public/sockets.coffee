socket.on 'load state', (data) ->
  $('#connected').text(data.num_users)
  canvas.loadFromJSON data.canvas

socket.on 'user connected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'user disconnected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'add path', (json_path) ->
  svg_d = json_path.path.toString().split(',').join(' ')
  p = new fabric.Path svg_d,
    stroke: json_path.stroke
    strokeWidth: json_path.strokeWidth
    fill: null
    strokeLineCap: 'round'
    strokeLineJoin: 'round'
    pathOffset:
      x: json_path.pathOffset.x
      y: json_path.pathOffset.y

  canvas.add p
