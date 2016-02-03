socket.on 'load state', (data) ->
  $('#connected').text(data.num_users)
  canvas.loadFromJSON data.canvas_state
  console.log canvas.getObjects()

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

socket.on 'remove path', (json_path) ->
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

  console.log p
  console.log canvas.getObjects()

  canvas.forEachObject (obj) ->
    if obj.height == p.height && obj.left == p.left && obj.stroke == p.stroke
      obj.remove()

#socket.on 'disconnect', () ->
  #canvas.forEachObject (obj) ->
    #for (i = 0; i < actions.length; i++)
      #if act
