const errorMessages = {
  10: 'Wrong request',

	30: 'No session',
	31: 'No cookie',
	32: 'No mainURL or publicKey or signature',
	33: 'No fields or rootHash',
	34: 'Certificate is not in blockchain',
	35: 'No sendDate',
	36: 'No loadedDate',
	38: 'Overload session',
	39: 'Internal error',

	40: 'Wrong mobile signature',

  600: 'Wrong request',
  601: 'Required param missed in request',
};

function AppError(httpError, appError, errors) {
  this.name = 'ApplicationError';
  this.status = httpError;
  this.message = errorMessages[appError];
  this.errs = errors;
  this.stack = (new Error()).stack;
}

AppError.prototype = Object.create(Error.prototype);
AppError.prototype.constructor = AppError;

export default AppError;
