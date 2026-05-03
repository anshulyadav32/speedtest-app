export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1>Speed Test API</h1>
      <p>Backend API for the Speed Test application</p>

      <h2>Available Endpoints</h2>
      <ul>
        <li>
          <code>GET /api/health</code> - Health check endpoint
        </li>
        <li>
          <code>POST /api/speedtest</code> - Run a speed test
        </li>
      </ul>

      <h3>Example Usage</h3>
      <pre>
{`curl -X POST http://localhost:3000/api/speedtest \\
  -H "Content-Type: application/json" \\
  -d '{"location": "US"}'`}
      </pre>
    </main>
  )
}
