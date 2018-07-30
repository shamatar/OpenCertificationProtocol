import Socket from 'socket.io';
import socketsApp from '../../sockets';
import server from 'server';
import app from 'app';

export default () => {
  process.stdout.write('Sockets...');
  const intProcess = setInterval(() => process.stdout.write('.'), 200);
  try {
	  const io = new Socket();
	  io.attach(server, {path: '/api/ws'});
	  io.on('connection', socketsApp);
	  app.io = io;
	  clearInterval(intProcess);
	  process.stdout.write('connected\n');
  } catch (e) {
	  clearInterval(intProcess);
	  process.stdout.write('error\n');
	  throw e;
  }
};
