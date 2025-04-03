const multer = require('multer');
const path = require('path');
const sharp = require('sharp');
const cloudinary = require('../config/cloudinary');
const { Readable } = require('stream');

// Configure storage
const storage = multer.memoryStorage();

// Configure file filter
const fileFilter = (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|pdf/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (extname && mimetype) {
        return cb(null, true);
    }
    cb(new Error('Only .jpeg, .jpg, .png and .pdf format allowed!'));
};

// Configure multer
const upload = multer({
    storage: storage,
    limits: {
        fileSize: 5 * 1024 * 1024 // 5MB limit
    },
    fileFilter: fileFilter
});

// Convert buffer to stream for Cloudinary
const bufferToStream = (buffer) => {
    const readable = new Readable({
        read() {
            this.push(buffer);
            this.push(null);
        }
    });
    return readable;
};

// Image processing middleware
const processImage = async (req, res, next) => {
    if (!req.file || !req.file.mimetype.startsWith('image')) {
        return next();
    }

    try {
        const processedBuffer = await sharp(req.file.buffer)
            .resize(800, 800, {
                fit: 'inside',
                withoutEnlargement: true
            })
            .jpeg({ quality: 80 })
            .toBuffer();

        req.file.buffer = processedBuffer;
        next();
    } catch (error) {
        next(error);
    }
};

// Cloudinary upload middleware
const uploadToCloudinary = async (req, res, next) => {
    if (!req.file) return next();

    try {
        const stream = bufferToStream(req.file.buffer);
        const uploadOptions = {
            folder: 'task-manager',
            resource_type: 'auto',
            public_id: `${Date.now()}-${path.parse(req.file.originalname).name}`
        };

        const result = await new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                uploadOptions,
                (error, result) => {
                    if (error) reject(error);
                    else resolve(result);
                }
            );

            stream.pipe(uploadStream);
        });

        req.file.cloudinary = result;
        next();
    } catch (error) {
        next(new Error('Failed to upload file to Cloudinary'));
    }
};

module.exports = {
    upload,
    processImage,
    uploadToCloudinary
};
