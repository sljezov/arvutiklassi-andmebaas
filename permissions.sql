-- Õiguste haldamine — rollid ja GRANT/REVOKE

-- Kustuta olemasolevad rollid (kui on)
DROP ROLE IF EXISTS app_admin;
DROP ROLE IF EXISTS app_viewer;

-- 1. Admin roll — täisõigused kõigile tabelitele
CREATE ROLE app_admin WITH LOGIN PASSWORD 'admin123';

GRANT ALL PRIVILEGES ON TABLE classroom TO app_admin;
GRANT ALL PRIVILEGES ON TABLE user_group TO app_admin;
GRANT ALL PRIVILEGES ON TABLE lesson_type TO app_admin;
GRANT ALL PRIVILEGES ON TABLE booking TO app_admin;

-- Sequence-de õigused (INSERT jaoks vajalik)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_admin;

-- 2. Viewer roll — ainult lugemisõigus
CREATE ROLE app_viewer WITH LOGIN PASSWORD 'viewer123';

GRANT SELECT ON TABLE classroom TO app_viewer;
GRANT SELECT ON TABLE user_group TO app_viewer;
GRANT SELECT ON TABLE lesson_type TO app_viewer;
GRANT SELECT ON TABLE booking TO app_viewer;

-- ── Testimine ──────────────────────────────────────────────────────

-- Viewer ei saa sisestada:
-- SET ROLE app_viewer;
-- INSERT INTO classroom (name, building, capacity) VALUES ('Test', 'Test', 10);
-- → ERROR: permission denied for table classroom

-- Viewer saab lugeda:
-- SET ROLE app_viewer;
-- SELECT * FROM classroom;
-- → Tagastab kõik read

-- Admin saab kõike teha:
-- SET ROLE app_admin;
-- INSERT INTO classroom (name, building, capacity) VALUES ('Test', 'Test', 10);
-- → INSERT 0 1

-- REVOKE näide — võta viewer-ilt booking tabeli õigus ära:
-- REVOKE SELECT ON TABLE booking FROM app_viewer;
