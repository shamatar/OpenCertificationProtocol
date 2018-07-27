import AppError from '../../utils/AppErrors';
import app from 'app';
import { getFieldsKYC, checkFieldsKYC, packedKYC } from '../../services/fields-service';
import DappService from '../../services/dapp-service';
import { calcRootHash } from '../../services/tree-service';
import {checkStatus} from "../../services/status-sevice";

export default {

  async getSession(ctx) {
		if (!ctx.session.value) {
			app.state.id++;
			ctx.session.id = app.state.id;
			app.state.sessions[ctx.session.id] = {};
			ctx.redirect('/api/desktop/getSession');
		} else {
			const cookie = ctx.session.key;
			ctx.session = ctx.session.value;
			app.state.sessions[ctx.session.id].cookie = cookie;
			ctx.body = ctx.session.id;
		}
  },


	async getFields(ctx) {
  	if (!ctx.session.value) throw new AppError(406, 30);
  	ctx.session = ctx.session.value;

		const status = await checkStatus(app.state.sessions[ctx.session.id]);
		if (status < 3) throw new AppError(406, 30+status);

  	const site = app.state.sessions[ctx.session.id].mainURL;
		ctx.body = getFieldsKYC(site);
	},


	async saveFields(ctx) {
		if (!ctx.session.value) throw new AppError(406, 30);
		ctx.session = ctx.session.value;

		const status = await checkStatus(app.state.sessions[ctx.session.id]);
		if (status < 3) throw new AppError(406, 30+status);
		if (status > 3) throw new AppError(406, 38);

		const site = app.state.sessions[ctx.session.id].mainURL;
		const check = checkFieldsKYC(site, ctx.request.body);
		if (!check) throw new AppError(406, 601);
		const packed = packedKYC(site, ctx.request.body);
		app.state.sessions[ctx.session.id].fields = packed;
		app.state.sessions[ctx.session.id].rootHash = calcRootHash(packed);
		const { rootHash, publicKey } = app.state.sessions[ctx.session.id];
		await DappService.createCertifiate(rootHash, publicKey);
		ctx.body = rootHash;
	},


	async checkData(ctx) {
		if (!ctx.session.value) throw new AppError(406, 30);
		ctx.session = ctx.session.value;

		const status = await checkStatus(app.state.sessions[ctx.session.id]);
		if (status < 5) throw new AppError(406, 30+status);
		if (status > 6) throw new AppError(406, 38);

		ctx.body = ctx.session.id;
	},

};
