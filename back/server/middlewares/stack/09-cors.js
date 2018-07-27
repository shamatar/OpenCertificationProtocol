import cors from '@koa/cors';

export default (app) => {
  app.use(cors());
};
