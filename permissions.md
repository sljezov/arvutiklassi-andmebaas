# Õiguste haldamine

## Ülevaade

Süsteemis on kaks PostgreSQL rolli, mis piiravad ligipääsu andmebaasile.

## Rollid

### `app_admin` — Administraator
- **Parool:** `admin123`
- **Õigused:** ALL PRIVILEGES kõigile tabelitele (SELECT, INSERT, UPDATE, DELETE)
- **Kasutus:** Rakenduse täisõigustega kasutaja, kes saab andmeid hallata

### `app_viewer` — Vaataja
- **Parool:** `viewer123`
- **Õigused:** ainult SELECT kõigile tabelitele
- **Kasutus:** Aruandlus, statistika vaatamine — ei saa andmeid muuta

## Rollide loomine

```bash
psql -d arvutiklassid -f permissions.sql
```

## Testimine

### 1. Viewer test — lugemine lubatud

```sql
psql -U app_viewer -d arvutiklassid -c "SELECT * FROM classroom;"
```

Tulemus: tagastatakse kõik klassiruumid.

### 2. Viewer test — kirjutamine keelatud

```sql
psql -U app_viewer -d arvutiklassid -c "INSERT INTO classroom (name, building, capacity) VALUES ('Test', 'Test', 10);"
```

Tulemus:
```
ERROR:  permission denied for table classroom
```

### 3. Admin test — täisõigused

```sql
psql -U app_admin -d arvutiklassid -c "INSERT INTO classroom (name, building, capacity) VALUES ('Test-Admin', 'Test', 10);"
```

Tulemus:
```
INSERT 0 1
```

Puhastamine:
```sql
psql -U app_admin -d arvutiklassid -c "DELETE FROM classroom WHERE name = 'Test-Admin';"
```

### 4. REVOKE näide

Võta viewer-ilt broneeringute lugemisõigus ära:

```sql
psql -d arvutiklassid -c "REVOKE SELECT ON TABLE booking FROM app_viewer;"
```

Kontrollimine:
```sql
psql -U app_viewer -d arvutiklassid -c "SELECT * FROM booking;"
```

Tulemus:
```
ERROR:  permission denied for table booking
```

Taasta õigus:
```sql
psql -d arvutiklassid -c "GRANT SELECT ON TABLE booking TO app_viewer;"
```

## GRANT/REVOKE kokkuvõte

| Käsk | Kirjeldus |
|------|-----------|
| `GRANT ALL PRIVILEGES ON TABLE x TO roll` | Annab kõik õigused |
| `GRANT SELECT ON TABLE x TO roll` | Annab ainult lugemisõiguse |
| `REVOKE SELECT ON TABLE x FROM roll` | Võtab lugemisõiguse ära |
| `REVOKE ALL PRIVILEGES ON TABLE x FROM roll` | Võtab kõik õigused ära |
