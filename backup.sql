--
-- PostgreSQL database dump
--

\restrict oRR3ygHaFXg3KMPQeawsM7PJlZluzK8zqqozRA86rhEhxcu5BdXm50mwFP0a5YZ

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- Name: piece_level; Type: TABLE; Schema: public; Owner: botw
--

CREATE TABLE public.piece_level (
    piece_id text NOT NULL,
    level smallint NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT piece_level_level_check CHECK (((level >= 0) AND (level <= 4)))
);


ALTER TABLE public.piece_level OWNER TO botw;

--
-- Name: skipped_set; Type: TABLE; Schema: public; Owner: botw
--

CREATE TABLE public.skipped_set (
    set_id text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.skipped_set OWNER TO botw;

--
-- Data for Name: piece_level; Type: TABLE DATA; Schema: public; Owner: botw
--

COPY public.piece_level (piece_id, level, updated_at) FROM stdin;
tunica-del-elegido/0	2	2026-11-01 14:34:49.274736+00
barbaro/0	1	2026-11-01 14:34:49.274736+00
barbaro/1	4	2026-11-01 14:34:49.274736+00
barbaro/2	1	2026-11-01 14:34:49.274736+00
escalada/0	2	2026-11-01 14:34:49.274736+00
escalada/1	1	2026-11-01 14:34:49.274736+00
escalada/2	1	2026-11-01 14:34:49.274736+00
desierto/0	1	2026-11-01 14:34:49.274736+00
desierto/1	4	2026-11-01 14:34:49.274736+00
desierto/2	3	2026-11-01 14:34:49.274736+00
ignifugo/0	1	2026-11-01 14:34:49.274736+00
ignifugo/1	3	2026-11-01 14:34:49.274736+00
ignifugo/2	2	2026-11-01 14:34:49.274736+00
aislante/2	4	2026-11-01 14:34:49.274736+00
aislante/1	2	2026-11-01 14:34:49.274736+00
aislante/0	2	2026-11-01 14:34:49.274736+00
orni/0	3	2026-11-01 14:34:49.274736+00
orni/1	2	2026-11-01 14:34:49.274736+00
orni/2	2	2026-11-01 14:34:49.274736+00
zora/2	2	2026-11-01 14:34:49.274736+00
zora/1	2	2026-11-01 14:34:49.274736+00
zora/0	2	2026-11-01 14:34:49.274736+00
hyliano-ropa/2	3	2026-11-01 14:34:49.274736+00
hyliano-ropa/1	4	2026-11-01 14:34:49.274736+00
hyliano-ropa/0	4	2026-11-01 14:34:49.274736+00
sigilo/0	1	2026-11-01 14:34:49.274736+00
sigilo/1	1	2026-11-01 14:34:49.274736+00
sigilo/2	3	2026-11-01 14:34:49.274736+00
diadema-de-rubi/0	2	2026-11-01 14:34:49.274736+00
\.


--
-- Data for Name: skipped_set; Type: TABLE DATA; Schema: public; Owner: botw
--

COPY public.skipped_set (set_id, updated_at) FROM stdin;
ancestral	2026-11-01 14:34:49.274736+00
luminoso	2026-11-01 14:34:49.274736+00
hyliano-armadura	2026-11-01 14:34:49.274736+00
diadema-de-zafiro	2026-11-01 14:34:49.274736+00
diadema-de-diamante	2026-11-01 14:34:49.274736+00
pendientes-de-ambar	2026-11-01 14:34:49.274736+00
pendientes-de-opalo	2026-11-01 14:34:49.274736+00
botas-de-nieve	2026-11-01 14:34:49.274736+00
pendientes-de-topacio	2026-11-01 14:34:49.274736+00
\.


--
-- Name: piece_level piece_level_pkey; Type: CONSTRAINT; Schema: public; Owner: botw
--

ALTER TABLE ONLY public.piece_level
    ADD CONSTRAINT piece_level_pkey PRIMARY KEY (piece_id);


--
-- Name: skipped_set skipped_set_pkey; Type: CONSTRAINT; Schema: public; Owner: botw
--

ALTER TABLE ONLY public.skipped_set
    ADD CONSTRAINT skipped_set_pkey PRIMARY KEY (set_id);


--
-- PostgreSQL database dump complete
--

\unrestrict oRR3ygHaFXg3KMPQeawsM7PJlZluzK8zqqozRA86rhEhxcu5BdXm50mwFP0a5YZ

