import serve from 'koa-static';
import {DIRS} from 'configuration';

export default (app) => {
  app.use(serve(DIRS.public));
};
