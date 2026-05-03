import { NextResponse, NextRequest } from 'next/server'
import { verifyToken, extractTokenFromHeader } from '@/lib/auth/jwt'
import { findUserById } from '@/lib/auth/db'

interface SpeedTestRequest {
  location?: string
}

interface SpeedTestResponse {
  downloadSpeed: number
  uploadSpeed: number
  ping: number
  timestamp: string
  location?: string
  userId?: string
}

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as SpeedTestRequest

    // Try to get user info from token (optional)
    let userId: string | undefined
    const authHeader = request.headers.get('authorization')
    const token = extractTokenFromHeader(authHeader)

    if (token) {
      const payload = verifyToken(token)
      if (payload) {
        userId = payload.userId
      }
    }

    // Mock speed test data
    const response: SpeedTestResponse = {
      downloadSpeed: Math.random() * 1000,
      uploadSpeed: Math.random() * 500,
      ping: Math.floor(Math.random() * 50),
      timestamp: new Date().toISOString(),
      location: body.location || 'Unknown',
      userId,
    }

    return NextResponse.json(response, { status: 200 })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to process speed test request' },
      { status: 400 }
    )
  }
}

export async function GET() {
  return NextResponse.json(
    { error: 'Use POST method to run speed test' },
    { status: 405 }
  )
}
