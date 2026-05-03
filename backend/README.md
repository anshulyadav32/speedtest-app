# Speed Test Backend API

Next.js-based REST API backend for the Speed Test application with JWT authentication.

## Tech Stack

- **Framework**: Next.js 15.1+
- **Language**: TypeScript
- **Runtime**: Node.js
- **Auth**: JWT tokens with bcrypt password hashing

## Project Structure

```
├── app/
│   ├── api/
│   │   ├── auth/
│   │   │   ├── signup/
│   │   │   │   └── route.ts     # POST /api/auth/signup
│   │   │   ├── login/
│   │   │   │   └── route.ts     # POST /api/auth/login
│   │   │   └── me/
│   │   │       └── route.ts     # GET /api/auth/me (requires token)
│   │   ├── health/
│   │   │   └── route.ts         # GET /api/health
│   │   └── speedtest/
│   │       └── route.ts         # POST /api/speedtest (optional auth)
│   ├── layout.tsx
│   └── page.tsx
├── lib/
│   └── auth/
│       ├── jwt.ts               # JWT token utilities
│       └── db.ts                # User database (in-memory)
├── package.json
├── tsconfig.json
├── next.config.js
└── .gitignore
```

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
```

The API will be available at `http://localhost:3000`

### Build for Production

```bash
npm run build
npm start
```

## API Endpoints

### Authentication Endpoints

#### Sign Up

```bash
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

**Response (201):**
```json
{
  "user": {
    "id": "user_1234567890",
    "email": "user@example.com",
    "name": "John Doe"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Login

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "password123"
  }'
```

**Response (200):**
```json
{
  "user": {
    "id": "1",
    "email": "demo@example.com",
    "name": "Demo User"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Demo Credentials:**
- Email: `demo@example.com`
- Password: `password123`

#### Get Current User

```bash
curl -X GET http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response (200):**
```json
{
  "user": {
    "id": "1",
    "email": "demo@example.com",
    "name": "Demo User"
  }
}
```

### Health Check

```bash
curl http://localhost:3000/api/health
```

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2026-05-03T18:00:00.000Z",
  "version": "1.0.0"
}
```

### Speed Test (Optional Auth)

#### Without Authentication

```bash
curl -X POST http://localhost:3000/api/speedtest \
  -H "Content-Type: application/json" \
  -d '{"location": "US"}'
```

#### With Authentication

```bash
curl -X POST http://localhost:3000/api/speedtest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{"location": "US"}'
```

**Response:**
```json
{
  "downloadSpeed": 450.23,
  "uploadSpeed": 125.67,
  "ping": 25,
  "timestamp": "2026-05-03T18:00:00.000Z",
  "location": "US",
  "userId": "1"
}
```

## Deployment

### Vercel

1. Push to GitHub
2. Connect repository to Vercel
3. Deploy automatically

```bash
vercel deploy --prod
```

### Environment Variables

Create a `.env.local` file:

```env
NODE_ENV=development
JWT_SECRET=your-super-secret-key-change-in-production
```

### Docker

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
EXPOSE 3000
ENV NODE_ENV=production
CMD ["npm", "start"]
```

## Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm run lint` - Run linter

## Authentication Flow

1. **User signs up** → POST `/api/auth/signup` → Get JWT token
2. **User logs in** → POST `/api/auth/login` → Get JWT token
3. **Use token for requests** → Add `Authorization: Bearer {token}` header
4. **Get user info** → GET `/api/auth/me` with token
5. **Run speed test** → POST `/api/speedtest` with optional token for tracking

## Database

Currently uses **in-memory storage** with bcrypt password hashing. For production, integrate:
- PostgreSQL + Prisma
- MongoDB + Mongoose
- Firebase Firestore
- Any other database solution

## License

ISC
