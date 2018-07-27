import fs from 'fs';

export default (app) => {
  process.stdout.write('Middleware...');
  const stack = fs.readdirSync(__dirname + '/stack').sort();
  stack.forEach((file) => {
    require('./stack/' + file).default(app);
    process.stdout.write('.');
  });
  console.log('done');
};
