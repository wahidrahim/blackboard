socket = io()

socket.on 'connected users', (num_users) ->
  $('#connected').text(num_users)

socket.on 'user connected', (data) ->
  $('#connected').text(data.total)
  # add new user div

socket.on 'user disconnected', (data) ->
  $('#connected').text(data.total)
  # add new user div
