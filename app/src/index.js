const express = require('express');
const client = require('prom-client');
const app = express();
const PORT = process.env.PORT || 3000;

client.collectDefaultMetrics();

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Hello DevOps TP!' });
});

app.get('/health', (req, res) => {
  res.status(200).json({ healthy: true });
});

app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  } catch (err) {
    console.error('metrics endpoint failed', err);
    res.status(500).send('metrics error');
  }
});

if (require.main === module) {
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}
module.exports = app;