socket.on 'load canvas', (data) ->
  console.log data
  $('#connected').text(data.num_users)
  canvas.loadFromJSON data.canvas_state

socket.on 'user connected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'user disconnected', (data) ->
  $('#connected').text(data.total)
  # remove new user div

socket.on 'add path', (json_path) ->
  p = makePath(json_path)
  canvas.add p

socket.on 'remove path', (json_path) ->
  p = makePath(json_path)

  canvas.forEachObject (obj) ->
    obj_path = obj.path.toString()
    p_path = p.path.toString()

    if obj_path == p_path
      obj.remove()

makePath = (json_path) ->
  svg_d = json_path.path.toString().split(',').join(' ')
  path = new fabric.Path svg_d,
    stroke: json_path.stroke
    strokeWidth: json_path.strokeWidth
    fill: null
    strokeLineCap: 'round'
    strokeLineJoin: 'round'
    pathOffset:
      x: json_path.pathOffset.x
      y: json_path.pathOffset.y

  return path
