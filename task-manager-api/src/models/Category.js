const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    }, 
    color: {
        type: String,
        default: '#007AFF' // iOS blue
    }, 
    icon: {
        type: String,
        default: 'list.bullet' // SF Symbol name
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    timestamps: true 
});

module.exports = mongoose.model('Category', categorySchema);
