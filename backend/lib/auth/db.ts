import bcrypt from 'bcryptjs'

export interface User {
  id: string
  email: string
  password: string
  name: string
  createdAt: Date
}

// In-memory user database (in production, use PostgreSQL, MongoDB, etc.)
let users: Map<string, User> = new Map()

// Initialize with demo users
function initializeUsers() {
  const demoPassword = bcrypt.hashSync('password123', 10)
  users.set('1', {
    id: '1',
    email: 'demo@example.com',
    password: demoPassword,
    name: 'Demo User',
    createdAt: new Date(),
  })
}

if (users.size === 0) {
  initializeUsers()
}

export async function findUserByEmail(email: string): Promise<User | null> {
  for (const user of users.values()) {
    if (user.email === email) {
      return user
    }
  }
  return null
}

export async function findUserById(id: string): Promise<User | null> {
  return users.get(id) || null
}

export async function createUser(
  email: string,
  password: string,
  name: string
): Promise<User> {
  // Check if user already exists
  const existing = await findUserByEmail(email)
  if (existing) {
    throw new Error('User already exists')
  }

  const hashedPassword = await bcrypt.hash(password, 10)
  const user: User = {
    id: `user_${Date.now()}`,
    email,
    password: hashedPassword,
    name,
    createdAt: new Date(),
  }

  users.set(user.id, user)
  return user
}

export async function verifyPassword(
  plainPassword: string,
  hashedPassword: string
): Promise<boolean> {
  return bcrypt.compare(plainPassword, hashedPassword)
}

export async function getAllUsers(): Promise<User[]> {
  return Array.from(users.values()).map((user) => ({
    ...user,
    password: '', // Don't expose passwords
  }))
}
