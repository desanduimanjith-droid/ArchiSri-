const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const apiRoutes = require('./src/routes/api');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api', apiRoutes);

app.get('/', (req, res) => {
    res.send('Archisri Backend is running');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
