export function layout(title: string, content: string): string {
  return `<!DOCTYPE html>
<html lang="et">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title} — Arvutiklasside broneerimine</title>
  <script src="https://unpkg.com/htmx.org@2.0.4"></script>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
  <nav class="bg-blue-700 text-white shadow-md">
    <div class="max-w-6xl mx-auto px-4 py-3 flex items-center gap-6">
      <a href="/" class="text-lg font-bold hover:text-blue-200">Broneeringud</a>
      <a href="/classrooms" class="hover:text-blue-200">Klassid</a>
      <a href="/stats" class="hover:text-blue-200">Statistika</a>
    </div>
  </nav>
  <main class="max-w-6xl mx-auto px-4 py-6">
    ${content}
  </main>
</body>
</html>`;
}
