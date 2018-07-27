import config from 'config';
import path from 'path';

const ADDRESS = config.get('address');
const DIRS = {};
DIRS.main = path.resolve();
DIRS.public = path.resolve('public');
const MONGO_URI = config.get('mongoURI');
const DAPP = config.get('dapp');
const INTERVALS = config.get('intervals');
const CORS = config.get('cors');

export {
  ADDRESS,
  DIRS,
  MONGO_URI,
  DAPP,
  INTERVALS,
  CORS,
};
