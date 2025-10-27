
const mongoose = require('mongoose');

/**
 * @description Represents a student in the database.
 * @property {string} usn - The unique student number (USN).
 * @property {string} name - The full name of the student.
 * @property {string} fatherPhone - The phone number of the student's father.
 */
const mongoose = require('mongoose');

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
  },
  'Student Email Address': {
    type: String,
    trim: true
  }
}, { collection: 'students' }); // Corrected collection name

const Student = mongoose.model('Student', studentSchema);

module.exports = Student;

