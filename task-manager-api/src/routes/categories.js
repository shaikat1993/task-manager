const express = require('express');
const Category = require('../models/Category');
const auth = require('../middleware/Auth');

const router = express.Router();

// Create a new category
router.post('/', auth, async (req, res) => {
    try {
        const category = new Category({
            ...req.body,
            owner: req.user._id
        });
        await category.save();
        res.status(201).json(category);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Get all categories for logged in user
router.get('/', auth, async (req, res) => {
    try {
        const categories = await Category.find({ owner: req.user._id });
        res.json(categories);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get specific category by ID
router.get('/:id', auth, async (req, res) => {
    try {
        const category = await Category.findOne({ _id: req.params.id, owner: req.user._id });
        if (!category) {
            return res.status(404).json({ error: 'Category not found' });
        }
        res.json(category);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a category
router.put('/:id', auth, async (req, res) => {
    try {
        const category = await Category.findOne({ _id: req.params.id, owner: req.user._id });
        if (!category) {
            return res.status(404).json({ error: 'Category not found' });
        }
        category.set(req.body);
        await category.save();
        res.json(category);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete a category
router.delete('/:id', auth, async (req, res) => {
    try {
        const category = await Category.findOne({ _id: req.params.id, owner: req.user._id });
        if (!category) {
            return res.status(404).json({ error: 'Category not found' });
        }
        await category.remove();
        res.json({ message: 'Category deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
