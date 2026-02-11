--
-- PostgreSQL database dump
--

\restrict nOQ0Al9H1XBq4Nw4QzeTcfkz7JJ9RLgCY0upXKqHgBTKfJ8pTrj89FlMNjeifjw

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.booking DROP CONSTRAINT IF EXISTS booking_user_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.booking DROP CONSTRAINT IF EXISTS booking_lesson_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.booking DROP CONSTRAINT IF EXISTS booking_classroom_id_fkey;
DROP INDEX IF EXISTS public.idx_booking_user_group;
DROP INDEX IF EXISTS public.idx_booking_date;
DROP INDEX IF EXISTS public.idx_booking_classroom;
ALTER TABLE IF EXISTS ONLY public.user_group DROP CONSTRAINT IF EXISTS user_group_pkey;
ALTER TABLE IF EXISTS ONLY public.user_group DROP CONSTRAINT IF EXISTS user_group_email_key;
ALTER TABLE IF EXISTS ONLY public.lesson_type DROP CONSTRAINT IF EXISTS lesson_type_pkey;
ALTER TABLE IF EXISTS ONLY public.lesson_type DROP CONSTRAINT IF EXISTS lesson_type_name_key;
ALTER TABLE IF EXISTS ONLY public.classroom DROP CONSTRAINT IF EXISTS classroom_pkey;
ALTER TABLE IF EXISTS ONLY public.classroom DROP CONSTRAINT IF EXISTS classroom_name_key;
ALTER TABLE IF EXISTS ONLY public.booking DROP CONSTRAINT IF EXISTS booking_pkey;
ALTER TABLE IF EXISTS public.user_group ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.lesson_type ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.classroom ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.booking ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.user_group_id_seq;
DROP TABLE IF EXISTS public.user_group;
DROP SEQUENCE IF EXISTS public.lesson_type_id_seq;
DROP TABLE IF EXISTS public.lesson_type;
DROP SEQUENCE IF EXISTS public.classroom_id_seq;
DROP TABLE IF EXISTS public.classroom;
DROP SEQUENCE IF EXISTS public.booking_id_seq;
DROP TABLE IF EXISTS public.booking;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking (
    id integer NOT NULL,
    classroom_id integer NOT NULL,
    user_group_id integer NOT NULL,
    lesson_type_id integer,
    booking_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    participants integer DEFAULT 0,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT booking_participants_check CHECK ((participants >= 0)),
    CONSTRAINT chk_booking_time CHECK ((end_time > start_time))
);


ALTER TABLE public.booking OWNER TO postgres;

--
-- Name: booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_id_seq OWNER TO postgres;

--
-- Name: booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_id_seq OWNED BY public.booking.id;


--
-- Name: classroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    building character varying(100) NOT NULL,
    capacity integer NOT NULL,
    has_projector boolean DEFAULT false,
    description text,
    CONSTRAINT classroom_capacity_check CHECK ((capacity >= 1))
);


ALTER TABLE public.classroom OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classroom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classroom_id_seq OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classroom_id_seq OWNED BY public.classroom.id;


--
-- Name: lesson_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.lesson_type OWNER TO postgres;

--
-- Name: lesson_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_type_id_seq OWNER TO postgres;

--
-- Name: lesson_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_type_id_seq OWNED BY public.lesson_type.id;


--
-- Name: user_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(255),
    role character varying(50) DEFAULT 'teacher'::character varying NOT NULL
);


ALTER TABLE public.user_group OWNER TO postgres;

--
-- Name: user_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_group_id_seq OWNER TO postgres;

--
-- Name: user_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_group_id_seq OWNED BY public.user_group.id;


--
-- Name: booking id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking ALTER COLUMN id SET DEFAULT nextval('public.booking_id_seq'::regclass);


--
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq'::regclass);


--
-- Name: lesson_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type ALTER COLUMN id SET DEFAULT nextval('public.lesson_type_id_seq'::regclass);


--
-- Name: user_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group ALTER COLUMN id SET DEFAULT nextval('public.user_group_id_seq'::regclass);


