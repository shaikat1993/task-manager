const jwt = require("jsonwebtoken");
const User = require("../models/User");

const auth = async (req, res, next) => {
    try {
        const authHeader = req.header("Authorization");
        if (!authHeader) {
            throw new Error('No Authorization header');
        }

        console.log('Auth Header:', authHeader);
        
        if (!authHeader.startsWith('Bearer ')) {
            throw new Error('Invalid token format');
        }

        const token = authHeader.replace('Bearer ', '').trim();
        if (!token) {
            throw new Error('Token is empty');
        }

        console.log('Token:', token);
        console.log('JWT Secret:', process.env.JWT_SECRET);
        
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        console.log('Decoded:', decoded);
        
        const user = await User.findById(decoded.userId);
        console.log('Found User:', user);

        if (!user) {
            throw new Error('User not found');
        }

        req.user = user;
        req.token = token;
        next();
    } catch (error) {
        console.log('Auth Error:', error.message);
        res.status(401).send({ error: "Please authenticate" });
    }
};

module.exports = auth;