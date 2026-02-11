# Arvutiklasside broneerimissüsteem

Veebirakendus arvutiklasside broneerimiseks. Kasutab PostgreSQL, Bun, Hono, HTMX ja Tailwind CSS.

## Eeldused

- [Bun](https://bun.sh/) on paigaldatud
- PostgreSQL on käivitatud ja ligipääsetav

## Andmebaasi seadistamine

```bash
# Loo andmebaas
createdb arvutiklassid

# Käivita skeem
psql -d arvutiklassid -f ../schema.sql

# Lisa näidisandmed
psql -d arvutiklassid -f ../seed.sql
```

## Käivitamine

```bash
cd app
bun install
bun run dev
```

Server käivitub aadressil **http://localhost:3000**.

## Keskkonnamuutujad

| Muutuja | Vaikeväärtus | Kirjeldus |
|---------|-------------|-----------|
| PGHOST | localhost | PostgreSQL host |
| PGPORT | 5432 | PostgreSQL port |
| PGDATABASE | arvutiklassid | Andmebaasi nimi |
| PGUSER | postgres | Kasutajanimi |
| PGPASSWORD | postgres | Parool |

## Rakenduse marsruudid

| Marsruut | Meetod | Kirjeldus |
|----------|--------|-----------|
| `/` | GET | Broneeringute nimekiri |
| `/bookings/new` | GET | Uue broneeringu vorm |
| `/bookings` | POST | Loo uus broneering |
| `/bookings/:id/edit` | GET | Broneeringu muutmisvorm |
| `/bookings/:id` | PUT/POST | Muuda broneeringut |
| `/bookings/:id` | DELETE | Kustuta broneering |
| `/classrooms` | GET | Arvutiklasside nimekiri |
| `/stats` | GET | Kasutusstatistika |
