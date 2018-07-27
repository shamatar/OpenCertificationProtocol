import session from 'koa-session';
import { DIRS } from 'configuration';

const cookies = {};

const store = {
	get: (key) => {
		return {
			key,
			value: cookies[key],
		};
	},
	set: (key, session) => {
		cookies[key] = session;
	},
	destroy: (key) => {
		delete cookies[key];
	},
};

const options = {
	key: 'sessionId',
	maxAge: 30000,
	overwrite: true,
	httpOnly: true,
	signed: false,
	rolling: false,
	renew: false,
	store,
};

export default (app) => {
	app.keys = ['some secret hurr'];
	app.use(session(options, app));
};
