import sockets from './stack/00-socket';
// import mongo from './stack/01-mongo';
import dappAll from './stack/03-dappAll';
import server from 'server';

export default async () => {
  return new Promise(async (resolve, reject) => {
    try {
    	sockets();
      // await mongo();
      await dappAll();
      resolve();
    } catch (e) {
      console.log(e);
      console.log('Server has been closed');
      server.close();
      reject();
    }
  });
};
