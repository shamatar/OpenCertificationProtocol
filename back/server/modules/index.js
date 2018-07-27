import Router from 'koa-router';
import desktop from './destop';
import mobile from './mobile';

const router = new Router({ prefix: '/api' });

router.use(desktop);
router.use(mobile);

export default router.routes();
