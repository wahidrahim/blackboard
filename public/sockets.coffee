socket.on 'connected users', (num_users) ->
  $('#connected').text(num_users)

socket.on 'user connected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'user disconnected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'add path', (json_path) ->
  # TODO MAKE FULLY ACCURATE 
  # parse and make sure all values are accurate
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

  console.log p.toSVG() # compare -- 'transform' values are not the exact same
  canvas.add p
