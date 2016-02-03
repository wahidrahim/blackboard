socket.on 'load canvas', (data) ->
  $('#connected').text(data.num_users)
  canvas.loadFromJSON data.canvas_state
  data.users.map (id) ->
    appendUserDiv(id)

socket.on 'user connected', (data) ->
  $('#connected').text(data.num_users)
  appendUserDiv(data.id)

socket.on 'user move', (data) ->
  $('#' + data.id).css
    visibility: 'visible'
    position: 'absolute'
    left: data.x
    top: data.y
    width: data.size
    height: data.size
    background: data.color

socket.on 'user disconnected', (data) ->
  $('#connected').text(data.num_users)

  if data.actions
    data.actions.map (p) ->
      removePath(p)
    socket.emit 'save canvas', canvas.toJSON()

  console.log data.id
  $('#' + data.id).remove()

socket.on 'add path', (json_path) ->
  canvas.add makePath(json_path)

socket.on 'remove path', (json_path) ->
  removePath(makePath(json_path))

appendUserDiv = (id) ->
  $('<div>', {id: id, class: 'user'}).appendTo('body')


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

removePath = (p) ->
  canvas.forEachObject (o) ->
    o_path = o.path.toString()
    p_path = p.path.toString()

    if o_path == p_path
      o.remove()
