require('dotenv').config({ path: '../../.env' });
const mongoose = require('mongoose');

async function testMongoDBConnection() {
    try {
        console.log('Attempting to connect to MongoDB Atlas...');
        console.log('Connection string:', process.env.MONGODB_URI); 
        await mongoose.connect(process.env.MONGODB_URI);
        
        console.log('✅ MongoDB Atlas connected successfully!');
        
        // Test creating a document
        const Test = mongoose.model('Test', new mongoose.Schema({ name: String }));
        const testDoc = await Test.create({ name: 'test' });
        console.log('✅ Successfully created test document:', testDoc._id);
        
        // Clean up
        await Test.deleteOne({ _id: testDoc._id });
        console.log('✅ Successfully cleaned up test document');
        
        await mongoose.connection.close();
        console.log('✅ Connection closed successfully');
        
    } catch (error) {
        console.error('❌ MongoDB connection error:', error.message);
        if (error.message.includes('ENOTFOUND')) {
            console.error('🔍 Check if your connection string is correct');
        } else if (error.message.includes('ECONNREFUSED')) {
            console.error('🔍 Check if MongoDB Atlas is accessible');
        } else if (error.message.includes('AuthenticationFailed')) {
            console.error('🔍 Check your username and password');
        }
    }
}

testMongoDBConnection();