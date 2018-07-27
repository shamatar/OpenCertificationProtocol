const fieldsData = {
	demo: [
		{
			name: 'firstName',
			type: 'text',
			number: '0x0001',
		},
		{
			name: 'lastName',
			type: 'text',
			number: '0x0002',
		},
		{
			name: 'gender',
			type: 'text',
			number: '0x0003',
		},
		{
			name: 'age',
			type: 'number',
			number: '0x0004',
		},
	],
};

const getFieldsKYC = (site) => {
	return fieldsData[site].map(el => el);
};

const checkFieldsKYC = (site, data) => {
	const fields = getFieldsKYC(site);
	let checker = true;
	Object.getOwnPropertyNames(data).forEach(name => {
		const ind = fields.findIndex(f => f.name == name);
		if (ind > -1) {
			fields.splice(ind, 1);
		} else {
			checker = false;
		}
	});
	return checker;
};

const packedKYC = (site, data) => {
	const leaves = [];
	const fields = getFieldsKYC(site);
	Object.getOwnPropertyNames(data).forEach(name => {
		const item = fields.find(f => f.name == name);
		leaves.push({
			type: item.number,
			value: data[name],
		});
	});
	return leaves;
};

const unpackedKYC = (site, packed) => {
	const fields = getFieldsKYC(site);
	const data = {};
	packed.forEach(item => {
		const itemFieldsData = fields.find(f => f.number == item.type);
		data[itemFieldsData.name] = item.value;
	});
	return data;
};

export {
	getFieldsKYC,
	checkFieldsKYC,
	packedKYC,
	unpackedKYC,
};
