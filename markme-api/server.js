
// Load environment variables from .env file
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const connectDB = require('./src/db');

// Route imports
const studentRoutes = require('./src/routes/students');
const attendanceRoutes = require('./src/routes/attendance');

// Initialize Express app
const app = express();

// --- Database Connection ---
connectDB();

// --- Middleware ---

// Parse JSON bodies
app.use(express.json());

// Security headers
app.use(helmet());

// Logger
app.use(morgan('dev'));

// CORS configuration
const allowedOrigins = process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : [];
const corsOptions = {
  origin: (origin, callback) => {
    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin) return callback(null, true);
    if (allowedOrigins.indexOf('*') !== -1 || allowedOrigins.indexOf(origin) !== -1) {
      return callback(null, true);
    } else {
      return callback(new Error('Not allowed by CORS'));
    }
  },
  optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Rate limiting to prevent abuse
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// --- API Routes ---

// Health check endpoint
app.get('/', (req, res) => {
  res.status(200).json({ ok: true, service: "MarkMe API" });
});

// Home route
app.get('/home', (req, res) => {
  res.status(200).json({
    ok: true,
    service: 'MarkMe API',
    version: '1.0.0',
    description: 'Backend API for the MarkMe Attendance & Mentoring App',
    author: 'Gemini',
  });
});

// Student and Attendance routes
app.use('/students', studentRoutes);
app.use('/attendance', attendanceRoutes);

// --- Error Handling ---

// 404 Not Found handler
app.use((req, res, next) => {
  res.status(404).json({ ok: false, message: 'Endpoint not found' });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ ok: false, message: 'An internal server error occurred.' });
});

// --- Server Startup ---
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
