
const express = require('express');
const Student = require('../models/Student');

const router = express.Router();

/**
 * @route   GET /students
 * @desc    Get a list of all students, with optional search.
 * @access  Public
 * @query   ?search=<name_or_usn> - A search term to filter students by name or USN.
 */
router.get('/', async (req, res) => {
  try {
    const { search } = req.query;
    let query = {};

    if (search) {
      const searchRegex = new RegExp(search, 'i'); // Case-insensitive search
      query = {
        $or: [
          { 'Student Name': searchRegex },
          { 'Student USN': searchRegex }
        ]
      };
    }

    const students = await Student.find(query).select('Student Name, Student USN').sort({ 'Student USN': 1 });
    res.status(200).json({ ok: true, data: students });

  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ ok: false, message: 'Failed to fetch students.' });
  }
});

/**
 * @route   GET /students/:usn
 * @desc    Get full details for a single student by their USN.
 * @access  Public
 * @param   :usn - The USN of the student to fetch.
 */
router.get('/:usn', async (req, res) => {
  try {
    const { usn } = req.params;
    const student = await Student.findOne({ 'Student USN': usn.toUpperCase() });

    if (!student) {
      return res.status(404).json({ ok: false, message: 'Student not found.' });
    }

    res.status(200).json({ ok: true, student });

  } catch (error) {
    console.error(`Error fetching student ${req.params.usn}:`, error);
    res.status(500).json({ ok: false, message: 'Failed to fetch student details.' });
  }
});

module.exports = router;
