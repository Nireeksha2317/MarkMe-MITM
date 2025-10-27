
const express = require('express');
const Attendance = require('../models/Attendance');

const router = express.Router();

/**
 * @route   POST /attendance/mark
 * @desc    Mark a student's attendance for a specific date and slot.
 * @access  Public
 * @body    { usn: string, date: string (YYYY-MM-DD), slot: string, status: string ('present'|'absent') }
 */
router.post('/mark', async (req, res) => {
  const { usn, date, slot, present } = req.body;

  // Basic validation
  if (!usn || !date || !slot || present === undefined) {
    return res.status(400).json({ ok: false, message: 'Missing required fields: usn, date, slot, present.' });
  }
  
  const status = present ? 'present' : 'absent';

  try {
    // Use upsert to create a new document if one doesn't exist for the student and date,
    // or update the existing one.
    const result = await Attendance.findOneAndUpdate(
      { usn: usn.toUpperCase(), date },
      { 
        $set: { 
          [`slots.${slot}`]: status
        }
      },
      { 
        new: true, 
        upsert: true, // Create a new doc if no match is found
        runValidators: true
      }
    );

    res.status(200).json({ ok: true, message: `Attendance marked for ${usn} on ${date}.`, attendance: result });

  } catch (error) {
    console.error('Error marking attendance:', error);
    res.status(500).json({ ok: false, message: 'Failed to mark attendance.' });
  }
});
/**
 * @route   GET /attendance/absentees
 * @desc    Get a list of USNs for students marked as absent for a specific date and slot.
 * @access  Public
 * @query   ?date=YYYY-MM-DD&slot=slotID
 */
router.get('/absentees', async (req, res) => {
  const { date, slot } = req.query;

  if (!date || !slot) {
    return res.status(400).json({ ok: false, message: 'Missing required query parameters: date, slot.' });
  }

  try {
    // Find all attendance records for the given date where the specified slot is 'absent'.
    const absentees = await Attendance.find(
      {
        date,
        [`slots.${slot}`]: 'absent'
      }
    ).select('usn -_id'); // Select only the USN field and exclude the _id field

    const absenteeUsns = absentees.map(a => a.usn);

    res.status(200).json({ ok: true, absentees: absenteeUsns });

  } catch (error) {
    console.error('Error fetching absentees:', error);
    res.status(500).json({ ok: false, message: 'Failed to fetch absentees.' });
  }
});

module.exports = router;
