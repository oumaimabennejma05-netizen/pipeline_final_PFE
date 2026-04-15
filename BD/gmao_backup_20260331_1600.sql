--
-- PostgreSQL database dump
--

\restrict YZAmAUEdmhYMLGctxVxcIc3fftza4O5aCrOEzKrCUHItbZZlyy8T70QgM6mfaGO

-- Dumped from database version 15.17 (Ubuntu 15.17-1.pgdg24.04+1)
-- Dumped by pg_dump version 15.17 (Ubuntu 15.17-1.pgdg24.04+1)

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
    machine_id bigint NOT NULL
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
    CONSTRAINT tasks_priority_check CHECK (((priority)::text = ANY (ARRAY[('LOW'::character varying)::text, ('MEDIUM'::character varying)::text, ('HIGH'::character varying)::text, ('CRITICAL'::character varying)::text]))),
    CONSTRAINT tasks_status_check CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('PENDING_APPROVAL'::character varying)::text, ('COMPLETED'::character varying)::text, ('APPROVED'::character varying)::text, ('CANCELLED'::character varying)::text])))
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
    id_number character varying(255),
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
    must_change_password boolean DEFAULT false NOT NULL,
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

COPY public.machine_data (id, created_at, runtime, temperature, vibration, machine_id) FROM stdin;
1	2026-03-23 20:01:25.314503	950	87.5	3.2	1
2	2026-03-23 20:01:25.318566	948	85	3	1
3	2026-03-23 20:01:25.321028	320	55	2.1	2
4	2026-03-23 20:01:25.323958	318	53	2	2
5	2026-03-23 20:01:25.326595	1100	65	8.9	3
6	2026-03-23 20:01:25.328692	1098	68	9.1	3
7	2026-03-23 20:01:25.33105	820	72	4.8	4
8	2026-03-23 20:01:25.333125	1350	95	7.5	5
\.


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.machines (id, created_at, location, maintenance_date, model, name, status) FROM stdin;
4	2026-03-23 20:01:25.31106	Utility Room	2026-06-23	ATLAS-GA55	Air Compressor Delta	OPERATIONAL
5	2026-03-23 20:01:25.311823	Assembly Line	2026-03-23	INTRALOX-T500	Conveyor Belt Epsilon	OPERATIONAL
3	2026-03-23 20:01:25.310324	Press Room	2026-03-18	ENERPAC-P142	Hydraulic Press Gamma	IDLE
1	2026-03-23 20:01:25.308196	Workshop A	2026-05-23	FANUC-30i	CNC Machine Alpha	BROKEN
2	2026-03-23 20:01:25.309486	Workshop B	2026-04-23	DMG-CLX500	Lathe Machine Beta	BROKEN
\.


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.task_history (id, completed_at, notes, task_id, technician_id) FROM stdin;
1	2026-03-23 20:31:53.468382	Task submitted for approval	1	3
2	2026-03-23 20:32:23.522228	Task approved by responsable	1	2
3	2026-03-28 13:54:07.194274	;lmml	6	2
4	2026-03-28 13:54:59.404484	ok\n	6	5
5	2026-03-28 14:35:21.903352	Task submitted for approval	6	5
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, created_at, description, due_date, priority, status, title, machine_id, technician_id) FROM stdin;
2	2026-03-23 20:01:25.340572	Critical vibration detected. Inspect bearings, mounting, and hydraulic seals.	2026-03-23	CRITICAL	PENDING	Hydraulic Press Emergency Maintenance	3	4
4	2026-03-23 20:01:25.34616	Perform monthly lubrication routine on DMG CLX500 lathe machine.	2026-03-20	LOW	COMPLETED	Lathe Monthly Lubrication	2	4
5	2026-03-23 20:01:25.347615	Replace air filters on Atlas GA55 compressor. Runtime approaching maintenance threshold.	2026-03-30	MEDIUM	PENDING	Compressor Filter Replacement	4	3
3	2026-03-23 20:01:25.344843	Conveyor belt has stopped. Diagnose fault and replace damaged components.	2026-03-23	CRITICAL	IN_PROGRESS	Conveyor Belt Repair	5	3
1	2026-03-23 20:01:25.335488	Inspect and clean cooling system on CNC Machine Alpha. Temperature trending above warning threshold.	2026-03-25	HIGH	APPROVED	CNC Temperature Inspection	1	3
7	2026-03-28 14:33:51.554874		2026-03-28	HIGH	PENDING	zaza	1	5
6	2026-03-28 13:53:50.021049		2026-04-02	HIGH	PENDING_APPROVAL	12	2	5
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, address, created_at, email, id_number, name, password, profile_picture, role, two_factor_enabled, two_factor_secret, city, password_reset_token, password_reset_token_expiry, postal_code, uuid, must_change_password) FROM stdin;
3	789 Workshop Ave, Sousse	2026-03-23 20:01:25.301449	tech1@gmao.com	TCH001	Karim Sassi	$2a$10$Ubljmy05tOEKrdKGDVOF/eCfqlEbQa6dAvGZQP2yUlELtyU3W1i3m	\N	TECHNICIAN	f	\N	\N	\N	\N	\N	31c93160-3c76-4938-8e8a-b6e0efbc8314	f
4	321 Maintenance Rd, Monastir	2026-03-23 20:01:25.302539	tech2@gmao.com	TCH002	Amira Ben Salah	$2a$10$NuDI9iwiQ6IMmAgQsuyxeuATrQVfHzai/BzkvN2Bi4HsBBab9RVsu	\N	TECHNICIAN	f	\N	\N	\N	\N	\N	984c26fd-6f4d-40b7-9a16-e6300993b321	f
8	9 av charles peguy	2026-03-28 16:41:55.986674	grassanordine@gmail.com	15425256	nordine grassa	$2a$10$bWX0TM.W.TzY24oOTNuAduLBnsdOthC21WiOEr0Z4Wq2plMxbZQUq	\N	RESPONSABLE	f	\N	LA GARENNE COLOMBES	490a0015-5729-470c-b83a-884a078164aa	2026-03-28 17:43:28.458266	92250	b7e679df-9002-42f2-a787-d4fc5dd01fa1	f
6	Rue tarak ibno zied 	2026-03-28 14:04:56.239769	oumaimabennejma05@gmail.com	12345678	oumaima ben nejma 	$2a$10$IDO30w5Y03eGNdzcMxdZJ.cx.SSJnJniMtMS067plinJmq4zInzNu	/uploads/profile-pictures/acb82a33-7faa-477c-815f-872bc903a6e8_1774713344022.jpg	RESPONSABLE	f	\N	Manzel Bourghiba 	aa95e388-3972-4fe5-82a0-c9a002d8bc25	2026-03-28 15:30:20.34774	5070	acb82a33-7faa-477c-815f-872bc903a6e8	f
1	123 Industrial Zone, Tunis	2026-03-23 20:01:25.277697	admin@gmao.com	ADM001	Admin GMAO	$2a$10$Qe82xiI/LDL3DLmFxrkrG.KHX6LMKmtm86bhqF6apuRf0sCx//VAa	\N	ADMIN	f	\N	\N	\N	\N	\N	2656abbb-1ac0-4b32-bd30-4b54c7154759	f
2	456 Factory St, Sfax	2026-03-23 20:01:25.300351	responsable@gmao.com	RSP001	Mohamed Ali	$2a$10$HYmqTuzwLdO3.QOOrYSSuOUneBo6dfvc89uVdJMTo4ETHLNoZpKsq	\N	RESPONSABLE	f	\N	\N	\N	\N	\N	e725d6a7-0cb4-44aa-b2a0-3027326d1b54	f
5	80 rue de la résistance	2026-03-28 13:51:02.251093	souatarek@yahoo.fr	87979797	Tarek soua	$2a$10$VixdvRzsDpp1bGu4mVXWtOA8LKrfe.fcfetPZHAKpSL.m.umy//zi	/uploads/profile-pictures/dabf44f2-ab2b-42b0-a2c8-8411f4fd7811_1774702263275.jpg	TECHNICIAN	f	\N	Dammarie-les-Lys	2a14e865-1cc5-455d-9ece-918dbaef521b	2026-03-28 15:00:48.903276	77190	dabf44f2-ab2b-42b0-a2c8-8411f4fd7811	f
9	38 avenue libert	2026-03-28 16:57:06.463001	sousou@gmail.com	12365478	sousou	$2a$10$QSF31QC9ZOy669/qOaOZpuMo5qQVnul0Q8pGpHxk3CB2L5yVsacRy	/uploads/profile-pictures/61e43c32-0fda-4007-90c3-c2773787d58c_1774713502753.jpg	TECHNICIAN	f	\N	draveil	\N	\N	91210	61e43c32-0fda-4007-90c3-c2773787d58c	f
7	9 av charles peguy	2026-03-28 14:32:29.20454	amelmradmm@gmail.com	78945678	amel mrad	$2a$10$46srhGaR8vYgNV8a4E6Tg.avpwKHZH6/rAKAQr4gJ0pPVcBVj0S.2	\N	RESPONSABLE	f	\N	LA GARENNE COLOMBES	\N	\N	92250	89809c0a-1927-4958-82d8-0eace79d0f4f	f
10	9 av charles peguy	2026-03-31 15:28:58.795862	asma@gmao.com	15528952	asma	$2a$10$7jzCJPV6De7003oLc1KZ7Oygjf6ziTknZF6dqsma1qktbCzPB6jfS	\N	RESPONSABLE	f	\N	LA GARENNE COLOMBES	\N	\N	92250	62263137-0ff3-4819-a402-7fc2be90fc96	t
\.


--
-- Name: machine_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.machine_data_id_seq', 8, true);


--
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.machines_id_seq', 5, true);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.task_history_id_seq', 5, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tasks_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


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
-- PostgreSQL database dump complete
--

\unrestrict YZAmAUEdmhYMLGctxVxcIc3fftza4O5aCrOEzKrCUHItbZZlyy8T70QgM6mfaGO

