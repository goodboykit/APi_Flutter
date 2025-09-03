require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const bodyParser = require('body-parser');
const jsonParser = bodyParser.json();
const urlencodedParser = bodyParser.urlencoded({ extended: true });
const userRoutes = require('./routes/userRoutes');
const articleRoutes = require('./routes/articleRoutes');

const app = express();

// Database Connection
connectDB();

app.use(express.json());

// CORS
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

// Routes
app.use('/api/users', userRoutes);
app.use('/api/articles', articleRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Server Error' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));