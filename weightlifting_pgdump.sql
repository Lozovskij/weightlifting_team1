--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 10.14 (Ubuntu 10.14-0ubuntu0.18.04.1)

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

--
-- Name: unique_short_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unique_short_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

 -- Declare the variables we'll be using.
DECLARE
  key TEXT;
  qry TEXT;
  found TEXT;
BEGIN

  -- generate the first part of a query as a string with safely
  -- escaped table name, using || to concat the parts
  qry := 'SELECT id FROM ' || quote_ident(TG_TABLE_NAME) || ' WHERE id=';

  -- This loop will probably only run once per call until we've generated
  -- millions of ids.
  LOOP

    -- Generate our string bytes and re-encode as a base64 string.
    key := encode(gen_random_bytes(6), 'base64');

    -- Base64 encoding contains 2 URL unsafe characters by default.
    -- The URL-safe version has these replacements.
    key := replace(key, '/', '_'); -- url safe replacement
    key := replace(key, '+', '-'); -- url safe replacement

    -- Concat the generated key (safely quoted) with the generated query
    -- and run it.
    -- SELECT id FROM "test" WHERE id='blahblah' INTO found
    -- Now "found" will be the duplicated id or NULL.
    EXECUTE qry || quote_literal(key) INTO found;

    -- Check to see if found is NULL.
    -- If we checked to see if found = NULL it would always be FALSE
    -- because (NULL = NULL) is always FALSE.
    IF found IS NULL THEN

      -- If we didn't find a collision then leave the LOOP.
      EXIT;
    END IF;

    -- We haven't EXITed yet, so return to the top of the LOOP
    -- and try again.
  END LOOP;

  -- NEW and OLD are available in TRIGGER PROCEDURES.
  -- NEW is the mutated row that will actually be INSERTed.
  -- We're replacing id, regardless of what it was before
  -- with our key variable.
  NEW.id = key;

  -- The RECORD returned here is what will actually be INSERTed,
  -- or what the next trigger will get if there is one.
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.unique_short_id() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._migrations (
    name text NOT NULL,
    date timestamp without time zone
);


ALTER TABLE public._migrations OWNER TO postgres;

--
-- Name: athlete_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.athlete_comments (
    id integer NOT NULL,
    content character varying NOT NULL,
    date timestamp with time zone NOT NULL,
    userid integer,
    athleteid integer,
    ban boolean,
    updated integer
);


ALTER TABLE public.athlete_comments OWNER TO postgres;

--
-- Name: athlete_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.athlete_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.athlete_comments_id_seq OWNER TO postgres;

--
-- Name: athlete_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.athlete_comments_id_seq OWNED BY public.athlete_comments.id;


--
-- Name: athletes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.athletes (
    id integer NOT NULL,
    name character varying,
    country_id integer,
    about text,
    birth_date date,
    image_url text,
    name_en character varying,
    sex character varying NOT NULL
);


ALTER TABLE public.athletes OWNER TO postgres;

--
-- Name: athletes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.athletes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.athletes_id_seq OWNER TO postgres;

--
-- Name: athletes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.athletes_id_seq OWNED BY public.athletes.id;


