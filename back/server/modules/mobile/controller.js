import AppError from '../../utils/AppErrors';
import app from 'app';
import { checkStatus } from '../../services/status-sevice';
import { unpackedKYC } from '../../services/fields-service';

export default {

  async setConnection(ctx) {
  	const { sessionId, mainURL, publicKey, signature } = ctx.request.body;
  	if (!sessionId || !mainURL || !publicKey || !signature) throw new AppError(406, 601);

  	const status = await checkStatus(app.state.sessions[sessionId]);
	  if (status < 2) throw new AppError(406, 30+status);
	  if (status > 2) throw new AppError(406, 38);

	  app.state.sessions[sessionId].mainURL = mainURL;
	  app.state.sessions[sessionId].publicKey = publicKey;
	  app.state.sessions[sessionId].signature = signature;
	  app.io.emit(sessionId, '');
    ctx.body = 'Ok';
  },


	async getData(ctx) {
		const { sessionId, signature } = ctx.request.body;
		if (!sessionId || !signature) throw new AppError(406, 601);

		const status = await checkStatus(app.state.sessions[sessionId]);
		if (status < 5) throw new AppError(406, 30+status);
		if (status > 6) throw new AppError(406, 38);

		if (app.state.sessions[sessionId].signature !== signature) throw new AppError(406, 40);

		const { mainURL, fields } = app.state.sessions[sessionId];
		ctx.body = unpackedKYC(mainURL, fields);
	},

};
