import { NextResponse, NextRequest } from 'next/server'
import { verifyToken, extractTokenFromHeader } from '@/lib/auth/jwt'
import { findUserById } from '@/lib/auth/db'

interface MeResponse {
  user: {
    id: string
    email: string
    name: string
  }
}

export async function GET(request: NextRequest) {
  try {
    // Extract token from Authorization header
    const authHeader = request.headers.get('authorization')
    const token = extractTokenFromHeader(authHeader)

    if (!token) {
      return NextResponse.json(
        { error: 'Missing authorization token' },
        { status: 401 }
      )
    }

    // Verify token
    const payload = verifyToken(token)
    if (!payload) {
      return NextResponse.json(
        { error: 'Invalid or expired token' },
        { status: 401 }
      )
    }

    // Get user
    const user = await findUserById(payload.userId)
    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      )
    }

    const response: MeResponse = {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
    }

    return NextResponse.json(response, { status: 200 })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to get user info' },
      { status: 500 }
    )
  }
}