--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking (id, classroom_id, user_group_id, lesson_type_id, booking_date, start_time, end_time, participants, description, created_at) FROM stdin;
1	1	1	1	2025-02-10	08:00:00	09:30:00	28	Programmeerimise loeng	2026-02-11 16:10:11.505278
2	2	2	2	2025-02-10	10:00:00	11:30:00	18	Andmebaaside praktikum	2026-02-11 16:10:11.508253
3	3	3	2	2025-02-10	12:00:00	13:30:00	14	Võrgutehnoloogia labor	2026-02-11 16:10:11.509194
4	4	4	3	2025-02-11	08:00:00	09:30:00	22	IT-juhtimise seminar	2026-02-11 16:10:11.5099
5	5	1	1	2025-02-11	10:00:00	11:30:00	30	Veebiarenduse loeng	2026-02-11 16:10:11.510311
6	1	2	4	2025-02-12	08:00:00	10:00:00	25	Andmebaaside eksam	2026-02-11 16:10:11.511035
7	2	3	2	2025-02-12	10:00:00	11:30:00	15	Linuxi praktikum	2026-02-11 16:10:11.511708
8	6	4	5	2025-02-12	14:00:00	15:00:00	5	Individuaalne konsultatsioon	2026-02-11 16:10:11.512242
9	3	1	2	2025-02-13	08:00:00	09:30:00	12	Pythoni praktikum	2026-02-11 16:10:11.51276
10	5	5	3	2025-02-13	10:00:00	12:00:00	32	IT-turbe seminar	2026-02-11 16:10:11.513285
11	1	6	2	2025-02-14	08:00:00	09:30:00	26	TAK25 grupi praktikum	2026-02-11 16:10:11.513829
12	4	7	1	2025-02-14	10:00:00	11:30:00	20	TAK24 grupi loeng	2026-02-11 16:10:11.514317
13	2	1	5	2025-02-14	14:00:00	15:00:00	8	Konsultatsioon enne eksamit	2026-02-11 16:10:11.514711
14	7	8	1	2025-02-17	08:00:00	09:30:00	25	Multimeedia loeng	2026-02-11 16:10:11.515429
15	8	8	2	2025-02-17	10:00:00	11:30:00	16	Rühmatöö praktikum	2026-02-11 16:10:11.515879
\.


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (id, name, building, capacity, has_projector, description) FROM stdin;
1	A-201	A-korpus	30	t	Suur arvutiklass projektori ja kõlaritega
2	A-202	A-korpus	20	t	Keskmine arvutiklass
3	B-101	B-korpus	15	f	Väike arvutiklass laboritöödeks
4	B-102	B-korpus	25	t	Keskmine arvutiklass videokonverentsi seadmetega
5	C-301	C-korpus	35	t	Suur arvutiklass seminari jaoks
6	C-302	C-korpus	10	f	Väike arvutiklass individuaalse tööga
7	D-401	D-korpus	28	t	Uus arvutiklass multimeediaga
8	D-402	D-korpus	18	f	Väike arvutiklass rühmatöödeks
\.


--
-- Data for Name: lesson_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_type (id, name) FROM stdin;
1	Loeng
2	Praktikum
3	Seminar
4	Eksam
5	Konsultatsioon
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group (id, name, email, role) FROM stdin;
1	Mart Tamm	mart.tamm@kool.ee	teacher
2	Liis Kask	liis.kask@kool.ee	teacher
3	Jüri Sepp	juri.sepp@kool.ee	teacher
4	Anne Mets	anne.mets@kool.ee	teacher
5	Toomas Ilves	toomas.ilves@kool.ee	admin
6	TAK25 grupp	tak25@kool.ee	student_group
7	TAK24 grupp	tak24@kool.ee	student_group
8	Piret Põld	piret.pold@kool.ee	teacher
\.


--
-- Name: booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_id_seq', 15, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 8, true);


--
-- Name: lesson_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_type_id_seq', 5, true);


--
-- Name: user_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_group_id_seq', 8, true);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);


--
-- Name: classroom classroom_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_name_key UNIQUE (name);


--
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- Name: lesson_type lesson_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type
    ADD CONSTRAINT lesson_type_name_key UNIQUE (name);


--
-- Name: lesson_type lesson_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type
    ADD CONSTRAINT lesson_type_pkey PRIMARY KEY (id);


--
-- Name: user_group user_group_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT user_group_email_key UNIQUE (email);


--
-- Name: user_group user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (id);


--
-- Name: idx_booking_classroom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_booking_classroom ON public.booking USING btree (classroom_id);


--
-- Name: idx_booking_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_booking_date ON public.booking USING btree (booking_date);


--
-- Name: idx_booking_user_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_booking_user_group ON public.booking USING btree (user_group_id);


--
-- Name: booking booking_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id) ON DELETE CASCADE;


--
-- Name: booking booking_lesson_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_lesson_type_id_fkey FOREIGN KEY (lesson_type_id) REFERENCES public.lesson_type(id) ON DELETE SET NULL;


--
-- Name: booking booking_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_group(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict nOQ0Al9H1XBq4Nw4QzeTcfkz7JJ9RLgCY0upXKqHgBTKfJ8pTrj89FlMNjeifjw

