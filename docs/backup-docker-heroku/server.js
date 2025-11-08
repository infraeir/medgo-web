const express = require('express');
const path = require('path');
const app = express();

// Serve static files from the Flutter web build directory
app.use(express.static(path.join(__dirname, 'build/web')));

app.get('/*', function(req, res) {
  res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
