import { layout } from "./layout";

interface ClassUsage {
  classroom_name: string;
  week_label: string;
  total_hours: string;
  booking_count: number;
}

export function statsPage(usage: ClassUsage[]): string {
  const rows = usage
    .map(
      (u) => `
    <tr class="border-b hover:bg-gray-50">
      <td class="px-4 py-2 font-medium">${u.classroom_name}</td>
      <td class="px-4 py-2">${u.week_label}</td>
      <td class="px-4 py-2 text-center">${Number(u.total_hours).toFixed(1)}</td>
      <td class="px-4 py-2 text-center">${u.booking_count}</td>
    </tr>`
    )
    .join("");

  return layout(
    "Statistika",
    `
    <h1 class="text-2xl font-bold mb-4">Klasside kasutuse statistika</h1>
    <p class="text-gray-600 mb-4">Arvutiklasside kasutus tundides nädalate kaupa.</p>
    <div class="overflow-x-auto bg-white rounded shadow">
      <table class="w-full text-sm">
        <thead class="bg-gray-100 text-left">
          <tr>
            <th class="px-4 py-2">Klass</th>
            <th class="px-4 py-2">Nädal</th>
            <th class="px-4 py-2">Tunnid kokku</th>
            <th class="px-4 py-2">Broneeringuid</th>
          </tr>
        </thead>
        <tbody>
          ${rows || '<tr><td colspan="4" class="px-4 py-8 text-center text-gray-400">Andmed puuduvad</td></tr>'}
        </tbody>
      </table>
    </div>`
  );
}
