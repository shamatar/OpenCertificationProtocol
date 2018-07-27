const {KYCField, EmptyFieldBuffer} = require('./KYCField');
const PaddableTree = require('./Tree');
const assert = require('assert');
const ethUtil = require('ethereumjs-util');

function testSerialization() {
    const parsedElement = new KYCField(EmptyFieldBuffer);
    assert(parsedElement.type.length === 2);
    assert(ethUtil.bufferToHex(parsedElement.type) === '0x0000');
}

function testTree() {
    const someField = new KYCField({
        type: ethUtil.toBuffer('0x0001'),
        value: [Buffer.from('Hello', 'utf8')],
    });
    
    const treeOptions = {
        hashType: 'sha3',
    };

    const tree = new PaddableTree(treeOptions);
    const fieldHash = ethUtil.sha3(someField.serialize());
    tree.addLeaf(fieldHash);
    tree.makePaddedTree(EmptyFieldBuffer);
    const root = tree.getMerkleRoot();
    
    const proof = Buffer.concat(tree.getProof(0, true));
    assert(proof.length === 0);
    
    const valid = tree.validateBinaryProof(proof, fieldHash, root);
    assert(valid);
}

function testDeeperTree() {
    const someField = new KYCField({
        type: ethUtil.toBuffer('0x0001'),
        value: [Buffer.from('Hello', 'utf8')],
    });

    const someOtherField = new KYCField({
        type: ethUtil.toBuffer('0x0002'),
        value: [Buffer.from('World', 'utf8')],
    });

    const treeOptions = {
        hashType: 'sha3',
    };
    
    const tree = new PaddableTree(treeOptions);
    const fieldHash = ethUtil.sha3(someField.serialize());
    const otherFieldHash = ethUtil.sha3(someOtherField.serialize());
    tree.addLeaves([fieldHash, fieldHash, otherFieldHash]);
    tree.makePaddedTree(EmptyFieldBuffer);
    const root = tree.getMerkleRoot();
    const proof = Buffer.concat(tree.getProof(2, true));
    
    assert(proof.length === 66);
    
    const valid = tree.validateBinaryProof(proof, otherFieldHash, root);
    assert(valid);
}

testSerialization();
testTree();
testDeeperTree();
