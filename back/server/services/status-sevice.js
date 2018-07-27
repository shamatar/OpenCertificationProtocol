/*
	0 - no sessionId
	1 - sessions[sessionId] = {}
	2 - { cookie }
	3 - { cookie, mainURL, publicKey, signature }
	4 - { cookie, mainURL, publicKey, signature, fields, rootHash }
	5 - blockChain certificate created
	6 - data sent to mobile
	7 - data loaded success
	9 - error
 */

import DappService from './dapp-service';

const checkStatus = async (session) => {
	if (!session) return 0;
	if (typeof session !== 'object') return 9;
	if (!session.cookie) return 1;
	if (!session.mainURL || !session.publicKey || !session.signature) return 2;
	if (!session.fields || !session.rootHash) return 3;
	try {
		const checkCreation = await DappService.checkCertOwner(session.rootHash, session.publicKey);
		if (!checkCreation) return 4;
	} catch (e) {
		return 9;
	}
	if (!session.sendDate) return 5;
	if (!session.loadedDate) return 6;
	return 7;
};

export {
	checkStatus,
};
