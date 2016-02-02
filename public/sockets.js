socket.on('connected users', function(num_users) {
  $('#connected').text(num_users);
})

socket.on('user connected', function(data) {
  $('#connected').text(data.total);
  // add a new user div
})

socket.on('user disconnected', function(data) {
  $('#connected').text(data.total);
  // remove user div
})
