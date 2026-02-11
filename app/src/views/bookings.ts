import { layout } from "./layout";

interface Booking {
  id: number;
  booking_date: string;
  start_time: string;
  end_time: string;
  participants: number;
  description: string | null;
  classroom_name: string;
  user_group_name: string;
  lesson_type_name: string | null;
}

interface SelectOption {
  id: number;
  name: string;
}

export function bookingListPage(bookings: Booking[]): string {
  const rows = bookings
    .map(
      (b) => `
    <tr class="border-b hover:bg-gray-50">
      <td class="px-4 py-2">${b.booking_date}</td>
      <td class="px-4 py-2">${b.start_time.slice(0, 5)}–${b.end_time.slice(0, 5)}</td>
      <td class="px-4 py-2">${b.classroom_name}</td>
      <td class="px-4 py-2">${b.user_group_name}</td>
      <td class="px-4 py-2">${b.lesson_type_name || "—"}</td>
      <td class="px-4 py-2 text-center">${b.participants}</td>
      <td class="px-4 py-2">${b.description || ""}</td>
      <td class="px-4 py-2 flex gap-2">
        <a href="/bookings/${b.id}/edit" class="text-blue-600 hover:underline">Muuda</a>
        <button
          hx-delete="/bookings/${b.id}"
          hx-confirm="Kas oled kindel, et soovid broneeringu kustutada?"
          hx-target="closest tr"
          hx-swap="outerHTML"
          class="text-red-600 hover:underline"
        >Kustuta</button>
      </td>
    </tr>`
    )
    .join("");

  return layout(
    "Broneeringud",
    `
    <div class="flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">Broneeringud</h1>
      <a href="/bookings/new" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">+ Uus broneering</a>
    </div>
    <div class="overflow-x-auto bg-white rounded shadow">
      <table class="w-full text-sm">
        <thead class="bg-gray-100 text-left">
          <tr>
            <th class="px-4 py-2">Kuupäev</th>
            <th class="px-4 py-2">Aeg</th>
            <th class="px-4 py-2">Klass</th>
            <th class="px-4 py-2">Õpetaja/grupp</th>
            <th class="px-4 py-2">Tüüp</th>
            <th class="px-4 py-2">Osalejad</th>
            <th class="px-4 py-2">Kirjeldus</th>
            <th class="px-4 py-2">Tegevused</th>
          </tr>
        </thead>
        <tbody>
          ${rows || '<tr><td colspan="8" class="px-4 py-8 text-center text-gray-400">Broneeringud puuduvad</td></tr>'}
        </tbody>
      </table>
    </div>`
  );
}

export function bookingFormPage(
  classrooms: SelectOption[],
  userGroups: SelectOption[],
  lessonTypes: SelectOption[],
  booking?: any
): string {
  const isEdit = !!booking;
  const title = isEdit ? "Muuda broneeringut" : "Uus broneering";

  const classroomOptions = classrooms
    .map(
      (c) =>
        `<option value="${c.id}" ${booking?.classroom_id === c.id ? "selected" : ""}>${c.name}</option>`
    )
    .join("");

  const userGroupOptions = userGroups
    .map(
      (u) =>
        `<option value="${u.id}" ${booking?.user_group_id === u.id ? "selected" : ""}>${u.name}</option>`
    )
    .join("");

  const lessonTypeOptions = lessonTypes
    .map(
      (l) =>
        `<option value="${l.id}" ${booking?.lesson_type_id === l.id ? "selected" : ""}>${l.name}</option>`
    )
    .join("");

  return layout(
    title,
    `
    <h1 class="text-2xl font-bold mb-4">${title}</h1>
    <form
      method="POST"
      action="${isEdit ? `/bookings/${booking.id}?_method=PUT` : "/bookings"}"
      class="bg-white rounded shadow p-6 max-w-lg space-y-4"
    >
      <div>
        <label class="block text-sm font-medium mb-1">Klass *</label>
        <select name="classroom_id" required class="w-full border rounded px-3 py-2">
          <option value="">— Vali klass —</option>
          ${classroomOptions}
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium mb-1">Õpetaja / grupp *</label>
        <select name="user_group_id" required class="w-full border rounded px-3 py-2">
          <option value="">— Vali —</option>
          ${userGroupOptions}
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium mb-1">Tunni tüüp</label>
        <select name="lesson_type_id" class="w-full border rounded px-3 py-2">
          <option value="">— Vali —</option>
          ${lessonTypeOptions}
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium mb-1">Kuupäev *</label>
        <input type="date" name="booking_date" value="${booking?.booking_date || ""}" required class="w-full border rounded px-3 py-2">
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium mb-1">Algusaeg *</label>
          <input type="time" name="start_time" value="${booking?.start_time?.slice(0, 5) || ""}" required class="w-full border rounded px-3 py-2">
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Lõpuaeg *</label>
          <input type="time" name="end_time" value="${booking?.end_time?.slice(0, 5) || ""}" required class="w-full border rounded px-3 py-2">
        </div>
      </div>
      <div>
        <label class="block text-sm font-medium mb-1">Osalejate arv</label>
        <input type="number" name="participants" value="${booking?.participants ?? 0}" min="0" class="w-full border rounded px-3 py-2">
      </div>
      <div>
        <label class="block text-sm font-medium mb-1">Kirjeldus</label>
        <textarea name="description" rows="3" class="w-full border rounded px-3 py-2">${booking?.description || ""}</textarea>
      </div>
      <div class="flex gap-3">
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          ${isEdit ? "Salvesta" : "Loo broneering"}
        </button>
        <a href="/" class="px-4 py-2 rounded border hover:bg-gray-50">Tühista</a>
      </div>
    </form>`
  );
}
