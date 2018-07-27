import render from 'koa-ejs';
import { DIRS } from 'configuration';

const options = {
  root: DIRS.public,
  layout: false,
  viewExt: 'ejs',
  cache: false,
  debug: false,
};

export default (app) => render(app, options);
