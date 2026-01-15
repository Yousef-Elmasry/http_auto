const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser);
app.use(express.json());

app.post('/auth/refresh-token', (req, res) => {
  console.log(req.body);

  res.status(401).send('Refresh Token has been expired');
});

app.get('/', (req, res) => {
  res.send('Hello World!');
  console.log(req.body);
});

app.post('/', (req, res) => {
  res.send('Hello World!');
  console.log(req.body);
});

app.put('/', (req, res) => {
  res.send('Hello World!');
  console.log(req.body);
});

app.delete('/', (req, res) => {
  res.send('Hello World!');
  console.log(req.body);
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});