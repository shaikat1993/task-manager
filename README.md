# Task Manager Application

A full-stack task management application with robust backend API and security features. This project serves as a learning resource for building secure and scalable Node.js applications with MongoDB.

## Features

- User Authentication & Authorization
- Task Management (CRUD operations)
- Category Management
- File Upload with Cloudinary
- Security Best Practices
- Rate Limiting
- MongoDB Atlas Integration

## Tech Stack

### Backend (task-manager-api)
- Node.js
- MongoDB with Mongoose
- JWT Authentication
- Bcrypt for Password Hashing
- Cloudinary for File Storage
- Express Rate Limit
- Helmet for Security Headers
- Jest for Testing

## Installation

1. Clone the repository:
```bash
git clone https://github.com/shaikat1993/task-manager.git
cd task-manager
```

2. Install API dependencies:
```bash
cd task-manager-api
npm install
```

3. Create a `.env` file in the task-manager-api directory with:
```
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
PORT=3000
```

## Running the Application

### Backend API
```bash
cd task-manager-api
npm run dev     # Development mode
npm start       # Production mode
npm test        # Run tests
```

## API Endpoints

### Authentication
- POST /api/users/register - Register new user
- POST /api/users/login - User login
- GET /api/users/profile - Get user profile
- PATCH /api/users/profile - Update user profile
- DELETE /api/users/profile - Delete user account

### Tasks
- GET /api/tasks - Get all tasks
- POST /api/tasks - Create new task
- GET /api/tasks/:id - Get specific task
- PATCH /api/tasks/:id - Update task
- DELETE /api/tasks/:id - Delete task

### Categories
- GET /api/categories - Get all categories
- POST /api/categories - Create new category
- PATCH /api/categories/:id - Update category
- DELETE /api/categories/:id - Delete category

## Security Features

- JWT Authentication
- Password Hashing
- Rate Limiting
- Security Headers (Helmet)
- MongoDB Atlas Security
- Environment Variables
- Input Validation

## Testing

The project includes unit and integration tests using Jest:
```bash
npm test            # Run all tests
npm run test:watch  # Run tests in watch mode
```

## Learning Resources

This project demonstrates several key concepts:

1. RESTful API Design
2. Authentication & Authorization
3. Database Modeling with Mongoose
4. File Upload Handling
5. Security Best Practices
6. Testing Node.js Applications
7. Error Handling
8. API Documentation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
