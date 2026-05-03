import { NextResponse, NextRequest } from 'next/server'

interface SpeedTestRequest {
  location?: string
}

interface SpeedTestResponse {
  downloadSpeed: number
  uploadSpeed: number
  ping: number
  timestamp: string
  location?: string
}

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as SpeedTestRequest

    // Mock speed test data
    const response: SpeedTestResponse = {
      downloadSpeed: Math.random() * 1000,
      uploadSpeed: Math.random() * 500,
      ping: Math.floor(Math.random() * 50),
      timestamp: new Date().toISOString(),
      location: body.location || 'Unknown',
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
