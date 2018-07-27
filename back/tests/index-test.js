const fs = require('fs');

const stack = fs.readdirSync(__dirname + '/stack').sort();
stack.forEach((file) => {
  require('./stack/' + file);
});
