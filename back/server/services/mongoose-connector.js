import mongoose from 'mongoose';

mongoose.Promise = Promise;

export default (mongoUri) => {
  return mongoose
    .connect(mongoUri, { useNewUrlParser: true })
    .then((mongodb) => {
      return mongodb;
    })
    .catch((err) => {
      throw err;
    });
};
