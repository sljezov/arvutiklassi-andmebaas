-- Arvutiklasside broneerimissüsteemi andmebaasiskeem
-- TAK25 grupi andmebaasirakenduse projekt

-- Kustuta olemasolevad tabelid (kui on)
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS lesson_type CASCADE;
DROP TABLE IF EXISTS user_group CASCADE;
DROP TABLE IF EXISTS classroom CASCADE;

-- 1. Arvutiklassid
CREATE TABLE classroom (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    building VARCHAR(100) NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity >= 1),
    has_projector BOOLEAN DEFAULT false,
    description TEXT
);

-- 2. Õpetajad / grupid
CREATE TABLE user_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(50) NOT NULL DEFAULT 'teacher'
);

-- 3. Tunni tüübi lookup
CREATE TABLE lesson_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Broneeringud
CREATE TABLE booking (
    id SERIAL PRIMARY KEY,
    classroom_id INTEGER NOT NULL REFERENCES classroom(id) ON DELETE CASCADE,
    user_group_id INTEGER NOT NULL REFERENCES user_group(id) ON DELETE CASCADE,
    lesson_type_id INTEGER REFERENCES lesson_type(id) ON DELETE SET NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    participants INTEGER DEFAULT 0 CHECK (participants >= 0),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_booking_time CHECK (end_time > start_time)
);

-- Indeksid kiireks otsinguks
CREATE INDEX idx_booking_date ON booking(booking_date);
CREATE INDEX idx_booking_classroom ON booking(classroom_id);
CREATE INDEX idx_booking_user_group ON booking(user_group_id);
