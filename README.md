# Arvutiklasside broneerimissüsteem

TAK25 grupi andmebaasirakenduse projekt. Veebirakendus arvutiklasside broneerimiseks.

**Tehnoloogiad:** PostgreSQL, Bun, Hono, HTMX, Tailwind CSS

## Projekti struktuur

```
├── schema.sql              # Andmebaasi skeem (4 tabelit)
├── seed.sql                # Näidisandmed
├── logical_design.md       # Loogiline disaini kirjeldus
├── permissions.sql         # Rollid ja õigused
├── permissions.md          # Õiguste selgitus
├── app/                    # Veebirakendus (Bun + Hono)
├── import/                 # Andmete import (CSV, JSON, XML)
├── export/                 # Andmete eksport
└── backup/                 # Varundamine ja taastamine
```

## Eeldused

- [Bun](https://bun.sh/) on paigaldatud
- PostgreSQL on käivitatud ja ligipääsetav

## Andmebaasi seadistamine

### Variant A: Lokaalne PostgreSQL

```bash
createdb arvutiklassid
psql -d arvutiklassid -f schema.sql
psql -d arvutiklassid -f seed.sql
```

### Variant B: Docker

```bash
docker run --name arvutiklassid-db \
  -e POSTGRES_DB=arvutiklassid \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -d postgres:17

# Oota kuni konteiner käivitub, siis:
psql -h localhost -U postgres -d arvutiklassid -f schema.sql
psql -h localhost -U postgres -d arvutiklassid -f seed.sql
```

## Käivitamine

```bash
# Paigalda sõltuvused (juurkaust + app)
bun install && cd app && bun install && cd ..

# Käivita server
cd app && bun run dev
```

Server käivitub aadressil **http://localhost:3000**.

Kui PostgreSQL jookseb teisel pordil või teise parooliga, kasuta keskkonnamuutujaid:

```bash
PGHOST=localhost PGPORT=5432 PGUSER=postgres PGPASSWORD=postgres bun run dev
```

## Import / Eksport

```bash
# Impordi andmed CSV, JSON ja XML failidest
bun run import

# Ekspordi koondandmed
bun run export
```

## Õigused ja varundamine

```bash
# Loo rollid (admin, viewer)
psql -d arvutiklassid -f permissions.sql

# Loo varukoopia
bash backup/backup.sh
```

## Ekraanipildid

### Broneeringute nimekiri
![Broneeringud](screenshots/01_broneeringud.png)

### Uue broneeringu vorm
![Uus broneering](screenshots/02_uus_broneering.png)

### Broneeringu muutmine
![Muuda broneeringut](screenshots/03_muuda_broneeringut.png)

### Arvutiklassid
![Klassid](screenshots/04_klassid.png)

### Statistika
![Statistika](screenshots/05_statistika.png)
