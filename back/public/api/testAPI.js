const socket = io({path: '/api/ws'});
socket.on('connect_error', () => {
	socket.close();
	alert('backend not available');
});

let fields;

// ----- Desktop -----
const getSession = () => {
	respGS.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('get', '/api/desktop/getSession');
	xhr.send();
	xhr.onload = (event) => {
		const resp = event.target.responseText;
		respGS.innerHTML = resp;
		socket.on(resp, getFields);
	};
};

const getFields = () => {
	respGF.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('get', '/api/desktop/getFields');
	xhr.send();
	xhr.onload = (event) => {
		const resp = event.target.responseText;
		respGF.innerHTML = resp;
		fields = JSON.parse(resp);
		fieldsKYC.innerHTML = '';
		fields.forEach((f, i) => {
			const inp = document.createElement('input');
			inp.className = 'form-control';
			inp.type = f.type;
			inp.placeholder = f.name;
			inp.id = 'field-'+i;
			fieldsKYC.appendChild(inp);
		});
	};
};

const saveFields = () => {
	respSF.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('post', '/api/desktop/saveFields');
	xhr.setRequestHeader('content-type', 'application/json');
	const body = {};
	fields.forEach((f, i) => {
		body[f.name] = document.getElementById('field-'+i).value;
	});
	xhr.send(JSON.stringify(body));
	xhr.onload = (event) => {
		respSF.innerHTML = event.target.responseText;
	};
};

const checkData = () => {
	respCD.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('get', '/api/desktop/checkData');
	xhr.send();
	xhr.onload = (event) => {
		respCD.innerHTML = event.target.responseText;
	};
};


// ----- Mobile -----
const setConnection = () => {
	respSC.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('post', '/api/mobile/setConnection');
	xhr.setRequestHeader('content-type', 'application/json');
	const body = {
		sessionId: sessId.value,
		mainURL: mainURL.value,
		publicKey: publicKey.value,
		signature: signature.value,
	};
	xhr.send(JSON.stringify(body));
	xhr.onload = (event) => {
		respSC.innerHTML = event.target.responseText;
	};
};

const getData = () => {
	respGD.innerHTML = '';
	const xhr = new XMLHttpRequest();
	xhr.open('post', '/api/mobile/getData');
	xhr.setRequestHeader('content-type', 'application/json');
	const body = {
		sessionId: sessId.value,
		signature: signature.value,
	};
	xhr.send(JSON.stringify(body));
	xhr.onload = (event) => {
		respGD.innerHTML = event.target.responseText;
	};
};


setTimeout(getSession, 1000);
setTimeout(setConnection, 2000);
