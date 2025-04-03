require('dotenv').config({ path: '../../.env' });
const cloudinary = require('../config/cloudinary');
const fs = require('fs').promises;
const path = require('path');

async function testCloudinarySetup() {
    try {
        // Create test file
        const testFile = path.join(__dirname, 'test-image.txt');
        await fs.writeFile(testFile, 'Test content');

        // Test upload
        console.log('Testing Cloudinary upload...');
        const result = await cloudinary.uploader.upload(testFile, {
            folder: 'test',
            resource_type: 'raw'
        });

        console.log('✅ Upload successful!');
        console.log('File URL:', result.secure_url);

        // Test deletion
        await cloudinary.uploader.destroy(result.public_id, { resource_type: 'raw' });
        await fs.unlink(testFile);
        
        console.log('✅ Cleanup successful!');
        console.log('✅ Cloudinary setup is working correctly!');

    } catch (error) {
        console.error('❌ Cloudinary test failed:', error.message);
        console.error('Error details:', error);
    }
}

testCloudinarySetup();