--
-- Name: attempt_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attempt_category (
    attempt_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.attempt_category OWNER TO postgres;

--
-- Name: attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attempts (
    result real NOT NULL,
    athlete_id integer NOT NULL,
    id integer NOT NULL,
    date date,
    competition_id integer,
    exercise_id integer NOT NULL,
    athlete_weight real,
    source_info text,
    is_win_result boolean,
    athlete_country_id integer,
    is_dsq boolean DEFAULT false NOT NULL,
    added timestamp without time zone,
    added_by integer,
    has_video boolean DEFAULT false NOT NULL,
    failed boolean DEFAULT false NOT NULL,
    updated timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.attempts OWNER TO postgres;

--
-- Name: attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attempts_id_seq OWNER TO postgres;

--
-- Name: attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attempts_id_seq OWNED BY public.attempts.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    url text,
    data text,
    data_type character varying(4),
    last_update timestamp without time zone
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    content character varying NOT NULL,
    date timestamp with time zone NOT NULL,
    userid integer,
    attemptid integer,
    ban boolean,
    updated integer
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: competition_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competition_types (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.competition_types OWNER TO postgres;

--
-- Name: competition_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.competition_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.competition_types_id_seq OWNER TO postgres;

--
-- Name: competition_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.competition_types_id_seq OWNED BY public.competition_types.id;


--
-- Name: competitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competitions (
    name text,
    place_id integer,
    id integer NOT NULL,
    type integer,
    date_end date,
    date_start date,
    source_info text,
    is_end boolean DEFAULT false
);


ALTER TABLE public.competitions OWNER TO postgres;

--
-- Name: competitions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.competitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.competitions_id_seq OWNER TO postgres;

--
-- Name: competitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.competitions_id_seq OWNED BY public.competitions.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying,
    short_name character varying,
    short_name_2 character varying,
    "exists" boolean NOT NULL,
    ru_name character varying
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: disqualifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disqualifications (
    id integer NOT NULL,
    reason character varying,
    attempt_id integer
);


ALTER TABLE public.disqualifications OWNER TO postgres;

--
-- Name: disqualifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disqualifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disqualifications_id_seq OWNER TO postgres;

--
-- Name: disqualifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.disqualifications_id_seq OWNED BY public.disqualifications.id;


--
-- Name: email_approvals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_approvals (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    email character varying NOT NULL,
    user_id integer NOT NULL,
    created timestamp without time zone NOT NULL,
    approved boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email_approvals OWNER TO postgres;

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercises (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.exercises OWNER TO postgres;

--
-- Name: exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exercises_id_seq OWNER TO postgres;

--
-- Name: exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exercises_id_seq OWNED BY public.exercises.id;


--
-- Name: filters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filters (
    id text NOT NULL,
    filter jsonb
);


ALTER TABLE public.filters OWNER TO postgres;

--
-- Name: periods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periods (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.periods OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.periods_id_seq OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periods_id_seq OWNED BY public.periods.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.places (
    id integer NOT NULL,
    name character varying,
    country_id integer
);


ALTER TABLE public.places OWNER TO postgres;

--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.places_id_seq OWNER TO postgres;

--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;


--
-- Name: record_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_types (
    name character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.record_types OWNER TO postgres;

--
-- Name: record_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_types_id_seq OWNER TO postgres;

--
-- Name: record_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_types_id_seq OWNED BY public.record_types.id;


--
-- Name: records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.records (
    id integer NOT NULL,
    attempt_id integer NOT NULL,
    category_id integer NOT NULL,
    record_type integer NOT NULL,
    exercise_id integer NOT NULL,
    active boolean DEFAULT false,
    added timestamp without time zone NOT NULL
);


ALTER TABLE public.records OWNER TO postgres;

--
-- Name: records_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.records_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.records_category_id_seq OWNER TO postgres;

--
-- Name: records_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.records_category_id_seq OWNED BY public.records.category_id;


--
-- Name: records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.records_id_seq OWNER TO postgres;

--
-- Name: records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.records_id_seq OWNED BY public.records.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_name character varying NOT NULL,
    email character varying,
    password_hash character varying,
    is_admin boolean DEFAULT false,
    is_moderator boolean DEFAULT false,
    email_is_approved boolean DEFAULT false,
    created timestamp without time zone NOT NULL,
    activated boolean DEFAULT false NOT NULL,
    social_auth character varying,
    token character varying,
    profile_id character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: weight_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weight_categories (
    id integer NOT NULL,
    period_id integer NOT NULL,
    from_w real,
    to_w real,
    active boolean NOT NULL,
    type character varying NOT NULL,
    name character varying
);


ALTER TABLE public.weight_categories OWNER TO postgres;

--
-- Name: weight_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weight_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weight_categories_id_seq OWNER TO postgres;

--
-- Name: weight_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weight_categories_id_seq OWNED BY public.weight_categories.id;


--
-- Name: athlete_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athlete_comments ALTER COLUMN id SET DEFAULT nextval('public.athlete_comments_id_seq'::regclass);


--
-- Name: athletes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athletes ALTER COLUMN id SET DEFAULT nextval('public.athletes_id_seq'::regclass);


--
-- Name: attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts ALTER COLUMN id SET DEFAULT nextval('public.attempts_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: competition_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competition_types ALTER COLUMN id SET DEFAULT nextval('public.competition_types_id_seq'::regclass);


--
-- Name: competitions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competitions ALTER COLUMN id SET DEFAULT nextval('public.competitions_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: disqualifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disqualifications ALTER COLUMN id SET DEFAULT nextval('public.disqualifications_id_seq'::regclass);


--
-- Name: exercises id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises ALTER COLUMN id SET DEFAULT nextval('public.exercises_id_seq'::regclass);


--
-- Name: periods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods ALTER COLUMN id SET DEFAULT nextval('public.periods_id_seq'::regclass);


--
-- Name: places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: record_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types ALTER COLUMN id SET DEFAULT nextval('public.record_types_id_seq'::regclass);


--
-- Name: records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records ALTER COLUMN id SET DEFAULT nextval('public.records_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: weight_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_categories ALTER COLUMN id SET DEFAULT nextval('public.weight_categories_id_seq'::regclass);


--
-- Data for Name: _migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._migrations (name, date) FROM stdin;
init	2020-09-21 21:10:43.058
add-social-col	2020-09-21 21:10:43.073
add-token-col	2020-09-21 21:10:43.078
add-profileid-col	2020-09-21 21:10:43.083
set filters table	2020-09-21 21:10:43.088
rename-short_urls-table	2020-09-21 21:10:43.093
add-home-filters	2020-09-21 21:10:43.101
update default filters	2020-09-21 21:10:43.115
remove length constraints	2020-09-21 21:10:43.192
add-comments-table	2020-09-21 21:10:43.212
expand-comments-table-add-banned	2020-09-21 21:10:43.218
add-athlete-comments-table	2020-09-21 21:10:43.24
fake-user-content	2020-09-21 21:10:43.244
update-comments-tables	2020-09-21 21:10:43.254
update exersise table	2020-09-21 21:10:43.271
update-exercises-table-first-letter	2020-09-21 21:10:43.281
translate default filters	2020-09-21 21:10:43.292
add-cache-table	2020-09-21 21:10:43.306
add-disqualifications-table	2020-09-21 21:10:43.322
is end competition column	2020-09-21 21:10:43.345
add-ru-name-countries-col	2020-09-21 21:10:43.355
translate-countries	2020-09-21 21:10:43.455
add-expiration-col	2020-09-21 21:10:43.458
update-exarcises-table-remove-amp	2020-09-21 21:10:43.461
\.


--
-- Data for Name: athlete_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.athlete_comments (id, content, date, userid, athleteid, ban, updated) FROM stdin;
\.


--
-- Data for Name: athletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.athletes (id, name, country_id, about, birth_date, image_url, name_en, sex) FROM stdin;
115	DIMAS Pyrros	58	\N	1971-10-13	\N	DIMAS Pyrros	men
116	ASANIDZE George	59	\N	1975-08-30	\N	ASANIDZE George	men
117	BAGHERI Kouroush	75	\N	1977-01-01	\N	BAGHERI Kouroush	men
27	WU Jingbiao	91		1989-09-30	\N	WU Jingbiao	men
33	OM Yun Chol	97	\N	1991-11-18	\N	OM Yun Chol	men
35	LONG Qingquan	91	\N	1990-12-03	\N	LONG Qingquan	men
36	KIM Un Guk	97	\N	1988-10-28	\N	KIM Un Guk	men
37	SHI Zhiyong	91	\N	1980-02-10	\N	SHI Zhiyong	men
38	CHEN Lijun	91	\N	1993-02-08	\N	CHEN Lijun	men
39	LE Maosheng	91	\N	1978-08-09	\N	LE Maosheng	men
40	ZHANG Jie	91	\N	1987-08-26	\N	ZHANG Jie	men
41	LIAO Hui	91	\N	1987-10-05	\N	LIAO Hui	men
42	MARKOV Georgi	26	\N	1978-03-12	\N	MARKOV Georgi	men
43	ZHANG Guozheng	91	\N	1975-09-17	\N	ZHANG Guozheng	men
44	BOEVSKI Galabin	26	\N	1974-12-19	\N	BOEVSKI Galabin	men
45	LYU Xiaojun	91	\N	1984-07-27	\N	LYU Xiaojun	men
46	FILIMONOV Sergey	82	\N	1975-02-02	\N	FILIMONOV Sergey	men
47	RAHIMOV Nijat	82	\N	1993-08-13	\N	RAHIMOV Nijat	men
48	PEREPETCHENOV Oleg	170	\N	1975-09-06	\N	PEREPETCHENOV Oleg	men
49	JELIAZKOV Plamen	26	\N	1972-05-14	\N	JELIAZKOV Plamen	men
50	RYBAKOV Andrei	21	\N	1982-03-04	\N	RYBAKOV Andrei	men
51	ROSTAMI Kianoush	75	\N	1991-07-23	\N	ROSTAMI Kianoush	men
52	ZHANG Yong	91	\N	1974-01-01	\N	ZHANG Yong	men
53	LU Yong	91	\N	1986-01-01	\N	LU Yong	men
54	KAKIASVILIS Akakios	58	\N	1969-07-13	\N	KAKIASVILIS Akakios	men
55	KOLECKI Szymon	166	\N	1981-09-30	\N	KOLECKI Szymon	men
56	ARAMNAU Andrei	21	\N	1988-04-17	\N	ARAMNAU Andrei	men
57	DOLEGA Marcin	166	\N	1982-07-18	\N	DOLEGA Marcin	men
58	ILYIN Ilya	82	\N	1988-05-24	\N	ILYIN Ilya	men
60	NURUDINOV Ruslan	214	\N	1991-11-24	\N	NURUDINOV Ruslan	men
61	BEDZHANYAN David	170	\N	1988-09-06	\N	BEDZHANYAN David	men
62	TSAGAEV Alan	26	\N	1977-09-13	\N	TSAGAEV Alan	men
63	GOTFRID Denys	215	\N	1975-01-01	\N	GOTFRID Denys	men
64	TALAKHADZE Lasha	59	\N	1993-10-02	\N	TALAKHADZE Lasha	men
65	SALIMIKORDASIABI Behdad	75	\N	1989-12-08	\N	SALIMIKORDASIABI Behdad	men
67	YANG Lian	91	\N	1982-10-16	\N	YANG Lian	women
68	TAYLAN Nurcan	212	\N	1983-10-29	\N	TAYLAN Nurcan	women
69	CHEN Xiexia	91	\N	1983-01-08	\N	CHEN Xiexia	women
70	WANG Mingjuan	91	\N	1985-05-21	\N	WANG Mingjuan	women
71	LI Zhuo	91	\N	1981-12-04	\N	LI Zhuo	women
72	LI Ping	91	\N	1988-09-15	\N	LI Ping	women
73	RI Song-Hui	97	\N	1978-12-03	\N	RI Song-Hui	women
74	CHINSHANLO Zulfiya	82	\N	1993-07-25	\N	CHINSHANLO Zulfiya	women
75	QIU Hongxia	91	\N	1982-02-10	\N	QIU Hongxia	women
76	LI Xuejiu	91	\N	1980-05-15	\N	LI Xuejiu	women
77	HSU Shu-Ching	202	\N	1991-05-09	\N	HSU Shu-Ching	women
78	YANG Xia	91	\N	1977-01-01	\N	YANG Xia	women
79	KOSTOVA Boyanka Minkova	4	\N	1993-05-10	\N	KOSTOVA Boyanka Minkova	women
80	CHEN Yanqing	91	\N	1979-04-05	\N	CHEN Yanqing	women
81	WANG Li	91	\N	1985-09-10	\N	WANG Li	women
82	QIU Hongmei	91	\N	1983-03-02	\N	QIU Hongmei	women
83	GU Wei	91	\N	1986-04-25	\N	GU Wei	women
84	KAMEAIM Wandee	201	\N	1978-01-18	\N	KAMEAIM Wandee	women
85	SUN Caiyan	91	\N	1974-01-18	\N	SUN Caiyan	women
86	TSARUKAEVA Svetlana	170	\N	1987-12-25	\N	TSARUKAEVA Svetlana	women
87	THONGSUK Pawina	201	\N	1979-04-18	\N	THONGSUK Pawina	women
88	BATSIUSHKA Hanna	21	\N	1981-10-24	\N	BATSIUSHKA Hanna	women
89	DENG Wei	91	\N	1993-02-14	\N	DENG Wei	women
90	LIN Tzu Chi	202	\N	1988-03-19	\N	LIN Tzu Chi	women
91	MANEZA Maiya	82	\N	1985-11-01	\N	MANEZA Maiya	women
92	SHIMKOVA Svetlana	170	\N	1983-09-18	\N	SHIMKOVA Svetlana	women
93	SKAKUN Nataliya	215	\N	1981-08-03	\N	SKAKUN Nataliya	women
94	LIU Haixia	91	\N	1980-10-23	\N	LIU Haixia	women
95	LIU Xia	91	\N	1981-01-16	\N	LIU Xia	women
96	LIU Chunhong	91	\N	1985-01-29	\N	LIU Chunhong	women
97	SLIVENKO Oxana	170	\N	1986-12-20	\N	SLIVENKO Oxana	women
98	KASAEVA Zarema	170	\N	1987-02-25	\N	KASAEVA Zarema	women
99	ZABOLOTNAYA Natalya	170	\N	1985-08-15	\N	ZABOLOTNAYA Natalya	women
100	PODOBEDOVA Svetlana	82	\N	1986-05-25	\N	PODOBEDOVA Svetlana	women
101	KIM Un Ju	97	\N	1989-11-11	\N	KIM Un Ju	women
102	EVSTYUKHINA Nadezda	170	\N	1988-05-27	\N	EVSTYUKHINA Nadezda	women
104	SUN Ruiping	91	\N	1981-01-05	\N	SUN Ruiping	women
106	SHAIMARDANOVA Victoria	215	\N	1973-10-11	\N	SHAIMARDANOVA Victoria	women
107	KHURSHUDYAN Hripsime	14	\N	1987-07-27	\N	KHURSHUDYAN Hripsime	women
108	KASHIRINA Tatiana	170	\N	1991-01-24	\N	KASHIRINA Tatiana	women
28	Мутлу Халиль	212	\N	1973-07-14	\N	MUTLU Halil	men
109	FIGUEROA MOSQUERA Oscar Albeiro	93	\N	1983-04-27	\N	FIGUEROA MOSQUERA Oscar Albeiro	men
110	ZHANG Xiangxiang	91	\N	1983-07-16	\N	ZHANG Xiangxiang	men
111	PESHALOV Nikolay	227	\N	1970-05-30	\N	PESHALOV Nikolay	men
112	SAGIR Taner	212	\N	1985-03-13	\N	SAGIR Taner	men
113	ZHAN Xugang	91	\N	1974-05-15	\N	ZHAN Xugang	men
114	TIAN Tao	91	\N	1994-04-08	\N	TIAN Tao	men
118	DOBREV Milen	26	\N	1980-02-22	\N	DOBREV Milen	men
66	REZA ZADEH Hossein	75		1978-05-12	\N	REZA ZADEH Hossein	men
119	LI Yajun	91	\N	1993-04-27	\N	LI Yajun	women
120	PRAPAWADEE Jaroenrattanatarakoon	201	\N	1984-05-29	\N	PRAPAWADEE Jaroenrattanatarakoon	women
121	SRISURAT Sukanya	201	\N	1995-05-03	\N	SRISURAT Sukanya	women
122	CHOE Hyo Sim	97	\N	1993-12-05	\N	CHOE Hyo Sim	women
123	GORICHEVA Karina	82	\N	1993-04-08	\N	GORICHEVA Karina	women
124	CHEN Xiaomin	91	\N	1977-02-07	\N	CHEN Xiaomin	women
125	CAO Lei	91	\N	1983-12-24	\N	CAO Lei	women
126	ZHOU Lulu	91	\N	1988-03-19	\N	ZHOU Lulu	women
127	JANG Mi-Ran	98	\N	1983-10-09	\N	JANG Mi-Ran	women
\.


--
-- Data for Name: attempt_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attempt_category (attempt_id, category_id) FROM stdin;
219	11
223	11
224	11
226	11
235	12
255	12
349	13
349	65
351	13
351	65
147	7
135	6
138	6
129	4
323	6
320	5
109	2
97	1
321	5
113	3
133	5
119	3
117	3
111	3
120	3
319	4
114	3
116	3
124	4
122	4
317	4
153	7
127	4
125	4
136	6
137	6
134	5
142	6
143	6
146	6
115	3
150	7
107	2
151	7
182	9
158	34
312	2
161	34
168	8
170	8
165	34
160	34
167	8
177	8
169	8
171	8
176	8
172	8
173	8
175	8
282	1
174	8
178	8
306	1
194	9
190	9
184	9
180	9
189	9
183	9
186	9
193	9
185	9
187	9
188	9
195	10
213	10
205	10
212	10
214	10
308	1
199	10
211	10
302	33
201	10
202	10
210	10
200	10
209	10
204	10
206	10
207	10
203	10
227	12
217	11
220	11
221	11
80	33
229	12
228	12
230	12
231	12
233	12
232	12
234	12
159	34
237	12
238	12
236	12
325	7
268	33
269	33
270	33
291	2
244	12
278	1
284	1
292	2
245	12
250	12
242	12
246	12
248	12
247	12
239	12
240	12
252	12
254	12
253	12
243	12
251	12
241	12
249	12
276	1
283	1
262	33
123	4
131	4
144	6
164	34
163	34
155	34
191	9
192	9
181	9
162	34
196	10
293	11
222	11
346	13
346	64
305	33
309	1
304	33
310	1
307	1
303	33
318	4
316	4
313	3
314	3
315	3
322	5
324	6
350	13
326	34
327	8
328	8
329	8
330	9
331	9
350	65
333	9
334	9
335	9
336	9
337	10
338	10
339	10
340	10
341	10
342	10
343	12
344	12
345	12
347	13
347	64
348	13
348	64
152	7
141	6
366	13
366	65
367	13
367	65
368	13
368	65
369	13
369	65
370	13
370	65
371	13
371	65
372	13
372	65
373	13
373	65
374	13
374	65
375	13
375	65
376	13
376	65
377	13
377	65
273	33
285	1
112	3
118	3
130	4
145	6
154	7
156	34
157	34
166	34
179	8
197	10
198	10
208	10
215	11
216	11
218	11
132	5
121	4
126	4
128	4
110	3
286	2
289	2
287	2
311	2
280	1
277	1
301	33
271	33
140	6
139	6
378	5
70	33
149	7
148	7
\.


--
-- Data for Name: attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attempts (result, athlete_id, id, date, competition_id, exercise_id, athlete_weight, source_info, is_win_result, athlete_country_id, is_dsq, added, added_by, has_video, failed, updated, updated_by) FROM stdin;
175	45	112	2012-08-01	22	1	76.6200027	\N	t	91	f	2017-05-08 14:30:25.485	18	f	f	2017-05-17 23:37:38.395	18
359	41	107	2014-11-10	24	3	68.6800003	<p><iframe src="https://www.youtube.com/embed/jmTRWHFjfec" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-08 14:30:25.469	18	t	f	2017-05-19 22:28:37.904	18
379	45	118	2012-08-01	22	3	76.6200027	\N	t	91	f	2017-05-08 14:30:25.508	18	f	f	2017-05-17 23:39:11.676	18
242	58	139	2014-11-15	24	2	104.349998	<p><iframe src="https://www.youtube.com/embed/0jSmW_2eQWk" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	82	f	2017-05-08 14:30:25.574	18	t	f	2017-05-20 00:18:52.845	18
394	53	130	2008-08-15	37	3	84.4100037	\N	t	91	f	2017-05-08 14:30:25.546	18	f	f	2017-05-17 23:45:07.614	18
220	51	126	2016-05-31	35	2	84.4700012	<p><iframe src="https://www.youtube.com/embed/vA11-9yOs6o?start=73&amp;end=90" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	75	f	2017-05-08 14:30:25.535	18	t	f	2017-05-19 20:11:33.348	18
436	56	145	2008-08-18	37	3	104.760002	\N	t	21	f	2017-05-08 14:30:25.597	18	f	f	2017-05-17 23:47:37.439	18
396	51	128	2016-08-12	18	3	84.2600021	<p><a title="youtube" href="https://youtu.be/Ap1Fpb0VDk8" target="_blank" rel="noopener noreferrer">youtube</a></p>	t	75	f	2017-05-08 14:30:25.54	18	t	f	2017-05-19 20:22:22.119	18
217	64	147	2017-04-08	42	1	158.100006	<p><iframe src="https://www.youtube.com/embed/Vl4KB5_tSc8" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	59	f	2017-05-08 14:30:25.604	18	t	f	2017-05-18 00:28:26.617	18
188	54	132	1999-11-27	27	1	92.9599991	<p><iframe src="https://www.youtube.com/embed/e4I8KfFNF9o?start=95&amp;end=127" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	58	f	2017-05-08 14:30:25.552	18	t	f	2017-05-19 19:29:59.543	18
177	45	110	2016-08-10	18	1	76.8300018	<p><iframe src="https://www.youtube.com/embed/ejGqqPUoeQA" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-08 14:30:25.479	18	t	f	2017-05-19 20:51:16.029	18
263.5	66	152	2004-08-25	44	2	162.949997	<p><iframe src="//www.youtube.com/embed/g1LG2yoUTwA?start=1736&amp;end=1766" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	75	f	2017-05-08 14:30:25.625	18	t	f	2017-05-18 09:40:49.651	18
200	56	135	2008-08-18	37	1	104.760002	<p><iframe src="https://www.youtube.com/embed/MGN8y-NoRok?start=81&amp;end=92" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	21	f	2017-05-08 14:30:25.562	18	t	f	2017-05-18 09:50:16.178	18
232.5	55	133	2000-04-29	38	2	93.8600006	<p><iframe src="https://www.youtube.com/embed/_PUH7sltW6I?start=30&amp;end=50" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	166	f	2017-05-08 14:30:25.556	18	t	f	2017-05-19 19:55:44.492	18
246	58	138	2015-12-12	39	2	104.440002	<p><iframe src="https://www.youtube.com/embed/VGniqOhUbbU" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	82	f	2017-05-08 14:30:25.572	18	t	f	2017-05-18 09:54:21.815	18
239	60	141	2014-11-15	24	2	104.779999	<p><iframe src="https://www.youtube.com/embed/-6Jkf2dhU4M" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	f	214	f	2017-05-08 14:30:25.582	18	t	f	2017-05-18 10:03:13.852	18
187	50	121	2007-09-22	31	1	84.6999969	<p><iframe src="https://www.youtube.com/embed/MpbZzPwdDfU?start=18&amp;end=30" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	21	f	2017-05-08 14:30:25.519	18	t	f	2017-05-19 19:59:40.114	18
214	47	115	2016-08-10	18	2	76.1900024	<p><a title="youtube" href="https://youtu.be/mP7BsYW5JU0?t=1m5s" target="_blank" rel="noopener noreferrer">youtube</a></p>	t	82	f	2017-05-08 14:30:25.5	18	t	f	2017-05-19 21:00:51.314	18
233	58	378	2012-08-04	22	2	93.5199966	<p><iframe src="https://www.youtube.com/embed/Ovgai9YjkBA?start=216&amp;end=228" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	82	t	2017-05-22 10:20:25.256	18	t	f	2017-05-22 10:21:54.046	18
395	51	129	2016-05-31	35	3	84.4700012	\N	t	75	f	2017-05-08 14:30:25.542	18	f	f	\N	\N
357.5	44	109	1999-11-24	27	3	68.6500015	\N	t	26	f	2017-05-08 14:30:25.476	18	f	f	\N	\N
182.5	39	97	2002-10-02	21	2	61.4500008	\N	t	91	f	2017-05-08 14:30:25.415	18	f	f	\N	\N
174	45	113	2009-11-25	28	1	76.3499985	\N	t	91	f	2017-05-08 14:30:25.491	18	f	f	\N	\N
378	45	119	2009-11-25	28	3	76.3499985	\N	t	91	f	2017-05-08 14:30:25.51	18	f	f	\N	\N
380	45	117	2013-10-24	25	3	76.4000015	\N	t	91	f	2017-05-08 14:30:25.506	18	f	f	\N	\N
176	45	111	2013-10-24	25	1	76.4000015	\N	t	91	f	2017-05-08 14:30:25.483	18	f	f	\N	\N
377.5	49	120	2002-03-27	30	3	76.6999969	\N	t	26	f	2017-05-08 14:30:25.514	18	f	f	\N	\N
173.5	46	114	2004-04-09	29	1	76.8000031	\N	t	82	f	2017-05-08 14:30:25.496	18	f	f	\N	\N
210	48	116	2001-04-27	16	2	76.6500015	\N	t	170	f	2017-05-08 14:30:25.503	18	f	f	\N	\N
183	50	124	2005-11-14	33	1	84.6999969	\N	f	21	f	2017-05-08 14:30:25.529	18	f	f	\N	\N
186	50	122	2006-05-06	32	1	84.6999969	\N	t	21	f	2017-05-08 14:30:25.522	18	f	f	\N	\N
218	52	127	1998-04-25	36	2	82.9000015	\N	t	91	f	2017-05-08 14:30:25.538	18	f	f	\N	\N
182.5	50	125	2002-06-02	34	1	83.9899979	\N	t	21	f	2017-05-08 14:30:25.532	18	f	f	\N	\N
199	57	136	2006-05-07	32	1	104.400002	\N	t	166	f	2017-05-08 14:30:25.564	18	f	f	\N	\N
198	57	137	2002-06-04	34	1	103.959999	\N	t	166	f	2017-05-08 14:30:25.567	18	f	f	\N	\N
412	54	134	1999-11-27	27	3	92.9599991	\N	t	58	f	2017-05-08 14:30:25.559	18	f	f	\N	\N
238	61	142	2011-12-17	40	2	104.699997	\N	t	170	f	2017-05-08 14:30:25.589	18	f	f	\N	\N
237.5	62	143	2004-04-25	41	2	104.900002	\N	t	26	f	2017-05-08 14:30:25.592	18	f	f	\N	\N
430	63	146	1999-11-28	27	3	104.940002	\N	t	215	f	2017-05-08 14:30:25.599	18	f	f	\N	\N
214	65	150	2011-11-13	43	1	168.220001	\N	t	75	f	2017-05-08 14:30:25.62	18	f	f	\N	\N
212.5	66	325	2000-09-26	19	1	147.479996	<p><iframe src="https://www.youtube.com/embed/8y3i_lFlgFI?start=98&amp;end=116" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	75	f	2017-05-14 00:53:46.007	18	t	f	2017-05-22 10:30:21.579	18
97.5	68	156	2004-08-14	44	1	47.2099991	\N	t	212	f	2017-05-08 14:30:25.64	18	f	f	2017-05-17 23:55:14.727	18
121	68	157	2010-09-17	46	2	47.8800011	\N	t	212	f	2017-05-08 14:30:25.643	18	f	f	2017-05-17 23:55:42.41	18
210	68	166	2004-08-14	44	3	47.2099991	\N	t	212	f	2017-05-08 14:30:25.667	18	f	f	2017-05-17 23:56:36.455	18
225	78	179	2000-09-18	19	3	52.4599991	\N	t	91	f	2017-05-08 14:30:25.7	18	f	f	2017-05-17 23:58:10.277	18
115	88	197	2004-08-16	44	1	62.8699989	\N	t	21	f	2017-05-08 14:30:25.752	18	f	f	2017-05-17 23:59:46.828	18
147	89	198	2016-08-09	18	2	62.3400002	\N	t	91	f	2017-05-08 14:30:25.756	18	f	f	2017-05-18 00:00:10.25	18
262	89	208	2016-08-09	18	3	62.3400002	\N	t	91	f	2017-05-08 14:30:25.78	18	f	f	2017-05-18 00:00:44.076	18
125	96	216	2008-08-13	37	1	68.8700027	\N	f	91	f	2017-05-08 14:30:25.801	18	f	f	2017-05-18 00:02:06.145	18
122.5	96	218	2004-08-19	44	1	68.1399994	\N	t	91	f	2017-05-08 14:30:25.809	18	f	f	2017-05-18 00:02:10.259	18
158	96	219	2008-08-13	37	2	68.8700027	\N	t	91	f	2017-05-08 14:30:25.812	18	f	f	2017-05-18 00:02:51.234	18
153	96	222	2004-08-19	44	2	68.1399994	\N	t	91	f	2017-05-08 14:30:25.819	18	f	f	2017-05-18 00:02:55.311	18
275	96	226	2004-08-20	44	3	68.1399994	\N	t	91	f	2017-05-08 14:30:25.828	18	f	f	2017-05-18 00:04:10.073	18
125	99	235	2004-08-20	44	1	74.0899963	\N	t	170	f	2017-05-08 14:30:25.849	18	f	f	2017-05-18 00:06:18.228	18
212.5	66	151	2003-09-14	26	1	161.600006	\N	t	75	f	2017-05-08 14:30:25.622	18	f	f	\N	\N
110	81	182	2003-08-10	51	1	\N	\N	f	91	f	2017-05-08 14:30:25.709	18	f	f	\N	\N
120	69	158	2007-04-21	47	2	47.7000008	\N	t	91	f	2017-05-08 14:30:25.646	18	f	f	\N	\N
116.5	71	161	2003-09-10	26	2	47.9199982	\N	t	91	f	2017-05-08 14:30:25.653	18	f	f	\N	\N
102.5	73	168	2002-10-01	21	1	52.8499985	\N	t	97	f	2017-05-08 14:30:25.673	18	f	f	\N	\N
133	74	170	2014-11-10	24	2	52.9500008	\N	f	82	f	2017-05-08 14:30:25.677	18	f	f	\N	\N
211	70	165	2005-11-09	33	3	47.8199997	\N	f	91	f	2017-05-08 14:30:25.663	18	f	f	\N	\N
118	70	160	2005-11-09	33	2	47.8199997	\N	t	91	f	2017-05-08 14:30:25.651	18	f	f	\N	\N
103	72	167	2010-11-14	48	1	52.6399994	\N	t	91	f	2017-05-08 14:30:25.67	18	f	f	\N	\N
230	72	177	2010-11-14	48	3	52.6399994	\N	t	91	f	2017-05-08 14:30:25.695	18	f	f	\N	\N
134	74	169	2014-11-10	24	2	52.9500008	\N	t	82	f	2017-05-08 14:30:25.675	18	f	f	\N	\N
132	74	171	2014-09-21	13	2	52.4900017	\N	t	82	f	2017-05-08 14:30:25.679	18	f	f	\N	\N
233	77	176	2014-09-21	13	3	52.6399994	\N	t	202	f	2017-05-08 14:30:25.693	18	f	f	\N	\N
130	74	172	2011-11-06	43	2	52.6699982	\N	t	82	f	2017-05-08 14:30:25.681	18	f	f	\N	\N
129	72	173	2007-04-22	47	2	52.8499985	\N	t	91	f	2017-05-08 14:30:25.684	18	f	f	\N	\N
127	76	175	2002-11-20	49	2	52.8499985	\N	t	91	f	2017-05-08 14:30:25.69	18	f	f	\N	\N
128	75	174	2006-10-02	45	2	52.5200005	\N	t	91	f	2017-05-08 14:30:25.687	18	f	f	\N	\N
226	75	178	2006-10-02	45	3	52.5200005	\N	t	91	f	2017-05-08 14:30:25.697	18	f	f	\N	\N
240	81	194	2003-08-10	51	3	\N	\N	t	91	f	2017-05-08 14:30:25.744	18	f	f	\N	\N
251	80	190	2006-12-03	50	3	57.7599983	\N	t	91	f	2017-05-08 14:30:25.734	18	f	f	\N	\N
140	80	184	2006-12-03	50	2	57.7599983	\N	t	91	f	2017-05-08 14:30:25.714	18	f	f	\N	\N
112	79	180	2015-11-23	11	1	57.9000015	\N	t	4	f	2017-05-08 14:30:25.702	18	f	f	\N	\N
252	79	189	2015-11-23	11	3	57.9000015	\N	t	4	f	2017-05-08 14:30:25.73	18	f	f	\N	\N
141	82	183	2007-04-23	47	2	57.5999985	\N	t	91	f	2017-05-08 14:30:25.712	18	f	f	\N	\N
136	83	186	2005-11-10	33	2	57.4000015	\N	f	91	f	2017-05-08 14:30:25.72	18	f	f	\N	\N
241	83	193	2005-11-11	33	3	57.4000015	\N	f	91	f	2017-05-08 14:30:25.742	18	f	f	\N	\N
139	83	185	2005-11-10	33	2	57.4000015	\N	t	91	f	2017-05-08 14:30:25.717	18	f	f	\N	\N
135	84	187	2005-11-11	33	2	57.3800011	\N	f	201	f	2017-05-08 14:30:25.724	18	f	f	\N	\N
133	85	188	2002-06-28	20	2	57.6599998	\N	t	91	f	2017-05-08 14:30:25.727	18	f	f	\N	\N
117	86	195	2011-11-08	43	1	62.1699982	\N	t	170	f	2017-05-08 14:30:25.747	18	f	f	\N	\N
251	87	213	2005-11-12	33	3	62.5400009	\N	f	201	f	2017-05-08 14:30:25.792	18	f	f	\N	\N
140	87	205	2005-11-12	33	2	62.5400009	\N	t	201	f	2017-05-08 14:30:25.772	18	f	f	\N	\N
256	87	212	2005-11-12	33	3	62.5400009	\N	t	201	f	2017-05-08 14:30:25.79	18	f	f	\N	\N
247	95	214	2003-09-12	26	3	62.9000015	\N	t	91	f	2017-05-08 14:30:25.795	18	f	f	\N	\N
146	89	199	2015-11-25	11	2	62.8699989	\N	t	91	f	2017-05-08 14:30:25.758	18	f	f	\N	\N
257	94	211	2007-09-23	31	3	62.5999985	\N	t	91	f	2017-05-08 14:30:25.788	18	f	f	\N	\N
144	89	201	2014-09-23	13	2	62.2299995	\N	f	91	f	2017-05-08 14:30:25.762	18	f	f	\N	\N
143	91	202	2010-09-20	46	2	62.3499985	\N	t	82	f	2017-05-08 14:30:25.765	18	f	f	\N	\N
259	90	210	2014-09-23	13	3	62.3100014	\N	f	202	f	2017-05-08 14:30:25.785	18	f	f	\N	\N
145	90	200	2014-09-23	13	2	62.3100014	\N	t	202	f	2017-05-08 14:30:25.76	18	f	f	\N	\N
261	90	209	2014-09-23	13	3	62.3100014	\N	t	202	f	2017-05-08 14:30:25.783	18	f	f	\N	\N
141	92	204	2006-05-03	32	2	62.7000008	\N	t	170	f	2017-05-08 14:30:25.77	18	f	f	\N	\N
139	92	206	2005-11-12	33	2	62.75	\N	f	170	f	2017-05-08 14:30:25.775	18	f	f	\N	\N
138	93	207	2003-11-18	52	2	62.1599998	\N	t	215	f	2017-05-08 14:30:25.778	18	f	f	\N	\N
142	87	203	2006-12-04	50	2	61.9599991	\N	t	201	f	2017-05-08 14:30:25.768	18	f	f	\N	\N
135	99	227	2011-12-17	40	1	75	\N	t	170	f	2017-05-08 14:30:25.831	18	f	f	\N	\N
123	97	217	2006-10-04	45	1	68.5299988	\N	t	170	f	2017-05-08 14:30:25.803	18	f	f	\N	\N
157	98	220	2005-11-13	33	2	68.9400024	\N	t	170	f	2017-05-08 14:30:25.815	18	f	f	\N	\N
154	94	221	2005-11-13	33	2	68.5500031	\N	f	91	f	2017-05-08 14:30:25.816	18	f	f	\N	\N
133	99	229	2010-09-23	46	1	74.9700012	\N	f	170	f	2017-05-08 14:30:25.836	18	f	f	\N	\N
134	100	228	2010-09-23	46	1	74.6699982	\N	t	82	f	2017-05-08 14:30:25.834	18	f	f	\N	\N
132	100	230	2009-11-28	28	1	74.9100037	\N	t	82	f	2017-05-08 14:30:25.838	18	f	f	\N	\N
131	99	231	2007-09-25	31	1	74.4499969	\N	t	170	f	2017-05-08 14:30:25.84	18	f	f	\N	\N
127	99	233	2005-11-13	33	1	74.8300018	\N	f	170	f	2017-05-08 14:30:25.845	18	f	f	\N	\N
130	99	232	2005-11-13	33	1	74.8300018	\N	t	170	f	2017-05-08 14:30:25.843	18	f	f	\N	\N
126	96	234	2005-11-13	33	1	71.8499985	\N	f	91	f	2017-05-08 14:30:25.847	18	f	f	\N	\N
119	67	159	2006-10-01	45	2	47.7999992	\N	t	91	f	2017-05-08 14:30:25.649	18	f	f	\N	\N
163	102	237	2011-11-10	43	2	74.1800003	\N	t	170	f	2017-05-08 14:30:25.854	18	f	f	\N	\N
162	102	238	2011-04-16	53	2	74.5400009	\N	t	170	f	2017-05-08 14:30:25.856	18	f	f	\N	\N
164	101	236	2014-09-25	13	2	74.4700012	\N	t	97	f	2017-05-08 14:30:25.852	18	f	f	\N	\N
272	99	255	2004-08-20	44	3	74.0899963	\N	f	170	f	2017-05-08 14:30:25.898	18	f	f	2017-05-18 00:07:09.035	18
307	35	271	2016-08-07	18	3	55.6800003	<p><a title="youtube" href="https://youtu.be/Smk7QF5K2l8" target="_blank" rel="noopener noreferrer">youtube</a></p>	t	91	f	2017-05-13 11:08:44.923	18	t	f	2017-05-19 23:21:53.795	18
240	61	140	2014-11-15	24	2	104.25	<p><iframe src="https://www.youtube.com/embed/z5FwxEksoMo" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	f	170	f	2017-05-08 14:30:25.577	18	t	f	2017-05-20 00:15:23.165	18
296	99	244	2011-12-17	40	3	75	\N	t	170	f	2017-05-08 14:30:25.87	18	f	f	\N	\N
295	100	245	2010-09-23	46	3	74.6699982	\N	t	82	f	2017-05-08 14:30:25.872	18	f	f	\N	\N
285	99	250	2005-11-13	33	3	74.8300018	\N	f	170	f	2017-05-08 14:30:25.884	18	f	f	\N	\N
155	100	242	2005-11-13	33	2	74.5599976	\N	f	170	f	2017-05-08 14:30:25.866	18	f	f	\N	\N
153	37	278	2002-06-28	20	1	62	\N	f	91	f	2017-05-13 11:30:56.522	18	f	f	\N	\N
293	99	246	2010-09-23	46	3	74.9700012	\N	f	170	f	2017-05-08 14:30:25.875	18	f	f	\N	\N
287	100	248	2009-11-28	28	3	74.9100037	\N	f	82	f	2017-05-08 14:30:25.879	18	f	f	\N	\N
292	100	247	2009-11-28	28	3	74.9100037	\N	t	82	f	2017-05-08 14:30:25.877	18	f	f	\N	\N
161	100	239	2010-09-23	46	2	74.6699982	\N	t	82	f	2017-05-08 14:30:25.859	18	f	f	\N	\N
160	100	240	2009-11-28	28	2	74.9100037	\N	t	82	f	2017-05-08 14:30:25.861	18	f	f	\N	\N
279	100	252	2005-11-13	33	3	74.5599976	\N	f	170	f	2017-05-08 14:30:25.891	18	f	f	\N	\N
273	96	254	2005-05-23	55	3	71.1500015	\N	t	91	f	2017-05-08 14:30:25.896	18	f	f	\N	\N
278	99	253	2005-11-13	33	3	74.8300018	\N	f	170	f	2017-05-08 14:30:25.893	18	f	f	\N	\N
152.5	104	243	2002-10-07	21	2	74.4000015	\N	t	91	f	2017-05-08 14:30:25.868	18	f	f	\N	\N
281	96	251	2005-11-13	33	3	71.8499985	\N	f	91	f	2017-05-08 14:30:25.887	18	f	f	\N	\N
159	96	241	2005-11-13	33	2	71.8499985	\N	t	91	f	2017-05-08 14:30:25.863	18	f	f	\N	\N
286	100	249	2006-06-02	54	3	74.9700012	\N	t	170	f	2017-05-08 14:30:25.882	18	f	f	\N	\N
242.5	124	342	2000-09-19	19	3	62.8199997	\N	t	91	f	2017-05-14 16:57:38.219	18	f	f	\N	\N
170	33	269	2014-09-20	13	2	55.6899986	\N	t	97	f	2017-05-13 11:00:16.308	18	f	f	\N	\N
154	125	344	2008-08-15	37	2	73.1600037	\N	t	91	f	2017-05-14 17:03:46.105	18	f	f	\N	\N
326	40	284	2008-04-28	23	3	61.6800003	\N	t	91	f	2017-05-13 12:17:06.635	18	f	f	\N	\N
185	50	123	2005-11-14	33	1	84.6999969	\N	t	21	f	2017-05-08 14:30:25.526	18	f	f	\N	\N
393	50	131	2007-09-22	31	3	84.6999969	\N	t	21	f	2017-05-08 14:30:25.549	18	f	f	\N	\N
437	58	144	2015-12-12	39	3	104.440002	\N	t	82	f	2017-05-08 14:30:25.595	18	f	f	\N	\N
224	55	321	2008-08-17	37	2	93.7300034	<p><iframe src="https://www.youtube.com/embed/citVxHm53Vo?start=90&amp;end=107" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	166	f	2017-05-14 00:43:27.761	18	t	f	2017-05-19 19:55:22.374	18
473	64	153	2016-08-16	18	3	157.339996	<p><a title="youtube" href="https://youtu.be/DNy1kS2qvFM" target="_blank" rel="noopener noreferrer">youtube | clean &amp; jerk</a>&nbsp;<br /><a title="youtube | snatch" href="https://youtu.be/AD1QbiRovfk" target="_blank" rel="noopener noreferrer">youtube | snatch</a></p>	t	59	f	2017-05-08 14:30:25.627	18	t	f	2017-05-19 20:31:06.616	18
472	66	154	2000-09-26	19	3	147.479996	\N	t	75	f	2017-05-08 14:30:25.63	18	f	f	2017-05-17 23:51:54.89	18
286	96	223	2008-08-13	37	3	68.8700027	\N	t	91	f	2017-05-08 14:30:25.821	18	f	f	2017-05-18 00:04:02.443	18
277	96	224	2008-08-13	37	3	68.8700027	\N	f	91	f	2017-05-08 14:30:25.824	18	f	f	2017-05-18 00:04:06.114	18
213	70	164	2005-11-09	33	3	47.8199997	\N	t	91	f	2017-05-08 14:30:25.661	18	f	f	\N	\N
180	116	319	2000-09-23	19	1	84.6999969	<p><iframe src="https://www.youtube.com/embed/c3bj7WKBgFw?start=202&amp;end=215" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	59	f	2017-05-14 00:39:34.024	18	t	f	2017-05-19 20:05:22.492	18
214	67	163	2006-10-01	45	3	47.7999992	\N	f	91	f	2017-05-08 14:30:25.658	18	f	f	\N	\N
98	67	155	2006-10-01	45	1	47.7999992	\N	t	91	f	2017-05-08 14:30:25.637	18	f	f	\N	\N
248	80	191	2006-12-03	50	3	57.7599983	\N	f	91	f	2017-05-08 14:30:25.737	18	f	f	\N	\N
242	80	192	2006-12-03	50	3	57.7599983	\N	f	91	f	2017-05-08 14:30:25.74	18	f	f	\N	\N
111	80	181	2006-12-03	50	1	57.7599983	\N	t	91	f	2017-05-08 14:30:25.705	18	f	f	\N	\N
217	67	162	2006-10-01	45	3	47.7999992	\N	t	91	f	2017-05-08 14:30:25.656	18	f	f	\N	\N
116	87	196	2005-11-12	33	1	62.5400009	\N	t	201	f	2017-05-08 14:30:25.75	18	f	f	\N	\N
237	60	323	2016-08-15	18	2	104.959999	<p><iframe src="https://www.youtube.com/embed/-IjhgUH0Alc?start=0&amp;end=18" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	214	f	2017-05-14 00:45:50.348	18	t	f	2017-05-18 10:07:53.382	18
167.5	28	262	2001-04-24	16	2	56	<p><a title="Вики" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D1%8B_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2001" target="_blank" rel="noopener noreferrer">Вики</a></p>	t	212	f	2017-05-08 15:29:20.116	18	f	f	\N	\N
187.5	117	320	2000-09-24	19	1	93.4199982	<p><iframe src="https://www.youtube.com/embed/NUZRnQKAbqk?start=1064&amp;end=1094" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	75	f	2017-05-14 00:42:37.218	18	t	f	2017-05-19 19:39:35.123	18
196.5	44	311	2000-09-20	19	2	68.7799988	<p><iframe src="https://www.youtube.com/embed/XeydAehDZD8?start=554&amp;end=600" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	26	f	2017-05-14 00:11:29.158	18	t	f	2017-05-19 22:39:09.71	18
357.5	44	312	2000-09-20	19	3	68.7799988	<p><iframe src="https://www.youtube.com/embed/XeydAehDZD8" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	26	f	2017-05-14 00:20:12.295	18	t	f	2017-05-19 22:43:09.951	18
217	114	317	2016-08-12	18	2	84.8499985	<p><a title="youtube" href="https://youtu.be/Ap1Fpb0VDk8?t=30s" target="_blank" rel="noopener noreferrer">youtube</a></p>	f	91	f	2017-05-14 00:35:35.751	18	t	f	2017-05-19 20:23:16.159	18
153	36	306	2012-07-30	22	1	61.7700005	<p><iframe src="https://www.youtube.com/embed/R_NW_bFTOZw?start=23&amp;end=49" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	97	f	2017-05-13 23:57:55.198	18	t	f	2017-05-19 22:59:10.603	18
177	109	308	2012-07-30	22	2	61.7599983	<p><a title="youtube" href="https://youtu.be/361zo0DS8ek?t=51s" target="_blank" rel="noopener noreferrer">youtube</a></p>	t	93	f	2017-05-14 00:03:39.85	18	t	f	2017-05-19 23:14:05.377	18
137.5	28	301	2000-09-16	19	1	55.6199989	<p><iframe src="https://www.youtube.com/embed/5M44nFRCL7s?start=93&amp;end=110" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	212	f	2017-05-13 23:50:04.115	18	t	f	2017-05-19 23:18:42.636	18
170	35	302	2016-08-07	18	2	55.6800003	<p><a title="youtube" href="https://youtu.be/Smk7QF5K2l8?t=1m4s" target="_blank" rel="noopener noreferrer">youtube</a></p>	t	91	f	2017-05-13 23:50:59.173	18	t	f	2017-05-19 23:21:20.706	18
101	119	327	2016-08-07	18	1	52.5	\N	t	91	f	2017-05-14 16:31:17.048	18	f	f	\N	\N
168	33	305	2012-07-29	22	2	55.7599983	\N	t	97	f	2017-05-13 23:56:17.474	18	f	f	\N	\N
176	110	309	2008-08-10	37	2	61.9099998	\N	t	91	f	2017-05-14 00:06:33.568	18	f	f	\N	\N
167.5	28	304	2000-09-16	19	2	55.6199989	\N	t	212	f	2017-05-13 23:54:21.418	18	f	f	\N	\N
325	111	310	2000-09-17	19	3	61.5600014	\N	t	227	f	2017-05-14 00:09:34.768	18	f	f	\N	\N
152	37	307	2004-08-16	44	1	61.9599991	\N	t	91	f	2017-05-14 00:00:03.107	18	f	f	\N	\N
169	33	303	2016-08-07	18	2	55.5699997	\N	f	97	f	2017-05-13 23:53:34.804	18	f	f	\N	\N
215	115	318	2000-09-22	19	2	84.0599976	\N	t	58	f	2017-05-14 00:37:48.503	18	f	f	\N	\N
395	114	316	2016-08-12	18	3	84.8499985	\N	f	91	f	2017-05-14 00:34:42.031	18	f	f	\N	\N
172.5	112	313	2004-08-19	44	1	76.0999985	\N	t	212	f	2017-05-14 00:23:48.946	18	f	f	\N	\N
375	112	314	2004-08-19	44	3	76.0999985	\N	t	212	f	2017-05-14 00:24:53.397	18	f	f	\N	\N
207.5	113	315	2000-09-22	19	2	76.1999969	\N	t	91	f	2017-05-14 00:29:09.87	18	f	f	\N	\N
407.5	118	322	2004-08-23	44	3	92.5800018	\N	t	26	f	2017-05-14 00:44:45.706	18	f	f	\N	\N
236	56	324	2008-08-18	37	2	104.760002	\N	t	21	f	2017-05-14 00:46:21.862	18	f	f	\N	\N
117	69	326	2008-08-09	37	2	47.4599991	\N	t	91	t	2017-05-14 16:28:42.127	18	f	f	\N	\N
100	78	329	2000-09-18	19	1	52.4599991	\N	t	91	f	2017-05-14 16:33:37.968	18	f	f	\N	\N
126	120	328	2008-09-10	37	2	52.4700012	\N	t	201	f	2017-05-14 16:32:25.052	18	f	f	\N	\N
110	121	330	2016-08-08	18	1	56.8899994	\N	t	201	f	2017-05-14 16:37:30.861	18	f	f	\N	\N
246	76	335	2012-07-30	22	3	57.9799995	\N	t	91	f	2017-05-14 16:43:55.554	18	f	f	\N	\N
143	122	337	2016-08-09	18	2	62.1699982	\N	f	97	f	2017-05-14 16:50:08.69	18	f	f	\N	\N
244	80	336	2008-08-11	37	3	57.6599998	\N	t	91	f	2017-05-14 16:44:55.013	18	f	f	\N	\N
138	80	334	2008-08-11	37	2	57.6599998	\N	t	91	f	2017-05-14 16:42:07.118	18	f	f	\N	\N
253	89	340	2016-08-09	18	3	62.3400002	\N	f	91	f	2017-05-14 16:53:13.879	18	f	f	\N	\N
243	123	341	2016-08-09	18	3	62.6599998	\N	f	82	f	2017-05-14 16:55:21.947	18	f	f	\N	\N
135	93	339	2004-08-18	44	2	61.5900002	\N	t	215	f	2017-05-14 16:51:53.917	18	f	f	\N	\N
193	108	350	2014-11-16	24	2	106.209999	<p><span style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Проходил в категории +75kg</span></p>	f	170	f	2017-05-14 17:09:46.156	18	f	f	2017-05-18 00:09:20.501	18
160	107	347	2010-09-25	46	2	86.0500031	<p>Проходил в категории +75kg</p>	f	14	f	2017-05-14 17:08:40.597	18	f	f	2017-05-18 00:09:41.671	18
128	96	215	2008-08-13	37	1	68.8700027	\N	t	91	f	2017-05-08 14:30:25.798	18	f	f	2017-05-18 00:02:02.125	18
155	108	349	2014-11-16	24	1	106.209999	<p><span style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Проходил в категории +75kg</span></p>	t	170	f	2017-05-14 17:09:33.661	18	f	f	2017-05-18 00:08:58.143	18
348	108	351	2014-11-16	24	3	106.209999	<p><span style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Проходил в категории +75kg</span></p>	f	170	f	2017-05-14 17:09:57.799	18	f	f	2017-05-18 00:09:45.248	18
283	107	348	2010-09-25	46	3	86.0500031	<p><span style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Проходил в категории +75kg</span></p>	f	14	f	2017-05-14 17:08:52.481	18	f	f	2017-05-18 00:09:50.185	18
108	76	331	2012-07-30	22	1	57.9799995	\N	t	91	f	2017-05-14 16:38:57.121	18	f	f	\N	\N
138	89	338	2016-08-09	18	2	62.3400002	\N	f	91	f	2017-05-14 16:51:01.912	18	f	f	\N	\N
282	125	345	2008-08-15	37	3	73.1600037	\N	f	91	f	2017-05-14 17:04:42.067	18	f	f	\N	\N
128	125	343	2008-08-15	37	1	73.1600037	\N	t	91	f	2017-05-14 17:02:29.25	18	f	f	\N	\N
146	126	368	2012-08-05	22	1	130.830002	\N	f	91	f	2017-05-14 18:00:29.059	18	f	f	\N	\N
144	108	369	2012-08-05	22	1	102.309998	\N	f	170	f	2017-05-14 18:00:34.132	18	f	f	\N	\N
142	126	370	2012-08-05	22	1	130.830002	\N	f	91	f	2017-05-14 18:00:38.868	18	f	f	\N	\N
140	127	371	2008-08-16	37	1	116.75	\N	t	98	f	2017-05-14 18:00:44.392	18	f	f	\N	\N
187	126	372	2012-08-05	22	2	130.830002	\N	t	91	f	2017-05-14 18:00:49.706	18	f	f	\N	\N
186	127	373	2008-08-16	37	2	116.75	\N	t	98	f	2017-05-14 18:00:54.5	18	f	f	\N	\N
333	126	374	2012-08-05	22	3	130.830002	\N	t	91	f	2017-05-14 18:00:59.585	18	f	f	\N	\N
332	108	375	2012-08-05	22	3	102.309998	\N	f	170	f	2017-05-14 18:01:19.558	18	f	f	\N	\N
327	126	376	2012-08-05	22	3	130.830002	\N	f	91	f	2017-05-14 18:01:23.86	18	f	f	\N	\N
326	127	377	2008-08-16	37	3	116.75	\N	t	98	f	2017-05-14 18:01:28.449	18	f	f	\N	\N
151	108	366	2012-08-05	22	1	102.309998	\N	t	170	f	2017-05-14 17:59:39.818	18	f	f	\N	\N
149	108	367	2012-08-05	22	1	102.309998	\N	f	170	f	2017-05-14 18:00:23.741	18	f	f	\N	\N
305	28	273	2000-09-16	19	3	55.6199989	\N	t	212	f	2017-05-13 11:16:27.986	18	f	f	2017-05-17 23:29:53.343	18
327	36	285	2012-07-30	22	3	61.7700005	\N	t	97	f	2017-05-13 12:17:16.11	18	f	f	2017-05-17 23:31:40.595	18
358	41	291	2013-10-23	25	3	68.5199966	\N	t	91	f	2017-05-13 12:30:01.116	18	f	f	\N	\N
197.5	43	292	2003-09-11	26	2	68.9000015	\N	t	91	f	2017-05-13 12:32:05.797	18	f	f	\N	\N
328	36	276	2014-09-21	13	3	61.8100014	\N	f	97	f	2017-05-13 11:19:51.49	18	f	f	\N	\N
276	97	293	2007-09-24	31	3	68.3799973	\N	t	170	f	2017-05-13 19:29:22.274	18	f	f	\N	\N
138.5	28	268	2001-11-04	12	1	55.9599991	\N	t	212	f	2017-05-13 10:54:40.196	18	f	f	\N	\N
169	33	270	2013-09-13	15	2	55.7299995	\N	t	97	f	2017-05-13 11:04:29.822	18	f	f	\N	\N
332	36	283	2014-09-21	13	3	61.8100014	\N	t	97	f	2017-05-13 12:07:51.293	18	f	f	\N	\N
107.5	80	333	2004-08-16	44	1	57.1699982	\N	t	91	f	2017-05-14 16:40:45	18	f	f	\N	\N
130	106	346	2004-08-21	44	1	88.1399994	<p><span style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Проходил в категории +75kg</span></p>	t	215	f	2017-05-14 17:08:24.516	18	f	f	2017-05-18 00:08:07.195	18
166	41	286	2014-11-10	24	1	68.6800003	<p><iframe src="https://www.youtube.com/embed/IXffCCC2rDo?start=39&amp;end=60" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-13 12:22:01.982	18	t	f	2017-05-19 22:12:23.165	18
198	41	289	2013-10-23	25	2	68.5199966	<p><iframe src="https://www.youtube.com/embed/jmTRWHFjfec?start=16" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-13 12:29:11.091	18	t	f	2017-05-19 22:30:02.098	18
165	42	287	2000-09-20	19	1	68.9199982	<p><iframe src="https://www.youtube.com/embed/XeydAehDZD8?start=246&amp;end=263" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	26	f	2017-05-13 12:26:38.396	18	t	f	2017-05-19 22:35:10.33	18
183	38	280	2015-11-22	11	2	61.8899994	<p><iframe src="https://www.youtube.com/embed/Yw-i_4UrV0s" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-13 11:32:56.575	18	t	f	2017-05-19 22:49:21.547	18
333	38	282	2015-11-22	11	3	61.8899994	<p><iframe src="https://www.youtube.com/embed/zz12Vv_OTn0" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>\n<p><iframe src="https://www.youtube.com/embed/Yw-i_4UrV0s" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-13 11:33:45.499	18	t	f	2017-05-19 22:51:31.676	18
154	36	277	2014-09-21	13	1	61.8100014	<p><iframe src="https://www.youtube.com/embed/acDOgAEORJs?start=23&amp;end=30" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	97	f	2017-05-13 11:24:29.739	18	t	f	2017-05-19 23:10:54.091	18
171	33	80	2015-11-19	11	2	55.7799988	<p><iframe src="https://www.youtube.com/embed/Ovgai9YjkBA?start=21&amp;end=35" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	97	f	2017-05-05 00:04:35.272	18	t	f	2017-05-22 10:06:30.856	18
139	27	70	2015-11-16	11	1	55.9300003	<p><iframe src="https://www.youtube.com/embed/6KJ_yZR-Jco?start=14&amp;end=32" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	91	f	2017-05-02 23:51:13.855	18	t	f	2017-06-03 22:01:18.696	18
215	64	149	2016-08-16	18	1	157.339996	<p><iframe src="https://www.youtube.com/embed/EBG3dczl-18?start=509&amp;end=519" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	f	59	f	2017-05-08 14:30:25.617	18	t	f	2017-06-09 17:07:16.071	18
216	65	148	2016-08-16	18	1	169.789993	<p><iframe src="https://www.youtube.com/embed/EBG3dczl-18?start=545&amp;end=556" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen"></iframe></p>	t	75	f	2017-05-08 14:30:25.606	18	t	f	2017-06-09 17:09:22.363	18
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (url, data, data_type, last_update) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, content, date, userid, attemptid, ban, updated) FROM stdin;
\.


--
-- Data for Name: competition_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competition_types (id, name) FROM stdin;
2	World Championship
3	Other
4	Asian Championship
6	European Championship
9	Junior Asian Championship
8	Junior World Championship
7	World University Championship
1	Olympic Games
\.


--
-- Data for Name: competitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competitions (name, place_id, id, type, date_end, date_start, source_info, is_end) FROM stdin;
2014 Incheon	14	14	4	2014-10-04	2014-09-19	\N	f
2002 Warsaw	46	49	2	2002-11-26	2002-11-18	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=91" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="wikipedia" href="https://en.wikipedia.org/wiki/2002_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a></p>	f
2002 Doha	30	30	3	2002-03-27	2002-03-26	<p><strong>Qatar Grand Prix 2002&nbsp;<br /></strong><a title="iwf results man" href="https://web.archive.org/web/20040217204729/http://www.iwf.net:80/results/2002/qat_men.html" target="_blank" rel="noopener noreferrer">iwf results man</a>&nbsp;<br /><a title="iwf results woman" href="https://web.archive.org/web/20040217204931/http://www.iwf.net:80/results/2002/qat_wom.html" target="_blank" rel="noopener noreferrer">iwf results woman</a></p>	f
2015 Houston	12	11	2	2015-11-27	2015-11-18	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2015_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=341" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2016 Rio de Janeiro	19	18	1	2016-08-16	2016-08-06	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2016_Summer_Olympics" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=362" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2002 Havirov	33	34	8	2002-06-05	2002-05-29	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=150" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2013 Wroclaw	26	25	2	2013-10-27	2013-10-20	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2013_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=253" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2012 London	23	22	1	2012-08-07	2012-07-28	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2012_Summer_Olympics" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=214" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2006 Doha	30	50	4	2006-12-06	2006-12-02	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2006_Asian_Games" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="results" href="https://web.archive.org/web/20061224231235/http://www.doha-2006.com/gis/Sports/WL/IGWLSchedule.aspx" target="_blank" rel="noopener noreferrer">results</a></p>	f
2014 Almaty	25	24	2	2014-11-16	2014-11-08	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2014_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=298" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2002 Izmir	21	20	7	2002-06-30	2002-06-28	<p><a title="iwf results" href="https://web.archive.org/web/20160310000418/http://www.iwf.net/results/results-by-events/?event=318" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
1999 Athens	28	27	2	1999-11-28	1999-11-21	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/1999_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="https://web.archive.org/web/20040625173558/http://www.iwf.net:80/results/1999/athen.html" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2004 Athens	28	44	1	2004-08-29	2004-08-13	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2004_Summer_Olympics" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=4" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2017 Split	41	42	6	2017-04-08	2017-04-02	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2017_European_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a></p>	f
2007 ChiangMai	31	31	2	2007-09-26	2007-09-17	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2007_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=11" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2007 Tai'an	44	47	4	2007-04-28	2007-04-17	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2007_Asian_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="awf results" href="https://web.archive.org/web/20070428032807/http:/www.a-w-f.net/taian.htm" target="_blank" rel="noopener noreferrer">awf results</a></p>	f
2005 Doha	30	33	2	2005-11-17	2005-11-09	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%BC%D0%B8%D1%80%D0%B0_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2005" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=3" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
1998 Ramat Gan	35	36	7	\N	1998-04-24	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=314" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2009 Goyang	29	28	2	2009-11-29	2009-11-20	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2009_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=41" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2016 Tehran	34	35	3	2016-06-02	2016-05-30	<p><span style="color: #000000;"><strong>INTERNATIONAL FAJR CUP</strong></span><a title="iwf event" href="http://www.iwf.net/wp-content/uploads/downloads/2016/01/IWF-Grand-Prix_International-Fajr-Cup-_Regulations-30-May-2-June-2016_Tehran-Iran-finalized-version.pdf" target="_blank" rel="noopener noreferrer"><br />iwf event</a>&nbsp;<br /><a title="results" href="https://web.archive.org/web/20161015195126/http://www.iwf.net/results/results-by-events/?event=359" target="_blank" rel="noopener noreferrer">results</a></p>	f
2003 Bali	47	51	9	\N	2003-08-10	\N	f
2010 Antalya	13	46	2	\N	2010-09-16	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=116" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2006 Santo Domingo	43	45	2	2006-07-07	2006-06-30	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=8" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="wikipedia" href="https://en.wikipedia.org/wiki/2006_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a></p>	f
2010 Guangzhou	45	48	4	2010-11-27	2010-11-12	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=129" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%9B%D0%B5%D1%82%D0%BD%D0%B8%D0%B5_%D0%90%D0%B7%D0%B8%D0%B0%D1%82%D1%81%D0%BA%D0%B8%D0%B5_%D0%B8%D0%B3%D1%80%D1%8B_2010" target="_blank" rel="noopener noreferrer">wikipedia</a></p>	f
2005 Busan	22	55	8	2005-05-24	2005-05-17	<p><a title="iwf result" href="http://www.iwf.net/results/results-by-events/?event=5" target="_blank" rel="noopener noreferrer">iwf result</a>&nbsp;<br /><a title="pdf britishweightlifting" href="http://britishweightlifting.org/wp-content/uploads/2014/11/World-Junior-Championships-2005.pdf" target="_blank" rel="noopener noreferrer">pdf britishweightlifting</a><br /><br /></p>	f
2006 Hangzhou	50	54	8	\N	2006-05-28	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=6" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="iwrp results" href="http://www.iwrp.net/component/cwyniki/?view=contest&amp;id_zawody=187" target="_blank" rel="noopener noreferrer">iwrp results</a></p>	f
2003 Vancouver	48	52	2	2003-11-22	2003-11-14	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=94" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="wikipedia" href="https://en.wikipedia.org/wiki/2003_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a><br /><br /></p>	f
2001 Antalya	13	12	2	2001-11-11	2001-11-04	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%BC%D0%B8%D1%80%D0%B0_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2001" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=89" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2014 Incheon	14	13	4	2014-09-26	2014-09-20	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A2%D1%8F%D0%B6%D1%91%D0%BB%D0%B0%D1%8F_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B0_%D0%BD%D0%B0_%D0%BB%D0%B5%D1%82%D0%BD%D0%B8%D1%85_%D0%90%D0%B7%D0%B8%D0%B0%D1%82%D1%81%D0%BA%D0%B8%D1%85_%D0%B8%D0%B3%D1%80%D0%B0%D1%85_2014" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=297" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2013 Pyongyang	16	15	4	2013-09-17	2013-09-11	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%90%D0%B7%D0%B8%D0%B8_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2013" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=272" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2008 Kanazawa	24	23	4	2008-05-05	2008-04-26	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2008_Asian_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=18" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2000 Sydney	20	19	1	2000-09-26	2000-09-16	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2000_Summer_Olympics" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=71" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2015 Grozny	38	39	3	2015-12-13	2015-12-12	<p><strong>Cup of the President of the Russian Federation<br /><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%9A%D1%83%D0%B1%D0%BE%D0%BA_%D0%9F%D1%80%D0%B5%D0%B7%D0%B8%D0%B4%D0%B5%D0%BD%D1%82%D0%B0_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2015" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=342" target="_blank" rel="noopener noreferrer">iwf results</a><br /></strong></p>	f
2011 Belgorod	39	40	3	2011-12-18	2011-12-16	<p><strong style="color: rgba(0, 0, 0, 0.87); font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 13px;">Cup of the President of the Russian Federation<br /></strong><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=198" target="_blank" rel="noopener noreferrer">iwf results</a></p>	f
2003 Qinhuangdao	27	26	4	2003-09-14	2003-09-10	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2003_Asian_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results men" href="https://web.archive.org/web/20031206201053/http://www.iwf.net/results/2003/qinhuangdao_men.html" target="_blank" rel="noopener noreferrer">iwf results men</a>&nbsp;<br /><a title="iwf results women" href="https://web.archive.org/web/20040204054230/http://www.iwf.net:80/results/2003/qinhuangdao_wom.html" target="_blank" rel="noopener noreferrer">iwf results women</a></p>	f
2002 Busan	22	21	4	2002-10-14	2002-09-29	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%9B%D0%B5%D1%82%D0%BD%D0%B8%D0%B5_%D0%90%D0%B7%D0%B8%D0%B0%D1%82%D1%81%D0%BA%D0%B8%D0%B5_%D0%B8%D0%B3%D1%80%D1%8B_2002" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf resuts women" href="https://web.archive.org/web/20040217204041/http://www.iwf.net:80/results/2002/busan_women.html" target="_blank" rel="noopener noreferrer">iwf resuts women</a>&nbsp;<br /><a title="iwf resuts men" href="https://web.archive.org/web/20040410080556/http://www.iwf.net:80/results/2002/busan_men.html" target="_blank" rel="noopener noreferrer">iwf resuts men</a></p>	f
2004 Almaty	25	29	4	2004-04-12	2004-04-07	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2004_Asian_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results women" href="https://web.archive.org/web/20050209023954/http://www.iwf.net:80/results/2004/asia_wom.html" target="_blank" rel="noopener noreferrer">iwf results women</a>&nbsp;<br /><a title="iwf results man" href="https://web.archive.org/web/20050209023721/http://www.iwf.net:80/results/2004/asia_men.html" target="_blank" rel="noopener noreferrer">iwf results man</a></p>	f
2011 Kazan	49	53	6	2011-04-17	2011-04-11	<p><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=140" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="wikipedia" href="https://en.wikipedia.org/wiki/2011_European_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results old" href="https://web.archive.org/web/20110721220507/http://www.iwf.net/" target="_blank" rel="noopener noreferrer">iwf results old</a></p>	f
2006 Wladyslawowo	32	32	6	2006-05-07	2006-04-27	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D1%8B_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2006" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="britishweightlifting 2006" href="http://britishweightlifting.org/competitions/results-library/results-archive/weightlifting-results-2006/" target="_blank" rel="noopener noreferrer">britishweightlifting 2006</a><br /><a title="britishweightlifting results men" href="http://britishweightlifting.org/wp-content/uploads/2014/11/European-Senior-Championships-Men-2006.pdf" target="_blank" rel="noopener noreferrer">britishweightlifting results men</a>&nbsp;<br /><a title="britishweightlifting results women" href="http://britishweightlifting.org/wp-content/uploads/2014/11/European-Senior-Championships-Women-2006.pdf" target="_blank" rel="noopener noreferrer">britishweightlifting results women</a></p>	f
2004 Kiev	40	41	6	2004-04-26	2004-04-17	<p><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D1%8B_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2004" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results men" href="https://web.archive.org/web/20050209032846/http://www.iwf.net:80/results/2004/kiev_men.html" target="_blank" rel="noopener noreferrer">iwf results men</a>&nbsp;<br /><a title="iwf results women" href="https://web.archive.org/web/20050209032133/http://www.iwf.net:80/results/2004/kiev_wom.html" target="_blank" rel="noopener noreferrer">iwf results women</a></p>	f
2001 Trencin	17	16	6	2001-04-29	2001-04-23	<p>-&nbsp;<a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D1%8B_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2001" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br />-&nbsp;<a title="britishweightlifting results men" href="http://britishweightlifting.org/wp-content/uploads/2014/11/European-Senior-Championships-Men-2001.pdf" target="_blank" rel="noopener noreferrer">britishweightlifting results men</a>&nbsp;<br />-&nbsp;<a title="britishweightlifting results women" href="http://britishweightlifting.org/wp-content/uploads/2014/11/European-Senior-Championships-Women-2001.pdf" target="_blank" rel="noopener noreferrer">britishweightlifting results women<br /></a>-&nbsp;<a title="iwf results woman" href="https://web.archive.org/web/20040217180611/http://www.iwf.net:80/results/2001/tren_wom.html" target="_blank" rel="noopener noreferrer">iwf results woman</a>&nbsp;<br />-&nbsp;<a title="iwf results men" href="https://web.archive.org/web/20040217180447/http://www.iwf.net:80/results/2001/tren_men.html" target="_blank" rel="noopener noreferrer">iwf results men</a></p>	f
2008 Beijing	36	37	1	2008-08-19	2008-08-09	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/Weightlifting_at_the_2008_Summer_Olympics" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=21" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="iwf results old" href="https://web.archive.org/web/20131030085916/http://www.iwf.net/results/results-by-events/?event=21" target="_blank" rel="noopener noreferrer">iwf results old</a></p>	f
2000 Sofia	37	38	6	2000-04-30	2000-04-24	<p><a title="youtube 62kg" href="https://www.youtube.com/watch?v=i3mq-sFip2w" target="_blank" rel="noopener noreferrer">youtube 62kg</a>&nbsp;<br /><a title="wikipedia" href="https://ru.wikipedia.org/wiki/%D0%A7%D0%B5%D0%BC%D0%BF%D0%B8%D0%BE%D0%BD%D0%B0%D1%82_%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D1%8B_%D0%BF%D0%BE_%D1%82%D1%8F%D0%B6%D1%91%D0%BB%D0%BE%D0%B9_%D0%B0%D1%82%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B5_2000" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results men" href="https://web.archive.org/web/20040410051953/http://www.iwf.net:80/results/2000/europeanm.html" target="_blank" rel="noopener noreferrer">iwf results men</a>&nbsp;<br /><a title="iwf results women" href="https://web.archive.org/web/20040217185708/http://www.iwf.net:80/results/2000/europeanw.html" target="_blank" rel="noopener noreferrer">iwf results women</a></p>	f
2011 Paris	42	43	2	2011-11-13	2011-11-05	<p><a title="wikipedia" href="https://en.wikipedia.org/wiki/2011_World_Weightlifting_Championships" target="_blank" rel="noopener noreferrer">wikipedia</a>&nbsp;<br /><a title="iwf results" href="http://www.iwf.net/results/results-by-events/?event=190" target="_blank" rel="noopener noreferrer">iwf results</a>&nbsp;<br /><a title="iwf results before DQ" href="https://web.archive.org/web/20120119202759/http://www.iwf.net/results/results-by-events/?event=190" target="_blank" rel="noopener noreferrer">iwf results before DQ</a></p>	f
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, short_name, short_name_2, "exists", ru_name) FROM stdin;
1	Abkhazia	ABH	AB	t	Абхазия
2	Australia	AUS	AU	t	Австралия
3	Austria	AUT	AT	t	Австрия
4	Azerbaijan	AZE	AZ	t	Азербайджан
5	Albania	ALB	AL	t	Албания
6	Algeria	DZA	DZ	t	Алжир
7	American Samoa	ASM	AS	t	Американское Самоа
8	Anguilla	AIA	AI	t	Ангилья
9	Angola	AGO	AO	t	Ангола
10	Andorra	AND	AD	t	Андорра
11	Antarctica	ATA	AQ	t	Антарктида
12	Antigua and Barbuda	ATG	AG	t	Антигуа и Барбуда
13	Argentina	ARG	AR	t	Аргентина
14	Armenia	ARM	AM	t	Армения
15	Aruba	ABW	AW	t	Аруба
16	Afghanistan	AFG	AF	t	Афганистан
17	Bahamas	BHS	BS	t	Багамы
18	Bangladesh	BGD	BD	t	Бангладеш
19	Barbados	BRB	BB	t	Барбадос
20	Bahrain	BHR	BH	t	Бахрейн
21	Belarus	BLR	BY	t	Беларусь
22	Belize	BLZ	BZ	t	Белиз
23	Belgium	BEL	BE	t	Бельгия
24	Benin	BEN	BJ	t	Бенин
25	Bermuda	BMU	BM	t	Бермуды
27	Bolivia	BOL	BO	t	Боливия
28	Bosnia and Herzegovina	BIH	BA	t	Босния и Герцеговина
29	Botswana	BWA	BW	t	Ботсвана
30	Brazil	BRA	BR	t	Бразилия
31	British Indian Ocean Territory	IOT	IO	t	Британская территория в Индийском океане
32	Brunei Darussalam	BRN	BN	t	Бруней-Даруссалам
33	Burkina Faso	BFA	BF	t	Буркина-Фасо
34	Burundi	BDI	BI	t	Бурунди
35	Bhutan	BTN	BT	t	Бутан
36	Vanuatu	VUT	VU	t	Вануату
37	Hungary	HUN	HU	t	Венгрия
196	Somalia	SOM	SO	t	Сомали
38	Venezuela	VEN	VE	t	Венесуэла
39	Virgin Islands, British	VGB	VG	t	Виргинские острова, Британские
40	Virgin Islands, U.S.	VIR	VI	t	Виргинские острова, США
41	Viet Nam	VNM	VN	t	Вьетнам
42	Gabon	GAB	GA	t	Габон
43	Haiti	HTI	HT	t	Гаити
44	Guyana	GUY	GY	t	Гайана
45	Gambia	GMB	GM	t	Гамбия
46	Ghana	GHA	GH	t	Гана
47	Guadeloupe	GLP	GP	t	Гваделупа
48	Guatemala	GTM	GT	t	Гватемала
49	Guinea	GIN	GN	t	Гвинея
50	Guinea-Bissau	GNB	GW	t	Гвинея-Бисау
51	Germany	DEU	DE	t	Германия
52	Guernsey	GGY	GG	t	Гернси
53	Gibraltar	GIB	GI	t	Гибралтар
54	Honduras	HND	HN	t	Гондурас
55	Hong Kong	HKG	HK	t	Гонконг
56	Grenada	GRD	GD	t	Гренада
57	Greenland	GRL	GL	t	Гренландия
59	Georgia	GEO	GE	t	Грузия
60	Guam	GUM	GU	t	Гуам
61	Denmark	DNK	DK	t	Дания
62	Jersey	JEY	JE	t	Джерси
63	Djibouti	DJI	DJ	t	Джибути
64	Dominica	DMA	DM	t	Доминика
65	Dominican Republic	DOM	DO	t	Доминиканская Республика
66	Egypt	EGY	EG	t	Египет
67	Zambia	ZMB	ZM	t	Замбия
68	Western Sahara	ESH	EH	t	Западная Сахара
69	Zimbabwe	ZWE	ZW	t	Зимбабве
70	Israel	ISR	IL	t	Израиль
71	India	IND	IN	t	Индия
72	Indonesia	IDN	ID	t	Индонезия
73	Jordan	JOR	JO	t	Иордания
74	Iraq	IRQ	IQ	t	Ирак
76	Ireland	IRL	IE	t	Ирландия
77	Iceland	ISL	IS	t	Исландия
78	Spain	ESP	ES	t	Испания
79	Italy	ITA	IT	t	Италия
80	Yemen	YEM	YE	t	Йемен
81	Cape Verde	CPV	CV	t	Кабо-Верде
82	Kazakhstan	KAZ	KZ	t	Казахстан
83	Cambodia	KHM	KH	t	Камбоджа
84	Cameroon	CMR	CM	t	Камерун
85	Canada	CAN	CA	t	Канада
86	Qatar	QAT	QA	t	Катар
87	Kenya	KEN	KE	t	Кения
88	Cyprus	CYP	CY	t	Кипр
89	Kyrgyzstan	KGZ	KG	t	Киргизия
90	Kiribati	KIR	KI	t	Кирибати
91	China	CHN	CN	t	Китай
92	Cocos (Keeling) Islands	CCK	CC	t	Кокосовые (Килинг) острова
93	Colombia	COL	CO	t	Колумбия
94	Comoros	COM	KM	t	Коморы
95	Congo	COG	CG	t	Конго
96	Democratic Republic of the Congo	COD	CD	t	Конго, Демократическая Республика
97	Democratic People's Republic of Korea	PRK	KP	t	Корея, Народно-Демократическая Республика
98	Republic of Korea	KOR	KR	t	Корея, Республика
99	Costa Rica	CRI	CR	t	Коста-Рика
100	Côte d'Ivoire	CIV	CI	t	Кот д'Ивуар
101	Cuba	CUB	CU	t	Куба
102	Kuwait	KWT	KW	t	Кувейт
103	Lao People's Democratic Republic	LAO	LA	t	Лаос
104	Latvia	LVA	LV	t	Латвия
105	Lesotho	LSO	LS	t	Лесото
106	Liberia	LBR	LR	t	Либерия
107	Lebanon	LBN	LB	t	Ливан
108	Libya	LBY	LY	t	Ливия
109	Lithuania	LTU	LT	t	Литва
110	Liechtenstein	LIE	LI	t	Лихтенштейн
111	Luxembourg	LUX	LU	t	Люксембург
112	Mauritius	MUS	MU	t	Маврикий
113	Mauritania	MRT	MR	t	Мавритания
114	Madagascar	MDG	MG	t	Мадагаскар
115	Mayotte	MYT	YT	t	Майотта
116	Macao	MAC	MO	t	Макао
117	Macedonia	MKD	MK	t	Македония
118	Malawi	MWI	MW	t	Малави
119	Malaysia	MYS	MY	t	Малайзия
120	Mali	MLI	ML	t	Мали
121	United States Minor Outlying Islands	UMI	UM	t	Малые Тихоокеанские отдаленные острова Соединенных Штатов
122	Maldives	MDV	MV	t	Мальдивы
123	Malta	MLT	MT	t	Мальта
124	Morocco	MAR	MA	t	Марокко
125	Martinique	MTQ	MQ	t	Мартиника
126	Marshall Islands	MHL	MH	t	Маршалловы острова
127	Mexico	MEX	MX	t	Мексика
128	Micronesia	FSM	FM	t	Микронезия
129	Mozambique	MOZ	MZ	t	Мозамбик
75	Iran	IRI	IR	t	Иран
58	Greece	GRE	GR	t	Греция
130	Moldova	MDA	MD	t	Молдова
131	Monaco	MCO	MC	t	Монако
132	Mongolia	MNG	MN	t	Монголия
133	Montserrat	MSR	MS	t	Монтсеррат
134	Myanmar	MMR	MM	t	Мьянма
135	Namibia	NAM	NA	t	Намибия
136	Nauru	NRU	NR	t	Науру
137	Nepal	NPL	NP	t	Непал
138	Niger	NER	NE	t	Нигер
139	Nigeria	NGA	NG	t	Нигерия
140	Netherlands Antilles	ANT	AN	t	Нидерландские Антилы
141	Netherlands	NLD	NL	t	Нидерланды
142	Nicaragua	NIC	NI	t	Никарагуа
143	Niue	NIU	NU	t	Ниуэ
144	New Zealand	NZL	NZ	t	Новая Зеландия
145	New Caledonia	NCL	NC	t	Новая Каледония
146	Norway	NOR	NO	t	Норвегия
147	United Arab Emirates	ARE	AE	t	Объединенные Арабские Эмираты
148	Oman	OMN	OM	t	Оман
149	Bouvet Island	BVT	BV	t	Остров Буве
150	Isle of Man	IMN	IM	t	Остров Мэн
151	Norfolk Island	NFK	NF	t	Остров Норфолк
152	Christmas Island	CXR	CX	t	Остров Рождества
153	Heard Island and McDonald Islands	HMD	HM	t	Остров Херд и Острова Макдональд
154	Cayman Islands	CYM	KY	t	Острова Кайман
155	Cook Islands	COK	CK	t	Острова Кука
156	Turks and Caicos Islands	TCA	TC	t	Острова Теркс и Кайкос
157	Pakistan	PAK	PK	t	Пакистан
158	Palau	PLW	PW	t	Палау
159	Palestine	PSE	PS	t	Палестинская Территория, оккупированная
160	Panama	PAN	PA	t	Панама
161	Holy See (Vatican City State)	VAT	VA	t	Папский Престол (Государство-город Ватикан)
162	Papua New Guinea	PNG	PG	t	Папуа-Новая Гвинея
163	Paraguay	PRY	PY	t	Парагвай
164	Peru	PER	PE	t	Перу
165	Pitcairn	PCN	PN	t	Питкерн
166	Poland	POL	PL	t	Польша
167	Portugal	PRT	PT	t	Португалия
168	Puerto Rico	PRI	PR	t	Пуэрто-Рико
169	Réunion	REU	RE	t	Реюньон
170	Russian Federation	RUS	RU	t	Россия
171	Rwanda	RWA	RW	t	Руанда
172	Romania	ROU	RO	t	Румыния
173	Samoa	WSM	WS	t	Самоа
174	San Marino	SMR	SM	t	Сан-Марино
175	Sao Tome and Principe	STP	ST	t	Сан-Томе и Принсипи
176	Saudi Arabia	SAU	SA	t	Саудовская Аравия
177	Swaziland	SWZ	SZ	t	Свазиленд
178	Saint Helena	SHN	SH	t	Святая Елена
179	Northern Mariana Islands	MNP	MP	t	Северные Марианские острова
180	Seychelles	SYC	SC	t	Сейшелы
181	Saint Barthélemy	BLM	BL	t	Сен-Бартелеми
182	Senegal	SEN	SN	t	Сенегал
183	Saint Martin (French part)	MAF	MF	t	Сен-Мартен
184	Saint Pierre and Miquelon	SPM	PM	t	Сен-Пьер и Микелон
185	Saint Vincent and the Grenadines	VCT	VC	t	Сент-Винсент и Гренадины
186	Saint Kitts and Nevis	KNA	KN	t	Сент-Китс и Невис
187	Saint Lucia	LCA	LC	t	Сент-Люсия
188	Serbia	SRB	RS	t	Сербия
189	Singapore	SGP	SG	t	Сингапур
190	Syrian Arab Republic	SYR	SY	t	Сирия
191	Slovakia	SVK	SK	t	Словакия
192	Slovenia	SVN	SI	t	Словения
193	United Kingdom	GBR	GB	t	Соединенное Королевство
194	United States	USA	US	t	Соединенные Штаты
195	Solomon Islands	SLB	SB	t	Соломоновы острова
197	Sudan	SDN	SD	t	Судан
198	Suriname	SUR	SR	t	Суринам
199	Sierra Leone	SLE	SL	t	Сьерра-Леоне
200	Tajikistan	TJK	TJ	t	Таджикистан
201	Thailand	THA	TH	t	Таиланд
203	Tanzania	TZA	TZ	t	Танзания
204	Timor-Leste	TLS	TL	t	Тимор-Лесте
205	Togo	TGO	TG	t	Того
206	Tokelau	TKL	TK	t	Токелау
207	Tonga	TON	TO	t	Тонга
208	Trinidad and Tobago	TTO	TT	t	Тринидад и Тобаго
209	Tuvalu	TUV	TV	t	Тувалу
210	Tunisia	TUN	TN	t	Тунис
211	Turkmenistan	TKM	TM	t	Туркмения
212	Turkey	TUR	TR	t	Турция
213	Uganda	UGA	UG	t	Уганда
214	Uzbekistan	UZB	UZ	t	Узбекистан
215	Ukraine	UKR	UA	t	Украина
216	Wallis and Futuna	WLF	WF	t	Уоллис и Футуна
217	Uruguay	URY	UY	t	Уругвай
218	Faroe Islands	FRO	FO	t	Фарерские острова
219	Fiji	FJI	FJ	t	Фиджи
220	Philippines	PHL	PH	t	Филиппины
221	Finland	FIN	FI	t	Финляндия
222	Falkland Islands (Malvinas)	FLK	FK	t	Фолклендские острова (Мальвинские)
223	France	FRA	FR	t	Франция
224	French Guiana	GUF	GF	t	Французская Гвиана
225	French Polynesia	PYF	PF	t	Французская Полинезия
226	French Southern Territories	ATF	TF	t	Французские Южные территории
227	Croatia	HRV	HR	t	Хорватия
228	Central African Republic	CAF	CF	t	Центрально-Африканская Республика
229	Chad	TCD	TD	t	Чад
230	Montenegro	MNE	ME	t	Черногория
231	Czech Republic	CZE	CZ	t	Чешская Республика
232	Chile	CHL	CL	t	Чили
233	Switzerland	CHE	CH	t	Швейцария
234	Sweden	SWE	SE	t	Швеция
235	Svalbard and Jan Mayen	SJM	SJ	t	Шпицберген и Ян Майен
236	Sri Lanka	LKA	LK	t	Шри-Ланка
237	Ecuador	ECU	EC	t	Эквадор
238	Equatorial Guinea	GNQ	GQ	t	Экваториальная Гвинея
239	Åland Islands	ALA	АХ	t	Эландские острова
240	El Salvador	SLV	SV	t	Эль-Сальвадор
241	Eritrea	ERI	ER	t	Эритрея
242	Estonia	EST	EE	t	Эстония
243	Ethiopia	ETH	ET	t	Эфиопия
244	South Africa	ZAF	ZA	t	Южная Африка
245	South Georgia and the South Sandwich Islands	SGS	GS	t	Южная Джорджия и Южные Сандвичевы острова
246	South Ossetia	OST	OS	t	Южная Осетия
247	Jamaica	JAM	JM	t	Ямайка
248	Japan	JPN	JP	t	Япония
249	Soviet Union	SUH	SU	f	Союз Советских Социалистических Республик
26	Bulgaria	BUL	BG	t	Болгария
202	Taiwan, Province of China	TPE	TW	t	Тайвань (Китай)
\.


--
-- Data for Name: disqualifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disqualifications (id, reason, attempt_id) FROM stdin;
\.


--
-- Data for Name: email_approvals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_approvals (id, email, user_id, created, approved) FROM stdin;
8dba2f40-1798-11e7-8703-54a050c33469	sdsdsd@sd	20	2017-04-02 14:36:03.831	f
71c67000-17c5-11e7-9f04-54a050c33469	ilia.mokin@gmail.co	18	2017-04-02 19:57:24.287	f
8c261d92-17c5-11e7-9f05-54a050c33469	ilia.mokin@gmail.co	18	2017-04-02 19:58:08.539	f
deb7bb06-17c5-11e7-85c9-54a050c33469	ilia.mokin@gmail.c	18	2017-04-02 20:00:27.063	f
e90eeaa2-17c5-11e7-85ca-54a050c33469	ilia.mokin@gmail.com	18	2017-04-02 20:00:44.414	f
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (id, name) FROM stdin;
1	Snatch
3	Total
4	Press
2	Clean and jerk
\.


--
-- Data for Name: filters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filters (id, filter) FROM stdin;
wbGrwrwS	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:1150"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:1151"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 2, "name": "69kg", "active": true, "$$hashKey": "object:984"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 69кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
TUbI9dvt	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:1851"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:1852"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 4, "name": "85kg", "active": true, "$$hashKey": "object:1684"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 85кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
OVwP97Vd	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:840"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:843"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 33, "name": "56kg", "active": true, "$$hashKey": "object:120"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 56кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
uyehFNu-	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:840"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:843"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 1, "name": "62kg", "active": true, "$$hashKey": "object:121"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 62кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
s6xsbSJ6	{"do": {"addFilter": {}}, "male": null, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:1965"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:1968"}], "world": true, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": false, "athletes": [{"id": 64, "sex": "men", "name": "TALAKHADZE Lasha", "$$hashKey": "object:1767", "birth_date": "1993-10-02", "country_name": "GEO"}, {"id": 108, "sex": "women", "name": "KASHIRINA Tatiana", "$$hashKey": "object:1917", "birth_date": "1991-01-24", "country_name": "RUS"}, {"id": 66, "sex": "men", "name": "REZA ZADEH Hossein", "$$hashKey": "object:1973", "birth_date": "1978-05-12", "country_name": "IRI"}], "category": null, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": true, "filterName": "Men vs Women", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
Mm_MUYeb	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:1487"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:1488"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 3, "name": "77kg", "active": true, "$$hashKey": "object:1331"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 77кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
yd9tpAw0	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:2218"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:2219"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 5, "name": "94kg", "active": true, "$$hashKey": "object:2055"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 94кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
bfpmu843	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:2555"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:2556"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 6, "name": "105kg", "active": true, "$$hashKey": "object:2402"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды 105кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
b55xndVs	{"do": {"addFilter": {}}, "male": true, "_meta": {"result": "desc", "exercise_name": "desc"}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc", "$$hashKey": "object:2892"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc", "$$hashKey": "object:2893"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": true, "athletes": [], "category": {"id": 7, "name": "105kg+", "active": true, "$$hashKey": "object:2737"}, "exercise": null, "hideDsql": false, "countries": [], "videoOnly": false, "activeOnly": false, "filterName": "Олимпийские рекорды +105кг", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
6bMGrj81	{"do": {"addFilter": {}}, "male": null, "_meta": {"result": "desc", "exercise_name": "desc", "category_names": null, "competition_name": null, "athlete_country_name": null}, "sorts": [{"id": "exercise_name", "text": "Упражнение", "_meta": {"name": "exercise_name", "text": "Упражнение", "type": "exercise"}, "order": "desc"}, {"id": "result", "text": "Результат", "_meta": {"name": "result", "text": "Результат", "type": "number"}, "order": "desc"}], "world": false, "period": {"id": 1, "name": "(current)1998+"}, "record": false, "country": null, "filters": [], "olympic": false, "athletes": [], "category": null, "exercise": null, "hideDsql": false, "countries": [{"id": 91, "key": "CN", "name": "Китай", "search_f": "CHN_CN_Китай", "short_name": "CHN"}], "videoOnly": false, "activeOnly": true, "filterName": "Рекорды за Китаем", "activeRecord": false, "competitions": [], "searchTextComp": "", "competitionType": null, "searchTextAthlete": ""}
world	{"name": "World Records", "refs": [{"val": "-1", "name": "sex"}, {"val": "-1", "name": "category_id"}, {"val": "-1", "name": "exercise_id"}, {"val": "-1", "name": "competition_type_id"}, {"val": "", "name": "athlete_country_id"}, {"val": "", "name": "athlete_id"}, {"val": false, "name": "is_dsq"}, {"val": false, "name": "has_video"}, {"val": false, "name": "is_active_record"}, {"val": true, "name": "is_world_record"}, {"val": false, "name": "is_olympic_record"}]}
olympic	{"name": "Olympic Records", "refs": [{"val": "-1", "name": "sex"}, {"val": "-1", "name": "category_id"}, {"val": "-1", "name": "exercise_id"}, {"val": "-1", "name": "competition_type_id"}, {"val": "", "name": "athlete_country_id"}, {"val": "", "name": "athlete_id"}, {"val": false, "name": "is_dsq"}, {"val": false, "name": "has_video"}, {"val": false, "name": "is_active_record"}, {"val": false, "name": "is_world_record"}, {"val": true, "name": "is_olympic_record"}]}
bestworld	{"name": "The Best World Records ", "refs": [{"val": "men", "name": "sex"}, {"val": "7", "name": "category_id"}, {"val": "-1", "name": "exercise_id"}, {"val": "-1", "name": "competition_type_id"}, {"val": "", "name": "athlete_country_id"}, {"val": "", "name": "athlete_id"}, {"val": false, "name": "is_dsq"}, {"val": false, "name": "has_video"}, {"val": true, "name": "is_active_record"}, {"val": true, "name": "is_world_record"}, {"val": false, "name": "is_olympic_record"}]}
\.


--
-- Data for Name: periods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periods (id, name) FROM stdin;
1	(current)1998+
2	1993–1997
4	1920–1972
3	1973–1992
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.places (id, name, country_id) FROM stdin;
50	Hangzhou	91
13	Antalya	212
12	Houston	194
14	Incheon	98
16	Pyongyang	97
23	London	193
41	Split	227
24	Kanazawa	248
20	Sydney	2
26	Wroclaw	166
33	Havirov	231
21	Izmir	212
22	Busan	98
34	Tehran	75
29	Goyang	98
25	Almaty	82
19	Rio de Janeiro	30
31	ChiangMai	201
43	Santo Domingo	65
45	Guangzhou	91
46	Warsaw	166
47	Bali	72
48	Vancouver	85
32	Wladyslawowo	166
17	Trencin	191
35	Ramat Gan	70
37	Sofia	26
38	Grozny	170
39	Belgorod	170
40	Kiev	215
28	Athens	58
44	Tai'an	91
27	Qinhuangdao	91
30	Doha	86
36	Beijing	91
42	Paris	223
49	Kazan	170
\.


--
-- Data for Name: record_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_types (name, id) FROM stdin;
World	1
Olympic	2
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.records (id, attempt_id, category_id, record_type, exercise_id, active, added) FROM stdin;
604	141	6	1	2	f	2017-05-18 10:03:13.852398
356	109	2	1	3	f	2017-05-17 22:34:36.539887
357	97	1	1	2	f	2017-05-17 22:34:36.539887
359	113	3	1	1	f	2017-05-17 22:34:36.539887
360	119	3	1	3	f	2017-05-17 22:34:36.539887
363	120	3	1	3	f	2017-05-17 22:34:36.539887
364	114	3	1	1	f	2017-05-17 22:34:36.539887
641	287	2	1	1	f	2017-05-19 22:35:10.331229
367	124	4	1	1	f	2017-05-17 22:34:36.539887
368	122	4	1	1	f	2017-05-17 22:34:36.539887
370	127	4	1	2	f	2017-05-17 22:34:36.539887
536	156	34	1	1	f	2017-05-17 23:55:14.727426
372	125	4	1	1	f	2017-05-17 22:34:36.539887
374	137	6	1	1	f	2017-05-17 22:34:36.539887
519	130	4	2	3	f	2017-05-17 23:45:07.614733
520	130	4	1	3	f	2017-05-17 23:45:07.614733
380	142	6	1	2	f	2017-05-17 22:34:36.539887
381	143	6	1	2	f	2017-05-17 22:34:36.539887
382	146	6	1	3	f	2017-05-17 22:34:36.539887
362	111	3	1	1	f	2017-05-17 22:34:36.539887
384	150	7	1	1	f	2017-05-17 22:34:36.539887
385	151	7	1	1	f	2017-05-17 22:34:36.539887
386	182	9	1	1	f	2017-05-17 22:34:36.539887
365	116	3	1	2	f	2017-05-17 22:34:36.539887
388	158	34	1	2	f	2017-05-17 22:34:36.539887
389	161	34	1	2	f	2017-05-17 22:34:36.539887
390	168	8	1	1	f	2017-05-17 22:34:36.539887
391	170	8	1	2	f	2017-05-17 22:34:36.539887
392	165	34	1	3	f	2017-05-17 22:34:36.539887
393	160	34	1	2	f	2017-05-17 22:34:36.539887
664	325	7	2	1	f	2017-05-22 10:30:21.579035
395	177	8	1	3	f	2017-05-17 22:34:36.539887
397	171	8	1	2	f	2017-05-17 22:34:36.539887
355	129	4	1	3	f	2017-05-17 22:34:36.539887
399	172	8	1	2	f	2017-05-17 22:34:36.539887
400	173	8	1	2	f	2017-05-17 22:34:36.539887
401	175	8	1	2	f	2017-05-17 22:34:36.539887
402	174	8	1	2	f	2017-05-17 22:34:36.539887
403	178	8	1	3	f	2017-05-17 22:34:36.539887
404	194	9	1	3	f	2017-05-17 22:34:36.539887
405	190	9	1	3	f	2017-05-17 22:34:36.539887
406	184	9	1	2	f	2017-05-17 22:34:36.539887
660	140	6	1	2	f	2017-05-20 00:15:23.165714
410	186	9	1	2	f	2017-05-17 22:34:36.539887
411	193	9	1	3	f	2017-05-17 22:34:36.539887
412	185	9	1	2	f	2017-05-17 22:34:36.539887
413	187	9	1	2	f	2017-05-17 22:34:36.539887
414	188	9	1	2	f	2017-05-17 22:34:36.539887
373	136	6	1	1	f	2017-05-17 22:34:36.539887
416	213	10	1	3	f	2017-05-17 22:34:36.539887
417	205	10	1	2	f	2017-05-17 22:34:36.539887
418	212	10	1	3	f	2017-05-17 22:34:36.539887
419	214	10	1	3	f	2017-05-17 22:34:36.539887
421	211	10	1	3	f	2017-05-17 22:34:36.539887
422	201	10	1	2	f	2017-05-17 22:34:36.539887
423	202	10	1	2	f	2017-05-17 22:34:36.539887
424	210	10	1	3	f	2017-05-17 22:34:36.539887
425	200	10	1	2	f	2017-05-17 22:34:36.539887
427	204	10	1	2	f	2017-05-17 22:34:36.539887
428	206	10	1	2	f	2017-05-17 22:34:36.539887
429	207	10	1	2	f	2017-05-17 22:34:36.539887
430	203	10	1	2	f	2017-05-17 22:34:36.539887
541	179	8	1	3	f	2017-05-17 23:58:10.277332
434	221	11	1	2	f	2017-05-17 22:34:36.539887
435	229	12	1	1	f	2017-05-17 22:34:36.539887
436	228	12	1	1	f	2017-05-17 22:34:36.539887
437	230	12	1	1	f	2017-05-17 22:34:36.539887
438	231	12	1	1	f	2017-05-17 22:34:36.539887
439	233	12	1	1	f	2017-05-17 22:34:36.539887
440	232	12	1	1	f	2017-05-17 22:34:36.539887
441	234	12	1	1	f	2017-05-17 22:34:36.539887
442	159	34	1	2	f	2017-05-17 22:34:36.539887
443	237	12	1	2	f	2017-05-17 22:34:36.539887
444	238	12	1	2	f	2017-05-17 22:34:36.539887
556	222	11	2	2	f	2017-05-18 00:02:55.311528
557	222	11	1	2	f	2017-05-18 00:02:55.311528
447	268	33	1	1	f	2017-05-17 22:34:36.539887
448	269	33	1	2	f	2017-05-17 22:34:36.539887
449	270	33	1	2	f	2017-05-17 22:34:36.539887
450	291	2	1	3	f	2017-05-17 22:34:36.539887
566	255	12	2	3	f	2017-05-18 00:07:09.035311
452	278	1	1	1	f	2017-05-17 22:34:36.539887
567	255	12	1	3	f	2017-05-18 00:07:09.035311
455	284	1	1	3	f	2017-05-17 22:34:36.539887
458	292	2	1	2	f	2017-05-17 22:34:36.539887
459	245	12	1	3	f	2017-05-17 22:34:36.539887
461	250	12	1	3	f	2017-05-17 22:34:36.539887
462	242	12	1	2	f	2017-05-17 22:34:36.539887
463	246	12	1	3	f	2017-05-17 22:34:36.539887
464	248	12	1	3	f	2017-05-17 22:34:36.539887
465	247	12	1	3	f	2017-05-17 22:34:36.539887
466	239	12	1	2	f	2017-05-17 22:34:36.539887
467	240	12	1	2	f	2017-05-17 22:34:36.539887
468	252	12	1	3	f	2017-05-17 22:34:36.539887
469	254	12	1	3	f	2017-05-17 22:34:36.539887
470	253	12	1	3	f	2017-05-17 22:34:36.539887
471	243	12	1	2	f	2017-05-17 22:34:36.539887
472	251	12	1	3	f	2017-05-17 22:34:36.539887
473	241	12	1	2	f	2017-05-17 22:34:36.539887
474	249	12	1	3	f	2017-05-17 22:34:36.539887
475	276	1	1	3	f	2017-05-17 22:34:36.539887
476	283	1	1	3	f	2017-05-17 22:34:36.539887
478	262	33	1	2	f	2017-05-17 22:34:36.539887
479	123	4	1	1	f	2017-05-17 22:34:36.539887
480	131	4	1	3	f	2017-05-17 22:34:36.539887
482	164	34	1	3	f	2017-05-17 22:34:36.539887
483	163	34	1	3	f	2017-05-17 22:34:36.539887
485	191	9	1	3	f	2017-05-17 22:34:36.539887
486	192	9	1	3	f	2017-05-17 22:34:36.539887
487	181	9	1	1	f	2017-05-17 22:34:36.539887
489	196	10	1	1	f	2017-05-17 22:34:36.539887
503	273	33	2	3	f	2017-05-17 23:29:53.343288
504	273	33	1	3	f	2017-05-17 23:29:53.343288
533	154	7	2	3	f	2017-05-17 23:51:54.89026
534	154	7	1	3	f	2017-05-17 23:51:54.89026
552	218	11	2	1	f	2017-05-18 00:02:10.259203
426	209	10	1	3	f	2017-05-17 22:34:36.539887
553	218	11	1	1	f	2017-05-18 00:02:10.259203
560	224	11	2	3	f	2017-05-18 00:04:06.114491
561	224	11	1	3	f	2017-05-18 00:04:06.114491
569	346	13	2	1	f	2017-05-18 00:08:07.195814
490	293	11	1	3	f	2017-05-17 22:34:36.539887
509	112	3	2	1	f	2017-05-17 23:37:38.395516
510	112	3	1	1	f	2017-05-17 23:37:38.395516
420	199	10	1	2	f	2017-05-17 22:34:36.539887
524	145	6	1	3	f	2017-05-17 23:47:37.439234
283	305	33	2	2	f	2017-05-17 22:34:34.468343
284	309	1	2	2	f	2017-05-17 22:34:34.468343
662	139	6	1	2	f	2017-05-20 00:18:52.845907
506	285	1	1	3	f	2017-05-17 23:31:40.595308
564	235	12	2	1	f	2017-05-18 00:06:18.228751
565	235	12	1	1	f	2017-05-18 00:06:18.228751
550	216	11	2	1	f	2017-05-18 00:02:06.145071
551	216	11	1	1	f	2017-05-18 00:02:06.145071
543	197	10	1	1	f	2017-05-17 23:59:46.828559
539	166	34	1	3	f	2017-05-17 23:56:36.455085
288	304	33	2	2	f	2017-05-17 22:34:34.468343
289	310	1	2	3	f	2017-05-17 22:34:34.468343
291	307	1	2	1	f	2017-05-17 22:34:34.468343
292	303	33	2	2	f	2017-05-17 22:34:34.468343
294	318	4	2	2	f	2017-05-17 22:34:34.468343
296	316	4	2	3	f	2017-05-17 22:34:34.468343
297	313	3	2	1	f	2017-05-17 22:34:34.468343
298	314	3	2	3	f	2017-05-17 22:34:34.468343
302	315	3	2	2	f	2017-05-17 22:34:34.468343
307	324	6	2	2	f	2017-05-17 22:34:34.468343
312	329	8	2	1	f	2017-05-17 22:34:34.468343
314	331	9	2	1	f	2017-05-17 22:34:34.468343
315	333	9	2	1	f	2017-05-17 22:34:34.468343
318	336	9	2	3	f	2017-05-17 22:34:34.468343
319	337	10	2	2	f	2017-05-17 22:34:34.468343
320	338	10	2	2	f	2017-05-17 22:34:34.468343
321	339	10	2	2	f	2017-05-17 22:34:34.468343
322	340	10	2	3	f	2017-05-17 22:34:34.468343
323	341	10	2	3	f	2017-05-17 22:34:34.468343
324	342	10	2	3	f	2017-05-17 22:34:34.468343
332	367	13	2	1	f	2017-05-17 22:34:34.468343
333	367	65	2	1	f	2017-05-17 22:34:34.468343
334	368	13	2	1	f	2017-05-17 22:34:34.468343
335	368	65	2	1	f	2017-05-17 22:34:34.468343
336	369	13	2	1	f	2017-05-17 22:34:34.468343
337	369	65	2	1	f	2017-05-17 22:34:34.468343
338	370	13	2	1	f	2017-05-17 22:34:34.468343
339	370	65	2	1	f	2017-05-17 22:34:34.468343
340	371	13	2	1	f	2017-05-17 22:34:34.468343
341	371	65	2	1	f	2017-05-17 22:34:34.468343
344	373	13	2	2	f	2017-05-17 22:34:34.468343
345	373	65	2	2	f	2017-05-17 22:34:34.468343
348	375	13	2	3	f	2017-05-17 22:34:34.468343
349	375	65	2	3	f	2017-05-17 22:34:34.468343
350	376	13	2	3	f	2017-05-17 22:34:34.468343
351	376	65	2	3	f	2017-05-17 22:34:34.468343
352	377	13	2	3	f	2017-05-17 22:34:34.468343
353	377	65	2	3	f	2017-05-17 22:34:34.468343
514	118	3	1	3	f	2017-05-17 23:39:11.67658
432	217	11	1	1	f	2017-05-17 22:34:36.539887
562	226	11	2	3	f	2017-05-18 00:04:10.073392
563	226	11	1	3	f	2017-05-18 00:04:10.073392
433	220	11	1	2	f	2017-05-17 22:34:36.539887
666	149	7	1	1	f	2017-06-09 17:07:16.070677
667	149	7	2	1	f	2017-06-09 17:07:16.070677
668	148	7	1	1	f	2017-06-09 17:09:22.363734
635	115	3	2	2	t	2017-05-19 21:00:51.312502
325	343	12	2	1	t	2017-05-17 22:34:34.468343
669	148	7	2	1	t	2017-06-09 17:09:22.363734
535	156	34	2	1	t	2017-05-17 23:55:14.727426
330	366	13	2	1	t	2017-05-17 22:34:34.468343
316	334	9	2	2	t	2017-05-17 22:34:34.468343
523	145	6	2	3	t	2017-05-17 23:47:37.439234
394	167	8	1	1	t	2017-05-17 22:34:36.539887
545	198	10	1	2	t	2017-05-18 00:00:10.250208
601	135	6	2	1	t	2017-05-18 09:50:16.178475
407	180	9	1	1	t	2017-05-17 22:34:36.539887
616	121	4	1	1	t	2017-05-19 19:59:40.113363
628	153	7	1	3	t	2017-05-19 20:31:06.616094
310	327	8	2	1	t	2017-05-17 22:34:34.468343
396	169	8	1	2	t	2017-05-17 22:34:36.539887
484	155	34	1	1	t	2017-05-17 22:34:36.539887
540	179	8	2	3	t	2017-05-17 23:58:10.277332
558	223	11	2	3	t	2017-05-18 00:04:02.443241
331	366	65	2	1	t	2017-05-17 22:34:34.468343
663	80	33	1	2	t	2017-05-22 10:06:30.85616
311	328	8	2	2	t	2017-05-17 22:34:34.468343
513	118	3	2	3	t	2017-05-17 23:39:11.67658
610	132	5	1	1	t	2017-05-19 19:29:59.544182
615	133	5	1	2	t	2017-05-19 19:55:44.492947
652	306	1	2	1	t	2017-05-19 22:59:10.604456
622	128	4	2	3	t	2017-05-19 20:22:22.118697
326	344	12	2	2	t	2017-05-17 22:34:34.468343
634	115	3	1	2	t	2017-05-19 21:00:51.312502
654	308	1	2	2	t	2017-05-19 23:14:05.376617
575	147	7	1	1	t	2017-05-18 00:28:26.617763
304	322	5	2	3	t	2017-05-17 22:34:34.468343
327	345	12	2	3	t	2017-05-17 22:34:34.468343
636	286	2	1	1	t	2017-05-19 22:12:23.166223
313	330	9	2	1	t	2017-05-17 22:34:34.468343
599	152	7	2	2	t	2017-05-18 09:40:49.651486
600	135	6	1	1	t	2017-05-18 09:50:16.178475
544	198	10	2	2	t	2017-05-18 00:00:10.250208
361	117	3	1	3	t	2017-05-17 22:34:36.539887
631	110	3	2	1	t	2017-05-19 20:51:16.028735
623	317	4	2	2	t	2017-05-19 20:23:16.160268
538	166	34	2	3	t	2017-05-17 23:56:36.455085
481	144	6	1	3	t	2017-05-17 22:34:36.539887
408	189	9	1	3	t	2017-05-17 22:34:36.539887
629	153	7	2	3	t	2017-05-19 20:31:06.616094
554	219	11	2	2	t	2017-05-18 00:02:51.234492
346	374	13	2	3	t	2017-05-17 22:34:34.468343
573	351	65	1	3	t	2017-05-18 00:09:45.248243
638	289	2	1	2	t	2017-05-19 22:30:02.097929
548	215	11	2	1	t	2017-05-18 00:02:02.125327
376	134	5	1	3	t	2017-05-17 22:34:36.539887
559	223	11	1	3	t	2017-05-18 00:04:02.443241
653	277	1	1	1	t	2017-05-19 23:10:54.092012
649	282	1	1	3	t	2017-05-19 22:51:31.676004
611	320	5	2	1	t	2017-05-19 19:39:35.123667
656	302	33	2	2	t	2017-05-19 23:21:20.707014
665	70	33	1	1	t	2017-06-03 22:01:18.696132
618	126	4	1	2	t	2017-05-19 20:11:33.347944
642	287	2	2	1	t	2017-05-19 22:35:10.331229
451	244	12	1	3	t	2017-05-17 22:34:36.539887
603	138	6	1	2	t	2017-05-18 09:54:21.815346
409	183	9	1	2	t	2017-05-17 22:34:36.539887
505	285	1	2	3	t	2017-05-17 23:31:40.595308
571	350	65	1	2	t	2017-05-18 00:09:20.501371
546	208	10	2	3	t	2017-05-18 00:00:44.075975
655	301	33	2	1	t	2017-05-19 23:18:42.636297
347	374	65	2	3	t	2017-05-17 22:34:34.468343
657	271	33	1	3	t	2017-05-19 23:21:53.794838
445	236	12	1	2	t	2017-05-17 22:34:36.539887
617	319	4	2	1	t	2017-05-19 20:05:22.491473
621	128	4	1	3	t	2017-05-19 20:22:22.118697
645	311	2	2	2	t	2017-05-19 22:39:09.710947
606	323	6	2	2	t	2017-05-18 10:07:53.383154
431	227	12	1	1	t	2017-05-17 22:34:36.539887
572	347	64	1	2	t	2017-05-18 00:09:41.671031
598	152	7	1	2	t	2017-05-18 09:40:49.651486
568	346	64	1	1	t	2017-05-18 00:08:07.195814
488	162	34	1	3	t	2017-05-17 22:34:36.539887
574	348	64	1	3	t	2017-05-18 00:09:50.1861
630	110	3	1	1	t	2017-05-19 20:51:16.028735
317	335	9	2	3	t	2017-05-17 22:34:34.468343
555	219	11	1	2	t	2017-05-18 00:02:51.234492
343	372	65	2	2	t	2017-05-17 22:34:34.468343
549	215	11	1	1	t	2017-05-18 00:02:02.125327
646	312	2	2	3	t	2017-05-19 22:43:09.952179
542	197	10	2	1	t	2017-05-17 23:59:46.828559
648	280	1	1	2	t	2017-05-19 22:49:21.547273
415	195	10	1	1	t	2017-05-17 22:34:36.539887
614	321	5	2	2	t	2017-05-19 19:55:22.375388
637	107	2	1	3	t	2017-05-19 22:28:37.903869
342	372	13	2	2	t	2017-05-17 22:34:34.468343
547	208	10	1	3	t	2017-05-18 00:00:44.075975
537	157	34	1	2	t	2017-05-17 23:55:42.410744
658	271	33	2	3	t	2017-05-19 23:21:53.794838
398	176	8	1	3	t	2017-05-17 22:34:36.539887
570	349	65	1	1	t	2017-05-18 00:08:58.14296
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sessions (sid, sess, expire) FROM stdin;
EdxAeosa1slVulFtBp46FoNEnLNXr0ln	{"cookie":{"originalMaxAge":2592000000,"expires":"2017-11-29T07:45:44.683Z","httpOnly":true,"path":"/"},"passport":{"user":{"id":18,"user_name":"Ilya Mokin","email":"ilia.mokin@gmail.com","is_admin":true,"activated":true}}}	2017-11-30 08:38:35
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, user_name, email, password_hash, is_admin, is_moderator, email_is_approved, created, activated, social_auth, token, profile_id) FROM stdin;
19	mokin	sdsdsd@sd	$2a$13$PAj4EyRuwHkgLFRNFT1OYuxYbU/uATCvOtxVzbBDGfwR.bUbCQAEm	f	f	f	2017-04-02 14:35:27.545	f	\N	\N	\N
20	mokin	sdsdsd@sd	$2a$13$9ty0Mf09ZN.Vjag9jBVgLeFJOz2uYs87deBNP2WpkQfgCp5GA4ko.	f	f	t	2017-04-02 14:36:03.825	t	\N	\N	\N
18	Ilya Mokin	ilia.mokin@gmail.com	$2a$13$xf8H6gh0eTTH2CYR0wN.fOGR2K3U0YRxNaiM5evsT8DqCvOPGPFq6	t	f	t	2017-04-01 13:34:30.266	t	\N	\N	\N
\.


--
-- Data for Name: weight_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weight_categories (id, period_id, from_w, to_w, active, type, name) FROM stdin;
1	1	56	62	t	men	62kg
2	1	62	69	t	men	69kg
3	1	69	77	t	men	77kg
4	1	77	85	t	men	85kg
5	1	85	94	t	men	94kg
6	1	94	105	t	men	105kg
7	1	105	\N	t	men	105kg+
8	1	48	53	t	women	53kg
9	1	53	58	t	women	58kg
10	1	58	63	t	women	63kg
11	1	63	69	t	women	69kg
12	1	69	75	t	women	75kg
14	2	54	59	f	men	59kg
15	2	59	64	f	men	64kg
16	2	64	70	f	men	70kg
17	2	70	76	f	men	76kg
18	2	76	83	f	men	83kg
19	2	83	91	f	men	91kg
20	2	91	99	f	men	99kg
21	2	99	108	f	men	108kg
22	2	108	\N	f	men	108kg+
23	3	\N	52	f	men	52kg
24	3	52	56	f	men	56kg
25	3	56	60	f	men	60kg
26	3	60	67.5	f	men	67.5kg
27	3	67.5	75	f	men	75kg
28	3	75	82.5	f	men	82.5kg
29	3	82.5	90	f	men	90kg
30	3	90	100	f	men	100kg
31	3	100	110	f	men	110kg
32	3	110	\N	f	men	110kg+
33	1	\N	56	t	men	56kg
34	1	\N	48	t	women	48kg
35	2	\N	54	f	men	54kg
36	4	\N	52	f	men	52kg
37	4	52	56	f	men	56kg
38	4	56	60	f	men	60kg
39	4	60	67.5	f	men	67.5kg
40	4	67.5	75	f	men	75kg
41	4	75	82.5	f	men	82.5kg
42	4	82.5	90	f	men	90kg
43	4	90	100	f	men	100kg
44	4	100	110	f	men	110kg
45	4	110	\N	f	men	110kg+
46	2	\N	46	f	women	46kg
47	2	46	50	f	women	50kg
48	2	50	54	f	women	54kg
49	2	54	59	f	women	59kg
50	2	59	64	f	women	64kg
51	2	64	70	f	women	70kg
52	2	70	76	f	women	76kg
53	2	76	83	f	women	83kg
54	2	83	\N	f	women	83kg+
55	3	\N	44	f	women	44kg
56	3	44	48	f	women	48kg
57	3	48	52	f	women	52kg
58	3	52	56	f	women	56kg
59	3	56	60	f	women	60kg
60	3	60	67.5	f	women	67.5kg
61	3	67.5	75	f	women	75kg
62	3	75	82.5	f	women	82.5kg
63	3	82.5	\N	f	women	82.5kg+
13	1	75	\N	f	women	75kg+
64	1	75	90	t	women	90kg
65	1	90	\N	t	women	90kg+
\.


--
-- Name: athlete_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.athlete_comments_id_seq', 1, false);


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.athletes_id_seq', 127, true);


--
-- Name: attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attempts_id_seq', 378, true);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: competition_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.competition_types_id_seq', 9, true);


--
-- Name: competitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.competitions_id_seq', 55, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 249, true);


--
-- Name: disqualifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disqualifications_id_seq', 1, false);


--
-- Name: exercises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_id_seq', 4, true);


--
-- Name: periods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periods_id_seq', 4, true);


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.places_id_seq', 50, true);


--
-- Name: record_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_types_id_seq', 2, true);


--
-- Name: records_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.records_category_id_seq', 1, false);


--
-- Name: records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.records_id_seq', 669, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 20, true);


--
-- Name: weight_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weight_categories_id_seq', 65, true);


--
-- Name: _migrations _migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._migrations
    ADD CONSTRAINT _migrations_pkey PRIMARY KEY (name);


--
-- Name: athlete_comments athlete_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athlete_comments
    ADD CONSTRAINT athlete_comments_pkey PRIMARY KEY (id);


--
-- Name: athletes athletes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_pkey PRIMARY KEY (id);


--
-- Name: attempts attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: cache cache_url_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_url_key UNIQUE (url);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: competition_types competition_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competition_types
    ADD CONSTRAINT competition_types_pkey PRIMARY KEY (id);


--
-- Name: competitions competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competitions_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: disqualifications disqualifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disqualifications
    ADD CONSTRAINT disqualifications_pkey PRIMARY KEY (id);


--
-- Name: email_approvals email_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_approvals
    ADD CONSTRAINT email_approvals_pkey PRIMARY KEY (id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: periods periods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: record_types record_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_pkey PRIMARY KEY (id);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (id);


--
-- Name: user_sessions session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: filters short_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filters
    ADD CONSTRAINT short_urls_pkey PRIMARY KEY (id);


--
-- Name: users users_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_pk PRIMARY KEY (id);


--
-- Name: weight_categories weight_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_categories
    ADD CONSTRAINT weight_categories_pkey PRIMARY KEY (id);


--
-- Name: email_approvals_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX email_approvals_id_uindex ON public.email_approvals USING btree (id);


--
-- Name: record_types_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX record_types_id_uindex ON public.record_types USING btree (id);


--
-- Name: records_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX records_id_uindex ON public.records USING btree (id);


--
-- Name: filters trigger_short_urls_genid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_short_urls_genid BEFORE INSERT ON public.filters FOR EACH ROW EXECUTE PROCEDURE public.unique_short_id();


--
-- Name: athlete_comments athlete_comments_athleteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athlete_comments
    ADD CONSTRAINT athlete_comments_athleteid_fkey FOREIGN KEY (athleteid) REFERENCES public.athletes(id);


--
-- Name: athlete_comments athlete_comments_updated_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athlete_comments
    ADD CONSTRAINT athlete_comments_updated_fkey FOREIGN KEY (updated) REFERENCES public.users(id);


--
-- Name: athlete_comments athlete_comments_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athlete_comments
    ADD CONSTRAINT athlete_comments_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: athletes athletes_countries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_countries_id_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: attempt_category attempt_category_attempts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt_category
    ADD CONSTRAINT attempt_category_attempts_id_fk FOREIGN KEY (attempt_id) REFERENCES public.attempts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attempt_category attempt_category_weight_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt_category
    ADD CONSTRAINT attempt_category_weight_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.weight_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attempts attempts_athletes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_athletes_id_fk FOREIGN KEY (athlete_id) REFERENCES public.athletes(id);


--
-- Name: attempts attempts_competitions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_competitions_id_fk FOREIGN KEY (competition_id) REFERENCES public.competitions(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: attempts attempts_countries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_countries_id_fk FOREIGN KEY (athlete_country_id) REFERENCES public.countries(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: attempts attempts_exercises_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_exercises_id_fk FOREIGN KEY (exercise_id) REFERENCES public.exercises(id);


--
-- Name: attempts attempts_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_users_id_fk FOREIGN KEY (added_by) REFERENCES public.users(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: attempts attempts_users_updated_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_users_updated_id_fk FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: comments comments_attemptid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_attemptid_fkey FOREIGN KEY (attemptid) REFERENCES public.attempts(id);


--
-- Name: comments comments_updated_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_updated_fkey FOREIGN KEY (updated) REFERENCES public.users(id);


--
-- Name: comments comments_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: competitions competitions_competition_types_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competitions_competition_types_id_fk FOREIGN KEY (type) REFERENCES public.competition_types(id);


--
-- Name: competitions competitions_places_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competitions_places_id_fk FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- Name: disqualifications disqualifications_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disqualifications
    ADD CONSTRAINT disqualifications_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.attempts(id);


--
-- Name: email_approvals email_approvals_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_approvals
    ADD CONSTRAINT email_approvals_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: places places_countries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_countries_id_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: records records_attempts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_attempts_id_fk FOREIGN KEY (attempt_id) REFERENCES public.attempts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: records records_exercises_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_exercises_id_fk FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: records records_record_types_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_record_types_id_fk FOREIGN KEY (record_type) REFERENCES public.record_types(id);


--
-- Name: records records_weight_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_weight_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.weight_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: weight_categories weight_categories_periods_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_categories
    ADD CONSTRAINT weight_categories_periods_id_fk FOREIGN KEY (period_id) REFERENCES public.periods(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

