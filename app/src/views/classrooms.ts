import { layout } from "./layout";

interface Classroom {
  id: number;
  name: string;
  building: string;
  capacity: number;
  has_projector: boolean;
  description: string | null;
  booking_count: number;
}

export function classroomListPage(classrooms: Classroom[]): string {
  const rows = classrooms
    .map(
      (c) => `
    <tr class="border-b hover:bg-gray-50">
      <td class="px-4 py-2 font-medium">${c.name}</td>
      <td class="px-4 py-2">${c.building}</td>
      <td class="px-4 py-2 text-center">${c.capacity}</td>
      <td class="px-4 py-2 text-center">${c.has_projector ? "Jah" : "Ei"}</td>
      <td class="px-4 py-2">${c.description || "—"}</td>
      <td class="px-4 py-2 text-center">${c.booking_count}</td>
    </tr>`
    )
    .join("");

  return layout(
    "Klassid",
    `
    <h1 class="text-2xl font-bold mb-4">Arvutiklassid</h1>
    <div class="overflow-x-auto bg-white rounded shadow">
      <table class="w-full text-sm">
        <thead class="bg-gray-100 text-left">
          <tr>
            <th class="px-4 py-2">Nimi</th>
            <th class="px-4 py-2">Hoone</th>
            <th class="px-4 py-2">Mahutavus</th>
            <th class="px-4 py-2">Projektor</th>
            <th class="px-4 py-2">Kirjeldus</th>
            <th class="px-4 py-2">Broneeringuid</th>
          </tr>
        </thead>
        <tbody>
          ${rows}
        </tbody>
      </table>
    </div>`
  );
}
