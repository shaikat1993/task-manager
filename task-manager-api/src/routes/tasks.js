const express = require('express');
const Task = require('../models/Task');
const auth = require('../middleware/Auth');
const { upload, processImage } = require('../middleware/upload');
const cloudinary = require('../config/cloudinary');

const router = express.Router();

// Create a new task
router.post('/', auth, async (req, res) => {
    try {
        const task = new Task({
            ...req.body,
            owner: req.user._id
        });
        await task.save();
        res.status(201).json(task);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Get all tasks for logged in user with pagination and filtering
router.get('/', auth, async (req, res) => {
    try {
        const match = { owner: req.user._id };
        const sort = {};

        if (req.query.status) {
            match.status = req.query.status;
        }

        if (req.query.sortBy) {
            const parts = req.query.sortBy.split(':');
            sort[parts[0]] = parts[1] === 'desc' ? -1 : 1;
        }

        const limit = parseInt(req.query.limit) || 10;
        const skip = parseInt(req.query.page - 1) * limit || 0;

        const tasks = await Task.find(match)
            .limit(limit)
            .skip(skip)
            .sort(sort);

        const total = await Task.countDocuments(match);

        res.json({
            tasks,
            total,
            currentPage: skip / limit + 1,
            totalPages: Math.ceil(total / limit)
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get specific task by ID
router.get('/:id', auth, async (req, res) => {
    try {
        const task = await Task.findOne({ _id: req.params.id, owner: req.user._id });
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        res.json(task);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a task
router.patch('/:id', auth, async (req, res) => {
    const updates = Object.keys(req.body);
    const allowedUpdates = ['title', 'description', 'status', 'dueDate'];
    const isValidOperation = updates.every(update => allowedUpdates.includes(update));

    if (!isValidOperation) {
        return res.status(400).json({ error: 'Invalid updates' });
    }

    try {
        const task = await Task.findOne({ _id: req.params.id, owner: req.user._id });
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }

        updates.forEach(update => task[update] = req.body[update]);
        await task.save();
        res.json(task);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Delete a task
router.delete('/:id', auth, async (req, res) => {
    try {
        const task = await Task.findOneAndDelete({ _id: req.params.id, owner: req.user._id });
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        res.json(task);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Upload attachment
router.post('/:id/attachments', auth, upload.single('file'), processImage, async (req, res) => {
    try {
        const task = await Task.findOne({
            _id: req.params.id,
            owner: req.user._id
        });

        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }

        if (req.file) {
            const result = await cloudinary.uploader.upload(
                req.file.buffer ? 
                    `data:${req.file.mimetype};base64,${req.file.buffer.toString('base64')}` : 
                    req.file.path
            );

            task.attachments.push({
                filename: req.file.originalname,
                url: result.secure_url,
                mimetype: req.file.mimetype
            });

            await task.save();
        }

        res.json(task);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Get task statistics
router.get('/stats', auth, async (req, res) => {
    try {
        const stats = await Task.aggregate([
            { $match: { owner: req.user._id } },
            { $group: {
                _id: '$status',
                count: { $sum: 1 }
            }}
        ]);
        res.json(stats);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get task analytics
router.get('/analytics', auth, async (req, res) => {
    try {
        const timeframe = req.query.timeframe || 'week';
        const now = new Date();
        const startDate = new Date();
        
        if (timeframe === 'week') {
            startDate.setDate(now.getDate() - 7);
        } else if (timeframe === 'month') {
            startDate.setMonth(now.getMonth() - 1);
        }
        
        const analytics = await Task.aggregate([
            {
                $match: {
                    owner: req.user._id,
                    createdAt: { $gte: startDate }
                }
            },
            {
                $group: {
                    _id: {
                        $dateToString: { format: "%Y-%m-%d", date: "$createdAt" }
                    },
                    count: { $sum: 1 }
                }
            },
            { $sort: { "_id": 1 } }
        ]);
        
        res.json(analytics);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
