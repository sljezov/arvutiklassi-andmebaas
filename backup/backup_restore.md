# Varundamine ja taastamine

## 1. Varukoopia loomine

### Skriptiga

```bash
bash backup/backup.sh
```

Skript loob faili kujul `backup/backup_arvutiklassid_20250210_143000.sql`.

### Käsitsi

```bash
pg_dump arvutiklassid > backup/backup_manual.sql
```

## 2. Andmete kustutamine (testimiseks)

```bash
psql -d arvutiklassid -c "DELETE FROM booking; DELETE FROM lesson_type; DELETE FROM user_group; DELETE FROM classroom;"
```

Kontrolli, et tabelid on tühjad:

```bash
psql -d arvutiklassid -c "SELECT COUNT(*) FROM booking;"
```

Oodatav tulemus: `0`

## 3. Taastamine varukoopia st

```bash
psql -d arvutiklassid < backup/backup_arvutiklassid_20250210_143000.sql
```

## 4. Tõendamine — andmed on taastatud

```bash
psql -d arvutiklassid -c "SELECT COUNT(*) AS klassiruumid FROM classroom;"
psql -d arvutiklassid -c "SELECT COUNT(*) AS kasutajad FROM user_group;"
psql -d arvutiklassid -c "SELECT COUNT(*) AS broneeringud FROM booking;"
```

Oodatavad tulemused:
- klassiruumid: 6 (või rohkem, kui imporditi)
- kasutajad: 7 (või rohkem)
- broneeringud: 13 (või rohkem)

## Samm-sammuline näide

```
1. Loo varukoopia:
   $ bash backup/backup.sh
   ✓ Varukoopia loodud edukalt!

2. Kustuta kõik andmed:
   $ psql -d arvutiklassid -c "DELETE FROM booking; DELETE FROM lesson_type; DELETE FROM user_group; DELETE FROM classroom;"
   DELETE 13
   DELETE 5
   DELETE 7
   DELETE 6

3. Kontrolli tühjust:
   $ psql -d arvutiklassid -c "SELECT COUNT(*) FROM classroom;"
    count
   -------
        0

4. Taasta varukoopia:
   $ psql -d arvutiklassid < backup/backup_arvutiklassid_XXXXXX.sql

5. Kontrolli taastamist:
   $ psql -d arvutiklassid -c "SELECT COUNT(*) FROM classroom;"
    count
   -------
        6
```

## Märkused

- `pg_dump` loob SQL-kujulise varukoopia (tekstifail)
- Alternatiiv: `pg_dump -Fc` loob binaarkujulise varukoopia, mida taastatakse `pg_restore` käsuga
- Regulaarses kasutuses tasuks varundamine automatiseerida (nt cron-iga)
