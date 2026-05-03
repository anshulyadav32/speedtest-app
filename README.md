# Net Speed Test App

A full-stack speed test application with Flutter frontend and Next.js backend API.

## Project Structure

```
speedtest-app/
├── frontend/          # Flutter app (web, iOS, Android, macOS)
│   ├── lib/          # Dart source code
│   ├── web/          # Web platform files
│   ├── ios/          # iOS platform files
│   ├── android/      # Android platform files
│   ├── macos/        # macOS platform files
│   ├── test/         # Unit and widget tests
│   ├── pubspec.yaml  # Flutter dependencies
│   └── README.md     # Flutter project README
│
└── backend/          # Next.js REST API
    ├── app/
    │   ├── api/      # API routes
    │   │   ├── health/        # Health check
    │   │   └── speedtest/     # Speed test endpoint
    │   ├── layout.tsx
    │   └── page.tsx
    ├── package.json  # Node.js dependencies
    ├── tsconfig.json # TypeScript config
    └── README.md     # Backend project README
```

## Getting Started

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run -d web              # Run on web
flutter build web --release     # Build for web
```

**Deployed**: https://netspeed-navy.vercel.app

### Backend (Next.js API)

```bash
cd backend
npm install
npm run dev                      # Development server (http://localhost:3000)
npm run build && npm start       # Production build
```

## Technology Stack

### Frontend
- **Framework**: Flutter 3.41.6
- **Language**: Dart 3.11.4
- **State Management**: Provider
- **Backend**: Firebase Auth + Firestore
- **Hosting**: Vercel

### Backend
- **Framework**: Next.js 15.1+
- **Language**: TypeScript
- **Runtime**: Node.js
- **API Style**: REST

## Features

- Speed test measurements (download, upload, ping)
- Cross-platform support (web, iOS, Android, macOS)
- User authentication with Firebase
- Real-time network information
- Responsive UI design

## API Documentation

See [backend/README.md](backend/README.md) for API endpoint documentation.

## Development

### Running Both Services

```bash
# Terminal 1: Frontend
cd frontend
flutter run -d web

# Terminal 2: Backend
cd backend
npm run dev
```

### Testing

```bash
# Frontend tests
cd frontend
flutter test

# Backend tests (when added)
cd backend
npm test
```

## Deployment

### Frontend (Vercel)
```bash
cd frontend
flutter build web --release
vercel deploy --prod
```

### Backend (Vercel / Docker / Your hosting)
```bash
cd backend
vercel deploy --prod
# or
npm run build
docker build -t speedtest-api .
docker run -p 3000:3000 speedtest-api
```

## License

ISC

