const sockets = {};
const users = [];

export default (socket) => {
  console.log('Client connected');
  socket.on('login', (us) => {
    const index = users.indexOf(us);
    if (index==-1) users.push(us);
    sockets[us] = socket;
  });

  socket.on('logout', (us) => {
    const index = users.indexOf(us);
    if (index!=-1) users.splice(index, 1);
    delete sockets[us];
  });
};
