# UML klassidiagramm

```mermaid
classDiagram
    class classroom {
        +int id PK
        +varchar(100) name UNIQUE
        +varchar(100) building
        +int capacity
        +boolean has_projector
        +text description
    }

    class user_group {
        +int id PK
        +varchar(150) name
        +varchar(255) email UNIQUE
        +varchar(50) role
    }

    class lesson_type {
        +int id PK
        +varchar(100) name UNIQUE
    }

    class booking {
        +int id PK
        +int classroom_id FK
        +int user_group_id FK
        +int lesson_type_id FK
        +date booking_date
        +time start_time
        +time end_time
        +int participants
        +text description
        +timestamp created_at
    }

    classroom "1" --> "0..*" booking : classroom_id
    user_group "1" --> "0..*" booking : user_group_id
    lesson_type "1" --> "0..*" booking : lesson_type_id
```

## Piirangud

| Tabel | Piirang | Tüüp |
|-------|---------|------|
| classroom | `capacity >= 1` | CHECK |
| booking | `end_time > start_time` | CHECK |
| booking | `participants >= 0` | CHECK |
| booking | `classroom_id → classroom(id)` | FK, ON DELETE CASCADE |
| booking | `user_group_id → user_group(id)` | FK, ON DELETE CASCADE |
| booking | `lesson_type_id → lesson_type(id)` | FK, ON DELETE SET NULL |
