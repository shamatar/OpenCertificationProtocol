export default (app) => app.use(async (ctx, next) => {
  try {
    await next();
  } catch (err) {
    console.error(err);
    const { status = 500, message = 'Server Error', errs } = err;
    if (errs) {
      const errorsList = {};
      Object.values(errs).forEach((error) => {
        errorsList[error.path] = error.message;
      });
      ctx.status = status;
      ctx.body = {
        status: status,
        errors: errorsList,
      };
    } else {
      ctx.status = status;
      ctx.body = { status, message };
    }
  }
});
