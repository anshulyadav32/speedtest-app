export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui, sans-serif', maxWidth: '900px', margin: '0 auto' }}>
      <h1>🚀 Speed Test API</h1>
      <p>Backend API for the Speed Test application with JWT authentication</p>

      <h2>📍 Available Endpoints</h2>
      
      <h3>Authentication</h3>
      <ul>
        <li>
          <code>POST /api/auth/signup</code> - Create a new account
        </li>
        <li>
          <code>POST /api/auth/login</code> - Login and get JWT token
        </li>
        <li>
          <code>GET /api/auth/me</code> - Get current user (requires token)
        </li>
      </ul>

      <h3>Public Endpoints</h3>
      <ul>
        <li>
          <code>GET /api/health</code> - Health check
        </li>
        <li>
          <code>POST /api/speedtest</code> - Run a speed test (optional auth)
        </li>
      </ul>

      <h2>🔑 Demo Credentials</h2>
      <ul>
        <li><strong>Email:</strong> demo@example.com</li>
        <li><strong>Password:</strong> password123</li>
      </ul>

      <h2>💻 Quick Examples</h2>

      <h3>1. Login</h3>
      <pre style={{ background: '#f5f5f5', padding: '1rem', borderRadius: '4px', overflow: 'auto' }}>
{`curl -X POST http://localhost:3000/api/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{
    "email": "demo@example.com",
    "password": "password123"
  }'`}
      </pre>

      <h3>2. Sign Up</h3>
      <pre style={{ background: '#f5f5f5', padding: '1rem', borderRadius: '4px', overflow: 'auto' }}>
{`curl -X POST http://localhost:3000/api/auth/signup \\
  -H "Content-Type: application/json" \\
  -d '{
    "email": "newuser@example.com",
    "password": "password123",
    "name": "John Doe"
  }'`}
      </pre>

      <h3>3. Get Current User</h3>
      <pre style={{ background: '#f5f5f5', padding: '1rem', borderRadius: '4px', overflow: 'auto' }}>
{`curl -X GET http://localhost:3000/api/auth/me \\
  -H "Authorization: Bearer YOUR_TOKEN_HERE"`}
      </pre>

      <h3>4. Run Speed Test</h3>
      <pre style={{ background: '#f5f5f5', padding: '1rem', borderRadius: '4px', overflow: 'auto' }}>
{`curl -X POST http://localhost:3000/api/speedtest \\
  -H "Content-Type: application/json" \\
  -d '{"location": "US"}'`}
      </pre>

      <h2>📚 Documentation</h2>
      <p>
        For full API documentation, see <code>README.md</code>
      </p>

      <hr style={{ margin: '2rem 0' }} />
      <footer style={{ fontSize: '0.9rem', color: '#666' }}>
        <p>Built with Next.js + TypeScript | JWT Auth | Vercel Ready</p>
      </footer>
    </main>
  )
}
