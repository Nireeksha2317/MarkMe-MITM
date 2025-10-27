
const mongoose = require('mongoose');

/**
 * @description Represents a student in the database.
 * @property {string} usn - The unique student number (USN).
 * @property {string} name - The full name of the student.
 * @property {string} fatherPhone - The phone number of the student's father.
 */
const studentSchema = new mongoose.Schema({
  'Student USN': {
    type: String,
    required: true,
    unique: true,
    trim: true,
    uppercase: true
  },
  'Student Name': {
    type: String,
    required: true,
    trim: true
  },
  'Student Phone Number': {
    type: String,
    trim: true
  }
  // Add any other student info fields here from your Compass screenshot
}, { collection: 'student_db' });

const Student = mongoose.model('Student', studentSchema);


module.exports = mongoose.model('Student', studentSchema, 'students');
