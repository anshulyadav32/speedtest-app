export const metadata = {
  title: 'Speed Test API',
  description: 'Backend API for Speed Test application',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
