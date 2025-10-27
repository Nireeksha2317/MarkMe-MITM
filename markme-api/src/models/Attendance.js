
const mongoose = require('mongoose');

/**
 * @description Represents a student's attendance record for a specific day.
 * @property {string} usn - The student's USN.
 * @property {string} date - The date of the record in YYYY-MM-DD format.
 * @property {object} slots - An object containing the attendance status for each time slot.
 */
const attendanceSchema = new mongoose.Schema({
  usn: {
    type: String,
    required: true,
    trim: true,
    uppercase: true,
    ref: 'Student' // Reference to the Student model
  },
  date: {
    type: String, // Storing date as YYYY-MM-DD string for easy filtering
    required: true,
  },
  slots: {
    type: Map,
    of: String, // e.g., { '9-11': 'present', '11:15-1:15': 'absent' }
    default: {}
  }
});

// Create a compound index to ensure that there is only one attendance document per student per day.
attendanceSchema.index({ usn: 1, date: 1 }, { unique: true });

const Attendance = mongoose.model('Attendance', attendanceSchema, 'attendance');

module.exports = Attendance;
