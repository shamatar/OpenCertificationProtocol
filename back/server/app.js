import Koa from 'koa';
import inits from 'inits';
import middlewares from 'middlewares';
import pages from 'pages';
import modules from 'modules';

const app = new Koa();
app.state = {
  dapp: [0, 1],
	web3: false,
	id: 0,
	sessions: {},
};

app.start = async () => {
  await inits();
  middlewares(app);
  app.use(modules);
  app.use(pages);
};

export default app;
