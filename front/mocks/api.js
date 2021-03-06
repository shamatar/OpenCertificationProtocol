const path = require('path')
const sockets = require('socket.io')
const jsonServer = require('json-server')
const app = jsonServer.create()
const router = jsonServer.router(path.join(__dirname, 'db.json'))
const sessionId = require(path.join(__dirname, 'db.json')).getSession.id;
const middlewares = jsonServer.defaults()
const port = 4000;
console.log('SessionId =', sessionId);

// #region SERVER SETUP
app.use(middlewares)
app.use((req, res, next) => {
  if (req.method === 'GET') {
    console.log(req.headers.cookie)
    res.cookie("sessionId", sessionId)
  }
  next()
})
app.use(router);

const server = require('http').Server(app);
// #endregion

// #region SOCKETS SETUP
// handle incoming connections from clients
const io = sockets.listen(server);
io.sockets.on('connection', function(socket) {
  // once a client has connected, we expect to get a ping from them saying what room they want to join
  socket.on('room', function(room) {
      socket.join(room);
      console.log(`Room ${room} activated`)
  });
  // socket.in(room).on('simulate_confirmation', function (data) {
  //   console.log('Simulating confirmation');
  //   socket.in(room).emit('confirm', 'simulation');
  // });
  socket.on('session', function (data) {
    // console.log('Simulating confirmation');
    console.log("room---->"+data.room, "msg---->"+data.msg);
    if (data.room === room && data.msg === 'simulate_confirmation') {
      io.sockets.in(room).emit('session', data.msg);
    } else {
      console.log('Unknown data in room', data.room)
    }
  });
});

// now, it's easy to send a message to just the clients in a given room
room = sessionId;
io.sockets.in(room).emit('message', 'what is going on, party people? You should not see this!');
io.sockets.in(room).emit('session', 'Session test message.');

// this message will NOT go to the client defined above
io.sockets.in('foobar').emit('message', 'anyone in this room yet?');

io.sockets.on('connection', function (socket) {
  console.log('Socket connection estableshed...');
  socket.emit('news', { hello: 'world' });

  socket.on('disconnect', function () {
    console.log('User disconnected');
  });
});

// #endregion

server.listen(port, () => {
  console.log('JSON Server is running on port', port)
})
