-- Näidisandmed arvutiklasside broneerimissüsteemile

-- Arvutiklassid
INSERT INTO classroom (name, building, capacity, has_projector, description) VALUES
('A-201', 'A-korpus', 30, true, 'Suur arvutiklass projektori ja kõlaritega'),
('A-202', 'A-korpus', 20, true, 'Keskmine arvutiklass'),
('B-101', 'B-korpus', 15, false, 'Väike arvutiklass laboritöödeks'),
('B-102', 'B-korpus', 25, true, 'Keskmine arvutiklass videokonverentsi seadmetega'),
('C-301', 'C-korpus', 35, true, 'Suur arvutiklass seminari jaoks'),
('C-302', 'C-korpus', 10, false, 'Väike arvutiklass individuaalse tööga');

-- Õpetajad / grupid
INSERT INTO user_group (name, email, role) VALUES
('Mart Tamm', 'mart.tamm@kool.ee', 'teacher'),
('Liis Kask', 'liis.kask@kool.ee', 'teacher'),
('Jüri Sepp', 'juri.sepp@kool.ee', 'teacher'),
('Anne Mets', 'anne.mets@kool.ee', 'teacher'),
('Toomas Ilves', 'toomas.ilves@kool.ee', 'admin'),
('TAK25 grupp', 'tak25@kool.ee', 'student_group'),
('TAK24 grupp', 'tak24@kool.ee', 'student_group');

-- Tunni tüübid
INSERT INTO lesson_type (name) VALUES
('Loeng'),
('Praktikum'),
('Seminar'),
('Eksam'),
('Konsultatsioon');

-- Broneeringud
INSERT INTO booking (classroom_id, user_group_id, lesson_type_id, booking_date, start_time, end_time, participants, description) VALUES
(1, 1, 1, '2025-02-10', '08:00', '09:30', 28, 'Programmeerimise loeng'),
(2, 2, 2, '2025-02-10', '10:00', '11:30', 18, 'Andmebaaside praktikum'),
(3, 3, 2, '2025-02-10', '12:00', '13:30', 14, 'Võrgutehnoloogia labor'),
(4, 4, 3, '2025-02-11', '08:00', '09:30', 22, 'IT-juhtimise seminar'),
(5, 1, 1, '2025-02-11', '10:00', '11:30', 30, 'Veebiarenduse loeng'),
(1, 2, 4, '2025-02-12', '08:00', '10:00', 25, 'Andmebaaside eksam'),
(2, 3, 2, '2025-02-12', '10:00', '11:30', 15, 'Linuxi praktikum'),
(6, 4, 5, '2025-02-12', '14:00', '15:00', 5, 'Individuaalne konsultatsioon'),
(3, 1, 2, '2025-02-13', '08:00', '09:30', 12, 'Pythoni praktikum'),
(5, 5, 3, '2025-02-13', '10:00', '12:00', 32, 'IT-turbe seminar'),
(1, 6, 2, '2025-02-14', '08:00', '09:30', 26, 'TAK25 grupi praktikum'),
(4, 7, 1, '2025-02-14', '10:00', '11:30', 20, 'TAK24 grupi loeng'),
(2, 1, 5, '2025-02-14', '14:00', '15:00', 8, 'Konsultatsioon enne eksamit');
