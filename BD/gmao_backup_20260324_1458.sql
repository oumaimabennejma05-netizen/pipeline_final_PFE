--
-- PostgreSQL database dump
--

\restrict OJHOqmueXdssILR9V2eBIUdXiA96FR4KAwH0v6FtjJKh9AreVe1BbBBbLIGbrmn

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: machine_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.machine_data (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    runtime double precision,
    temperature double precision,
    vibration double precision,
    machine_id bigint NOT NULL,
    tension double precision
);


--
-- Name: machine_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.machine_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: machine_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.machine_data_id_seq OWNED BY public.machine_data.id;


--
-- Name: machines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.machines (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    location character varying(255),
    maintenance_date date,
    model character varying(255),
    name character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT machines_status_check CHECK (((status)::text = ANY (ARRAY[('OPERATIONAL'::character varying)::text, ('MAINTENANCE'::character varying)::text, ('BROKEN'::character varying)::text, ('IDLE'::character varying)::text])))
);


--
-- Name: machines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.machines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.machines_id_seq OWNED BY public.machines.id;


--
-- Name: task_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_history (
    id bigint NOT NULL,
    completed_at timestamp(6) without time zone,
    notes text,
    task_id bigint NOT NULL,
    technician_id bigint
);


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    description text,
    due_date date,
    priority character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    machine_id bigint,
    technician_id bigint,
    created_by_id bigint,
    CONSTRAINT tasks_priority_check CHECK (((priority)::text = ANY (ARRAY[('LOW'::character varying)::text, ('MEDIUM'::character varying)::text, ('HIGH'::character varying)::text, ('CRITICAL'::character varying)::text]))),
    CONSTRAINT tasks_status_check CHECK (((status)::text = ANY (ARRAY[('EN_ATTENTE'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('PENDING_APPROVAL'::character varying)::text, ('COMPLETED'::character varying)::text, ('APPROVED'::character varying)::text, ('CANCELLED'::character varying)::text])))
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    address character varying(255),
    created_at timestamp(6) without time zone,
    email character varying(255) NOT NULL,
    cin character varying(255),
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    profile_picture character varying(255),
    role character varying(255) NOT NULL,
    two_factor_enabled boolean NOT NULL,
    two_factor_secret character varying(255),
    city character varying(255),
    password_reset_token character varying(255),
    password_reset_token_expiry timestamp(6) without time zone,
    postal_code character varying(255),
    uuid character varying(255),
    must_change_password boolean DEFAULT false,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY (ARRAY[('ADMIN'::character varying)::text, ('RESPONSABLE'::character varying)::text, ('TECHNICIAN'::character varying)::text])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: machine_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machine_data ALTER COLUMN id SET DEFAULT nextval('public.machine_data_id_seq'::regclass);


--
-- Name: machines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machines ALTER COLUMN id SET DEFAULT nextval('public.machines_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: machine_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.machine_data (id, created_at, runtime, temperature, vibration, machine_id, tension) FROM stdin;
\.


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.machines (id, created_at, location, maintenance_date, model, name, status) FROM stdin;
8	2026-04-26 16:08:47.293754	Atelier A	2026-05-01	f30	vibrateur	OPERATIONAL
9	2026-04-26 16:09:26.118612	Atelier B	2026-05-10	FANUC-30	Machine CNC	OPERATIONAL
10	2026-04-26 16:10:08.869545	Atelier C	2026-05-03	lenovo	Imprimente	BROKEN
\.


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.task_history (id, completed_at, notes, task_id, technician_id) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, created_at, description, due_date, priority, status, title, machine_id, technician_id, created_by_id) FROM stdin;
18	2026-04-26 16:11:50.266143	reparer l'imprimente	2026-05-10	MEDIUM	EN_ATTENTE	reparation	10	3	2
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, address, created_at, email, cin, name, password, profile_picture, role, two_factor_enabled, two_factor_secret, city, password_reset_token, password_reset_token_expiry, postal_code, uuid, must_change_password) FROM stdin;
3	789 Workshop Ave, Sousse	2026-03-23 20:01:25.301449	tech1@gmao.com	25632554	Karim Sassi	$2a$10$Ubljmy05tOEKrdKGDVOF/eCfqlEbQa6dAvGZQP2yUlELtyU3W1i3m	\N	TECHNICIAN	f	\N	\N	\N	\N	\N	\N	f
2	456 Factory St, Sfax	2026-03-23 20:01:25.300351	responsable@gmao.com	12355688	Mohamed Ali	$2a$10$HYmqTuzwLdO3.QOOrYSSuOUneBo6dfvc89uVdJMTo4ETHLNoZpKsq	\N	RESPONSABLE	f	\N	\N	\N	\N	\N	\N	f
1	123 Industrial Zone, Tunis	2026-03-23 20:01:25.277697	admin@gmao.com	11254552	Admin GMAO	$2a$10$Qe82xiI/LDL3DLmFxrkrG.KHX6LMKmtm86bhqF6apuRf0sCx//VAa	\N	ADMIN	f	\N	\N	\N	\N	\N	\N	f
\.


--
-- Name: machine_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.machine_data_id_seq', 11, true);


--
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.machines_id_seq', 10, true);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.task_history_id_seq', 1, false);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tasks_id_seq', 18, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: machine_data machine_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machine_data
    ADD CONSTRAINT machine_data_pkey PRIMARY KEY (id);


--
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: users uk_6km2m9i3vjuy36rnvkgj1l61s; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6km2m9i3vjuy36rnvkgj1l61s UNIQUE (uuid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: tasks fka01fey26ut89aod3trb9xgris; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fka01fey26ut89aod3trb9xgris FOREIGN KEY (technician_id) REFERENCES public.users(id);


--
-- Name: machine_data fkdix41a7pihf42htbejorsifx0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.machine_data
    ADD CONSTRAINT fkdix41a7pihf42htbejorsifx0 FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- Name: task_history fke6pig0w111eiymhut3w14r485; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT fke6pig0w111eiymhut3w14r485 FOREIGN KEY (technician_id) REFERENCES public.users(id);


--
-- Name: tasks fkgyg8fwxqojakg6ijnc4jsgktt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fkgyg8fwxqojakg6ijnc4jsgktt FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- Name: task_history fkjqraeud129avhcva579fhioj3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT fkjqraeud129avhcva579fhioj3 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: tasks fkmeg3m9hk7eyq7u5kpot87f9ey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fkmeg3m9hk7eyq7u5kpot87f9ey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict OJHOqmueXdssILR9V2eBIUdXiA96FR4KAwH0v6FtjJKh9AreVe1BbBBbLIGbrmn

