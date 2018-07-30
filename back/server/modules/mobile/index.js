import Router from 'koa-router';
import controller from './controller';

const router = new Router({ prefix: '/mobile' });

router
  .post('/setConnection', controller.setConnection)
	.post('/getData', controller.getData)
;

export default router.routes();
