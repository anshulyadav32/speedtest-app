import { NextResponse, NextRequest } from 'next/server'
import { findUserByEmail, verifyPassword } from '@/lib/auth/db'
import { generateToken } from '@/lib/auth/jwt'

interface LoginRequest {
  email: string
  password: string
}

interface LoginResponse {
  user: {
    id: string
    email: string
    name: string
  }
  token: string
}

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as LoginRequest

    // Validate input
    if (!body.email || !body.password) {
      return NextResponse.json(
        { error: 'Email and password are required' },
        { status: 400 }
      )
    }

    // Find user
    const user = await findUserByEmail(body.email)
    if (!user) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
      )
    }

    // Verify password
    const isPasswordValid = await verifyPassword(body.password, user.password)
    if (!isPasswordValid) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
      )
    }

    // Generate token
    const token = generateToken(user.id, user.email)

    const response: LoginResponse = {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      token,
    }

    return NextResponse.json(response, { status: 200 })
  } catch (error) {
    return NextResponse.json(
      { error: 'Login failed' },
      { status: 500 }
    )
  }
}
