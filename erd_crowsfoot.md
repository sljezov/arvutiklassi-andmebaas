# ERD — Crow's Foot notatsioon

```mermaid
erDiagram
    classroom ||--o{ booking : "on broneeritud"
    user_group ||--o{ booking : "teeb"
    lesson_type ||--o{ booking : "määrab tüübi"

    classroom {
        SERIAL id PK
        VARCHAR name UK "NOT NULL, UNIQUE"
        VARCHAR building "NOT NULL"
        INTEGER capacity "NOT NULL, CHECK >= 1"
        BOOLEAN has_projector "DEFAULT false"
        TEXT description
    }

    user_group {
        SERIAL id PK
        VARCHAR name "NOT NULL"
        VARCHAR email UK "UNIQUE"
        VARCHAR role "NOT NULL, DEFAULT 'teacher'"
    }

    lesson_type {
        SERIAL id PK
        VARCHAR name UK "NOT NULL, UNIQUE"
    }

    booking {
        SERIAL id PK
        INTEGER classroom_id FK "NOT NULL"
        INTEGER user_group_id FK "NOT NULL"
        INTEGER lesson_type_id FK
        DATE booking_date "NOT NULL"
        TIME start_time "NOT NULL"
        TIME end_time "NOT NULL"
        INTEGER participants "CHECK >= 0, DEFAULT 0"
        TEXT description
        TIMESTAMP created_at "DEFAULT NOW()"
    }
```

## Seosed

| Seos | Kardinaalsus | Selgitus |
|------|-------------|----------|
| classroom → booking | 1:N | Üht klassi saab broneerida mitu korda |
| user_group → booking | 1:N | Üks kasutaja/grupp teeb mitu broneeringut |
| lesson_type → booking | 1:N (valikuline) | Tunnitüüp võib olla määramata (NULL) |
