import { NextResponse, NextRequest } from 'next/server'
import { createUser, findUserByEmail, verifyPassword } from '@/lib/auth/db'
import { generateToken } from '@/lib/auth/jwt'

interface SignupRequest {
  email: string
  password: string
  name: string
}

interface SignupResponse {
  user: {
    id: string
    email: string
    name: string
  }
  token: string
}

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as SignupRequest

    // Validate input
    if (!body.email || !body.password || !body.name) {
      return NextResponse.json(
        { error: 'Email, password, and name are required' },
        { status: 400 }
      )
    }

    // Create user
    const user = await createUser(body.email, body.password, body.name)
    const token = generateToken(user.id, user.email)

    const response: SignupResponse = {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      token,
    }

    return NextResponse.json(response, { status: 201 })
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Signup failed'
    return NextResponse.json(
      { error: message },
      { status: error instanceof Error && error.message === 'User already exists' ? 409 : 500 }
    )
  }
}
