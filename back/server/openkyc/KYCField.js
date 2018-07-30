const ethUtil = require('ethereumjs-util');
const isBuffer = require('is-buffer');
const assert = require('assert');

class KYCField {
  constructor(_data) {
    let data = _data;
    if (typeof data === 'string') {
      data = ethUtil.hexToBuffer(data);
    }
    if (isBuffer(data)) {
      const fields = ethUtil.rlp.decode(data);
      assert(Array.isArray(fields));
      assert(fields.length === 2);
      this.type = fields[0];
      assert(this.type.length === 2);
      this.value = fields[1];
      assert(isBuffer(this.type));
      assert(Array.isArray(this.value));
      assert(isBuffer(this.value[0]));
      return;
    }
    if (Array.isArray(data)) {
      const fields = data;
      assert(fields.length === 2);
      this.type = fields[0];
      assert(this.type.length === 2);
      this.value = fields[1];
      assert(isBuffer(this.type));
      assert(Array.isArray(this.value));
      assert(isBuffer(this.value[0]));
      return;
    }
    if (typeof data === 'object') {
      if (data.hasOwnProperty('type') && data.hasOwnProperty('value')) {
        assert(isBuffer(data.value[0]));
        this.type = data.type;
        assert(this.type.length === 2);
        this.value = data.value;
        assert(isBuffer(this.type));
        assert(Array.isArray(this.value));
        assert(isBuffer(this.value[0]));
        return;
      }
    }
  }
  serialize() {
    const topLevelArray = [this.type, this.value];
    return ethUtil.rlp.encode(topLevelArray);
  }
}

const EmptyField = new KYCField([ethUtil.toBuffer('0x0000'),
                            [ethUtil.toBuffer('0x00000000000000000000000000000000')]]);

const EmptyFieldBuffer = EmptyField.serialize();

module.exports = {KYCField, EmptyField, EmptyFieldBuffer};
