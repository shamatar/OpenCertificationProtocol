import { DAPP, INTERVALS } from 'configuration';
import app from 'app';
import fs from 'fs';
import abi from '../../config/abi.json';

let contract;
let account;
let fromBlock = 0;

const init = async () => {
	fromBlock = 0;
	contract = new app.state.web3.eth.Contract(abi, DAPP.contract);
	account = DAPP.account;
};

const createCertifiate = async (rootHash, publicKey) => {
	const expiredDate = Date.now() + INTERVALS.dapp.expiredTime;
	const expiredDateHex = app.state.web3.utils.toHex(expiredDate.toString());
	await contract.methods.createCertificate(rootHash, publicKey, expiredDateHex).send({ from: account });
	// console.log(rootHash);
	// console.log(publicKey);
	// console.log(expiredDateHex);
};

const checkCertOwner = async (rootHash, publicKey) => {
	const address = await contract.methods.getCertOwner(rootHash).call();
	return publicKey == address;
};

export default {
  init,
	createCertifiate,
	checkCertOwner,
};
