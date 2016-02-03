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

io.on 'connect', (socket) ->
  users.push socket.id

  socket.emit 'connected users', users.length
  socket.broadcast.emit 'user connected',
    total: users.length
    id: socket.id

  socket.on 'disconnect', ->
    users.splice users.indexOf(socket.id), 1
    socket.broadcast.emit 'user disconnected',
      total: users.length
      id: socket.id
