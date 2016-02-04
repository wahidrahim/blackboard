socket.on 'load state', (data) ->
  $('#connected').text(data.num_users)
  data.users.map (id) -> appendUserDiv(id)
  canvas.loadFromJSON data.canvas_state

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
  $('#' + data.id).remove()

  if data.actions
    data.actions.map (p) -> removePath(p)
    socket.emit 'save canvas', canvas.toJSON()


socket.on 'add path', (json_path) ->
  fabric.util.enlivenObjects [json_path], (paths) ->
    canvas.add paths[0]

socket.on 'remove path', (json_path) ->
  removePath json_path

socket.on 'new message', (data) ->
  text = data.id + ': ' + data.message
  $('#messages').append $('<li>', text: text)

removePath = (p) ->
  canvas.forEachObject (o) ->
    if o.path.toString() == p.path.toString()
      o.remove()

appendUserDiv = (id) ->
  $('<div>', {id: id, class: 'user'}).appendTo('body')
