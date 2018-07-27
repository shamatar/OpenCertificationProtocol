import app from 'app';
const { KYCField, EmptyFieldBuffer } = require('../openkyc/KYCField');
const PaddableTree = require('../openkyc/Tree');
const assert = require('assert');
const ethUtil = require('ethereumjs-util');

const calcRootHash = (arr) => {
	const treeOptions = { hashType: 'sha3' };
	const tree = new PaddableTree(treeOptions);

	const leaves = arr.map(item => {
		const field = new KYCField({
			type: ethUtil.toBuffer(item.type),
			value: [Buffer.from(item.value, 'utf8')],
		});

		return ethUtil.sha3(field.serialize());
	});

	tree.addLeaves(leaves);
	tree.makePaddedTree(EmptyFieldBuffer);
	const root = tree.getMerkleRoot();
	const proof = Buffer.concat(tree.getProof(2, true));
	assert(proof.length === 66);

	// const valid = tree.validateBinaryProof(proof, leaves[0], root);
	// assert(valid);
	const BN = app.state.web3.utils.BN;
	return app.state.web3.utils.toHex(new BN(root));
};

export {
	calcRootHash,
};
