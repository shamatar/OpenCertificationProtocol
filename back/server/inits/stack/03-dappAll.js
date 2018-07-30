import { DAPP, INTERVALS } from 'configuration';
import DappService from '../../services/dapp-service';
import Web3 from 'web3';
import app from 'app';

// BlockChain connection
const tryBlockChainConnect = async () => {
  if (app.state.dapp[0]==0) {
    process.stdout.write('BlockChain...');
    const intProcess = setInterval(() => process.stdout.write('.'), 200);
    const web3 = new Web3(new Web3.providers.HttpProvider(DAPP.http));
    try {
			await web3.eth.getBlockNumber();
      clearInterval(intProcess);
      process.stdout.write('connected\n');
      app.state.web3 = web3;
      app.state.dapp[0] = 1;
      // subscribeBlockChainConnectionError();
      await dappInit();
    } catch (err) {
      clearInterval(intProcess);
      app.state.dapp[0] = 0;
      setTimeout(tryBlockChainConnect, INTERVALS.dapp.reconnection);
    }
  }
};

/*
const subscribeBlockChainConnectionError = () => {
  const intGetBlocks = setInterval(async () => {
    try {
      await app.state.web3.eth.getBlockNumber().then(() => process.stdout.write(''));
    } catch (e) {
      console.log('blockChain getBlockNumber error');
    }
  }, INTERVALS.dapp.checkConnection);

  app.state.web3.eth.subscribe('logs', {}, (error) => {
    if (error) {
      if (error.type == 'close') {
        console.log(new Date().toLocaleString() + ' - socket connection lost');
        clearInterval(intGetBlocks);
        app.state.web3 = false;
        app.state.dapp[0] = 0;
        tryBlockChainConnect();
      } else {
        console.log(new Date().toLocaleString());
        console.error(error);
      }
    } else {
      console.log('log - ' + new Date().toLocaleString());
    }
  });
};
*/

// DAPP init
const dappInit = async () => {
  if (app.state.dapp.join('')=='11') {
    process.stdout.write('BlockChainInit...');
    const intProcess = setInterval(() => process.stdout.write('.'), 200);
    try {
      await DappService.init();
      clearInterval(intProcess);
	    process.stdout.write('done\n');
    } catch (e) {
      clearInterval(intProcess);
      process.stdout.write('!!!-crashed-!!!\n');
      console.error(e);
    }
  }
};

export default async () => {
  await tryBlockChainConnect();
};
