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

getID = (socket) -> return socket.id.substr(2)

io.on 'connect', (socket) ->
  users.push getID(socket)

  socket.emit 'load state',
    num_users: users.length
    canvas_state: canvas_state
    users: users

  socket.broadcast.emit 'user connected',
    num_users: users.length
    id: getID(socket)

  socket.on 'user move', (pos) ->
    pos.id = getID(socket)
    socket.broadcast.emit 'user move', pos

  socket.on 'add path', (path) ->
    socket.broadcast.emit 'add path', path

  socket.on 'remove path', (path) ->
    socket.broadcast.emit 'remove path', path

  socket.on 'save canvas', (canvas) ->
    canvas_state = canvas

  socket.on 'save actions', (actions) ->
    user_actions[socket.id] = actions

  socket.on 'message', (message) ->
    io.emit 'new message', id: getID(socket), message: message

  socket.on 'disconnect', ->
    users.splice users.indexOf(getID(socket)), 1
    socket.broadcast.emit 'user disconnected',
      num_users: users.length
      id: getID(socket)
      actions: user_actions[socket.id]
    if users.length == 0 then canvas_state = undefined
