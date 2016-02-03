express = require 'express'
logger = require 'morgan'
stylus = require 'stylus'
path = require 'path'
io = require('socket.io')()

app = express()

app.set 'port', 3000
app.set 'view engine', 'jade'
app.use logger 'dev'
app.use stylus.middleware path.join(__dirname, 'public')
app.use express.static path.join(__dirname, 'public')

app.get '/', (req, res) ->
  res.render 'index'

io.listen app.listen app.get('port'), ->
  console.log 'app is listening on http://localhost:' + app.get('port')

users = []
user_actions = {}
canvas_state = undefined

io.on 'connect', (socket) ->
  console.log 'connection'

  users.push socket.id

  # load current state for connected user
  socket.emit 'load canvas',
    num_users: users.length
    canvas_state: canvas_state

  # notify other users
  socket.broadcast.emit 'user connected',
    total: users.length
    id: socket.id

  socket.on 'add path', (path) ->
    if !user_actions[socket.id]
      user_actions[socket.id] = []

    user_actions[socket.id].push path
    socket.broadcast.emit 'add path', path

  socket.on 'remove path', (path) ->
    socket.broadcast.emit 'remove path', path

  socket.on 'clear actions', (actions) ->
    socket.broadcast.emit 'clear actions', actions

  socket.on 'save canvas', (canvas) ->
    canvas_state = canvas
    console.log canvas_state

  socket.on 'disconnect', ->
    console.log 'disconnection'
    console.log user_actions[socket.id]

    users.splice users.indexOf(socket.id), 1
    socket.broadcast.emit 'user disconnected',
      total: users.length
      id: socket.id
      actions: user_actions[socket.id]
