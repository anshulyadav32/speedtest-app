# Speed Test Backend API

Next.js-based REST API backend for the Speed Test application.

## Tech Stack

- **Framework**: Next.js 15.1+
- **Language**: TypeScript
- **Runtime**: Node.js

## Project Structure

```
├── app/
│   ├── api/
│   │   ├── health/
│   │   │   └── route.ts       # Health check endpoint
│   │   └── speedtest/
│   │       └── route.ts       # Speed test API endpoint
│   ├── layout.tsx             # Root layout
│   └── page.tsx               # Home page
├── package.json               # Dependencies
├── tsconfig.json              # TypeScript config
├── next.config.js             # Next.js config
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

### Speed Test

```bash
curl -X POST http://localhost:3000/api/speedtest \
  -H "Content-Type: application/json" \
  -d '{"location": "US"}'
```

**Response:**
```json
{
  "downloadSpeed": 450.23,
  "uploadSpeed": 125.67,
  "ping": 25,
  "timestamp": "2026-05-03T18:00:00.000Z",
  "location": "US"
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

### Docker

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

## Environment Variables

Create a `.env.local` file:

```env
NODE_ENV=development
```

## Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm run lint` - Run linter

## License

ISC
