# Loogiline disain — Arvutiklasside broneerimissüsteem

## Tabelite ülevaade

Andmebaas koosneb 4 tabelist, mis katavad arvutiklasside broneerimise põhivajadused.

### 1. `classroom` — Arvutiklassid
Hoiab infot kõigi saadavalolevate arvutiklasside kohta. Iga klass kuulub ühte hoonesse ja omab kindlat mahutavust.

**Põhjendus:** Klassiruumid on süsteemi põhiressurss — neid broneeritakse. Eraldi tabel võimaldab klasse hallata sõltumatult broneeringutest.

### 2. `user_group` — Kasutajad (õpetajad, grupid)
Kasutajate ja gruppide tabel. Sisaldab nii õpetajaid kui õpilasgruppe, kes saavad broneeringuid teha.

**Põhjendus:** Broneerija info peab olema normaliseeritud — sama isik võib teha mitmeid broneeringuid. Rolliväli (`role`) eristab kasutajatüüpe.

### 3. `lesson_type` — Tunnitüüpide lookup
Tunni tüübi klassifikaator (loeng, praktikum, seminar jne).

**Põhjendus:** Lookup-tabel väldib korduvaid stringväärtusi broneeringutabelis ja tagab andmete ühtluse. Uute tüüpide lisamine on lihtne.

### 4. `booking` — Broneeringud
Keskne tabel, mis seob klassiruumi, kasutaja ja tunnitüübi konkreetse aja- ja kuupäevaga.

**Põhjendus:** See on süsteemi tuumtabel, mis realiseerib broneerimise äriloogika.

## Seosed

Kõik seosed on **1:N** (üks-mitmele):

- `classroom` → `booking` (1:N) — üht klassi saab broneerida mitu korda
- `user_group` → `booking` (1:N) — üks kasutaja/grupp saab teha mitu broneeringut
- `lesson_type` → `booking` (1:N) — üht tunnitüüpi saab kasutada mitmes broneeringus

N:M seost ei ole vaja, kuna iga broneering seob täpselt ühe klassi ühe kasutajaga.

## Ärireglid

| Reegel | Realiseerimine |
|--------|----------------|
| Broneeringu lõpuaeg peab olema hiljem kui algusaeg | `CHECK (end_time > start_time)` |
| Osalejate arv ei saa olla negatiivne | `CHECK (participants >= 0)` |
| Klassiruumi mahutavus peab olema vähemalt 1 | `CHECK (capacity >= 1)` |
| Klassiruumi nimi on unikaalne | `UNIQUE` constraint |
| Kasutaja email on unikaalne | `UNIQUE` constraint |
| Tunnitüübi nimi on unikaalne | `UNIQUE` constraint |
| Klassi kustutamisel kustutatakse ka selle broneeringud | `ON DELETE CASCADE` |

## Normaliseerimine

Andmebaas on **kolmandas normaalvormis (3NF)**:

1. **1NF** — kõik veerud sisaldavad atomaarseid väärtusi, igal tabelil on primaarvõti.
2. **2NF** — kõik mitte-võtme veerud sõltuvad tervest primaarvõtmest (primaarvõtmed on ühe-veerulised).
3. **3NF** — puuduvad transitiivsed sõltuvused. Tunnitüüp, kasutaja ja klassiruum on eraldi tabelites, mitte broneeringu tabelis lahtiselt.

## ER-diagramm (tekstiline)

```
classroom (1) ──── (N) booking (N) ──── (1) user_group
                         │
                        (N)
                         │
                        (1)
                    lesson_type
```
