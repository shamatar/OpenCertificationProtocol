import logger from 'koa-logger';

export default (app) => {
  app.use(logger());
};
