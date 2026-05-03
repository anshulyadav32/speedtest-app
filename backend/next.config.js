/** @type {import('next').NextConfig} */
const nextConfig = {
  // Optimize for API server (no static generation needed for API-only backend)
  experimental: {
    optimizePackageImports: ["@repo/ui"],
  },
}

module.exports = nextConfig
