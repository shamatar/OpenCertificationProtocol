import Router from 'koa-router';
import controller from './controller';

const router = new Router({ prefix: '/desktop' });

router
  .get('/getSession', controller.getSession)
	.get('/getFields', controller.getFields)
	.post('/saveFields', controller.saveFields)
	.get('/checkData', controller.checkData)
;

export default router.routes();
