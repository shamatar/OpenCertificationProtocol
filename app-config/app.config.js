const base = 'http://127.0.0.1';
const api = base + ':4000';

module.exports = {
  mainUrl: base,
  apiUrl: api,
  sockets: { url: api, options: {}},
  // Set intervals in miliseconds
  intervals: {
    fetch: 5000,
  }
}
