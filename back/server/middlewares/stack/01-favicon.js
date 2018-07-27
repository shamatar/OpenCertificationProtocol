import favicon from 'koa-favicon';
import { DIRS } from 'configuration';
import path from 'path';

export default (app) => {
  const favFile = path.join(DIRS.public, 'favicon.png');
  app.use(favicon(favFile));
};
