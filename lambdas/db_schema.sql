--
-- PostgreSQL database dump
--

-- Dumped from database version 13.8 (Ubuntu 13.8-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.8 (Ubuntu 13.8-1.pgdg20.04+1)

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
-- Name: api_keys; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.api_keys (
    id bigint NOT NULL,
    bearer_id integer NOT NULL,
    bearer_type character varying NOT NULL,
    token_digest character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.api_keys OWNER TO jsuarezb;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO jsuarezb;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO jsuarezb;

--
-- Name: cor_hired_narratives; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.cor_hired_narratives (
    id bigint NOT NULL,
    cor_narrative_id bigint,
    user_id bigint
);


ALTER TABLE public.cor_hired_narratives OWNER TO jsuarezb;

--
-- Name: cor_hired_narratives_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.cor_hired_narratives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cor_hired_narratives_id_seq OWNER TO jsuarezb;

--
-- Name: cor_hired_narratives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.cor_hired_narratives_id_seq OWNED BY public.cor_hired_narratives.id;


--
-- Name: cor_narrative_topics; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.cor_narrative_topics (
    id bigint NOT NULL,
    cor_narrative_id bigint NOT NULL,
    cor_topic_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cor_replica_id bigint
);


ALTER TABLE public.cor_narrative_topics OWNER TO jsuarezb;

--
-- Name: cor_narrative_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.cor_narrative_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cor_narrative_topics_id_seq OWNER TO jsuarezb;

--
-- Name: cor_narrative_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.cor_narrative_topics_id_seq OWNED BY public.cor_narrative_topics.id;


--
-- Name: cor_narratives; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.cor_narratives (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying,
    label character varying
);


ALTER TABLE public.cor_narratives OWNER TO jsuarezb;

--
-- Name: cor_narratives_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.cor_narratives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cor_narratives_id_seq OWNER TO jsuarezb;

--
-- Name: cor_narratives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.cor_narratives_id_seq OWNED BY public.cor_narratives.id;


--
-- Name: cor_replicas; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.cor_replicas (
    id bigint NOT NULL,
    cor_narrative_id bigint NOT NULL,
    mercatus_asset_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.cor_replicas OWNER TO jsuarezb;

--
-- Name: cor_replicas_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.cor_replicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cor_replicas_id_seq OWNER TO jsuarezb;

--
-- Name: cor_replicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.cor_replicas_id_seq OWNED BY public.cor_replicas.id;


--
-- Name: cor_topics; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.cor_topics (
    id bigint NOT NULL,
    search_key character varying NOT NULL,
    download_tones boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.cor_topics OWNER TO jsuarezb;

--
-- Name: cor_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.cor_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cor_topics_id_seq OWNER TO jsuarezb;

--
-- Name: cor_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.cor_topics_id_seq OWNED BY public.cor_topics.id;


--
-- Name: mercatus_assets; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.mercatus_assets (
    id bigint NOT NULL,
    display_name character varying NOT NULL,
    index boolean DEFAULT false NOT NULL,
    scrape_prices boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    isin character varying,
    yahoo_ticker character varying
);


ALTER TABLE public.mercatus_assets OWNER TO jsuarezb;

--
-- Name: mercatus_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.mercatus_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercatus_assets_id_seq OWNER TO jsuarezb;

--
-- Name: mercatus_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.mercatus_assets_id_seq OWNED BY public.mercatus_assets.id;


--
-- Name: mercatus_index_components; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.mercatus_index_components (
    id bigint NOT NULL,
    index_id bigint,
    component_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.mercatus_index_components OWNER TO jsuarezb;

--
-- Name: mercatus_index_components_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.mercatus_index_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercatus_index_components_id_seq OWNER TO jsuarezb;

--
-- Name: mercatus_index_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.mercatus_index_components_id_seq OWNED BY public.mercatus_index_components.id;


--
-- Name: oraculum_forecast_measures; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.oraculum_forecast_measures (
    id bigint NOT NULL,
    oraculum_forecast_id bigint NOT NULL,
    forecasted_for timestamp without time zone,
    value numeric(16,4),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cor_replica_id bigint,
    lower_bound numeric(16,4),
    upper_bound numeric(16,4)
);


ALTER TABLE public.oraculum_forecast_measures OWNER TO jsuarezb;

--
-- Name: oraculum_forecast_measures_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.oraculum_forecast_measures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oraculum_forecast_measures_id_seq OWNER TO jsuarezb;

--
-- Name: oraculum_forecast_measures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.oraculum_forecast_measures_id_seq OWNED BY public.oraculum_forecast_measures.id;


--
-- Name: oraculum_forecasts; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.oraculum_forecasts (
    id bigint NOT NULL,
    forecasted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    scientia_variable_id bigint NOT NULL,
    cor_narrative_id bigint
);


ALTER TABLE public.oraculum_forecasts OWNER TO jsuarezb;

--
-- Name: oraculum_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.oraculum_forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oraculum_forecasts_id_seq OWNER TO jsuarezb;

--
-- Name: oraculum_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.oraculum_forecasts_id_seq OWNED BY public.oraculum_forecasts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO jsuarezb;

--
-- Name: scientia_historical_measures; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.scientia_historical_measures (
    id bigint NOT NULL,
    scientia_variable_id bigint NOT NULL,
    measurable_type character varying NOT NULL,
    measurable_id bigint NOT NULL,
    value numeric(16,4),
    measured_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.scientia_historical_measures OWNER TO jsuarezb;

--
-- Name: scientia_historical_measures_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.scientia_historical_measures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scientia_historical_measures_id_seq OWNER TO jsuarezb;

--
-- Name: scientia_historical_measures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.scientia_historical_measures_id_seq OWNED BY public.scientia_historical_measures.id;


--
-- Name: scientia_variables; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.scientia_variables (
    id bigint NOT NULL,
    display_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.scientia_variables OWNER TO jsuarezb;

--
-- Name: scientia_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.scientia_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scientia_variables_id_seq OWNER TO jsuarezb;

--
-- Name: scientia_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.scientia_variables_id_seq OWNED BY public.scientia_variables.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: jsuarezb
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    allow_password_change boolean DEFAULT false,
    remember_created_at timestamp(6) without time zone,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email character varying,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    name character varying,
    nickname character varying,
    image character varying,
    email character varying,
    tokens json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO jsuarezb;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: jsuarezb
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO jsuarezb;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jsuarezb
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: cor_hired_narratives id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_hired_narratives ALTER COLUMN id SET DEFAULT nextval('public.cor_hired_narratives_id_seq'::regclass);


--
-- Name: cor_narrative_topics id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narrative_topics ALTER COLUMN id SET DEFAULT nextval('public.cor_narrative_topics_id_seq'::regclass);


--
-- Name: cor_narratives id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narratives ALTER COLUMN id SET DEFAULT nextval('public.cor_narratives_id_seq'::regclass);


--
-- Name: cor_replicas id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_replicas ALTER COLUMN id SET DEFAULT nextval('public.cor_replicas_id_seq'::regclass);


--
-- Name: cor_topics id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_topics ALTER COLUMN id SET DEFAULT nextval('public.cor_topics_id_seq'::regclass);


--
-- Name: mercatus_assets id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_assets ALTER COLUMN id SET DEFAULT nextval('public.mercatus_assets_id_seq'::regclass);


--
-- Name: mercatus_index_components id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_index_components ALTER COLUMN id SET DEFAULT nextval('public.mercatus_index_components_id_seq'::regclass);


--
-- Name: oraculum_forecast_measures id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecast_measures ALTER COLUMN id SET DEFAULT nextval('public.oraculum_forecast_measures_id_seq'::regclass);


--
-- Name: oraculum_forecasts id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecasts ALTER COLUMN id SET DEFAULT nextval('public.oraculum_forecasts_id_seq'::regclass);


--
-- Name: scientia_historical_measures id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.scientia_historical_measures ALTER COLUMN id SET DEFAULT nextval('public.scientia_historical_measures_id_seq'::regclass);


--
-- Name: scientia_variables id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.scientia_variables ALTER COLUMN id SET DEFAULT nextval('public.scientia_variables_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cor_hired_narratives cor_hired_narratives_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_hired_narratives
    ADD CONSTRAINT cor_hired_narratives_pkey PRIMARY KEY (id);


--
-- Name: cor_narrative_topics cor_narrative_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narrative_topics
    ADD CONSTRAINT cor_narrative_topics_pkey PRIMARY KEY (id);


--
-- Name: cor_narratives cor_narratives_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narratives
    ADD CONSTRAINT cor_narratives_pkey PRIMARY KEY (id);


--
-- Name: cor_replicas cor_replicas_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_replicas
    ADD CONSTRAINT cor_replicas_pkey PRIMARY KEY (id);


--
-- Name: cor_topics cor_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_topics
    ADD CONSTRAINT cor_topics_pkey PRIMARY KEY (id);


--
-- Name: mercatus_assets mercatus_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_assets
    ADD CONSTRAINT mercatus_assets_pkey PRIMARY KEY (id);


--
-- Name: mercatus_index_components mercatus_index_components_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_index_components
    ADD CONSTRAINT mercatus_index_components_pkey PRIMARY KEY (id);


--
-- Name: oraculum_forecast_measures oraculum_forecast_measures_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecast_measures
    ADD CONSTRAINT oraculum_forecast_measures_pkey PRIMARY KEY (id);


--
-- Name: oraculum_forecasts oraculum_forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecasts
    ADD CONSTRAINT oraculum_forecasts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scientia_historical_measures scientia_historical_measures_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.scientia_historical_measures
    ADD CONSTRAINT scientia_historical_measures_pkey PRIMARY KEY (id);


--
-- Name: scientia_variables scientia_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.scientia_variables
    ADD CONSTRAINT scientia_variables_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_api_keys_on_bearer_id_and_bearer_type; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_api_keys_on_bearer_id_and_bearer_type ON public.api_keys USING btree (bearer_id, bearer_type);


--
-- Name: index_api_keys_on_token_digest; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_api_keys_on_token_digest ON public.api_keys USING btree (token_digest);


--
-- Name: index_cor_hired_narratives_on_cor_narrative_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_hired_narratives_on_cor_narrative_id ON public.cor_hired_narratives USING btree (cor_narrative_id);


--
-- Name: index_cor_hired_narratives_on_user_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_hired_narratives_on_user_id ON public.cor_hired_narratives USING btree (user_id);


--
-- Name: index_cor_narrative_topics_on_cor_narrative_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_narrative_topics_on_cor_narrative_id ON public.cor_narrative_topics USING btree (cor_narrative_id);


--
-- Name: index_cor_narrative_topics_on_cor_replica_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_narrative_topics_on_cor_replica_id ON public.cor_narrative_topics USING btree (cor_replica_id);


--
-- Name: index_cor_narrative_topics_on_cor_topic_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_narrative_topics_on_cor_topic_id ON public.cor_narrative_topics USING btree (cor_topic_id);


--
-- Name: index_cor_replicas_on_cor_narrative_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_replicas_on_cor_narrative_id ON public.cor_replicas USING btree (cor_narrative_id);


--
-- Name: index_cor_replicas_on_mercatus_asset_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_cor_replicas_on_mercatus_asset_id ON public.cor_replicas USING btree (mercatus_asset_id);


--
-- Name: index_cor_topics_on_search_key; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_cor_topics_on_search_key ON public.cor_topics USING btree (search_key);


--
-- Name: index_mercatus_index_components_on_component_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_mercatus_index_components_on_component_id ON public.mercatus_index_components USING btree (component_id);


--
-- Name: index_mercatus_index_components_on_index_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_mercatus_index_components_on_index_id ON public.mercatus_index_components USING btree (index_id);


--
-- Name: index_oraculum_forecast_measures_on_cor_replica_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_oraculum_forecast_measures_on_cor_replica_id ON public.oraculum_forecast_measures USING btree (cor_replica_id);


--
-- Name: index_oraculum_forecast_measures_on_oraculum_forecast_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_oraculum_forecast_measures_on_oraculum_forecast_id ON public.oraculum_forecast_measures USING btree (oraculum_forecast_id);


--
-- Name: index_oraculum_forecasts_on_cor_narrative_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_oraculum_forecasts_on_cor_narrative_id ON public.oraculum_forecasts USING btree (cor_narrative_id);


--
-- Name: index_oraculum_forecasts_on_scientia_variable_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_oraculum_forecasts_on_scientia_variable_id ON public.oraculum_forecasts USING btree (scientia_variable_id);


--
-- Name: index_scientia_historical_measures_on_measurable; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_scientia_historical_measures_on_measurable ON public.scientia_historical_measures USING btree (measured_at, measurable_id, measurable_type);


--
-- Name: index_scientia_historical_measures_on_scientia_variable_id; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE INDEX index_scientia_historical_measures_on_scientia_variable_id ON public.scientia_historical_measures USING btree (scientia_variable_id);


--
-- Name: index_scientia_variables_on_display_name; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_scientia_variables_on_display_name ON public.scientia_variables USING btree (display_name);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: jsuarezb
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);


--
-- Name: cor_narrative_topics fk_rails_298312b551; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narrative_topics
    ADD CONSTRAINT fk_rails_298312b551 FOREIGN KEY (cor_topic_id) REFERENCES public.cor_topics(id);


--
-- Name: oraculum_forecasts fk_rails_3fe287bc99; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecasts
    ADD CONSTRAINT fk_rails_3fe287bc99 FOREIGN KEY (scientia_variable_id) REFERENCES public.scientia_variables(id);


--
-- Name: cor_narrative_topics fk_rails_463f27e5ea; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_narrative_topics
    ADD CONSTRAINT fk_rails_463f27e5ea FOREIGN KEY (cor_narrative_id) REFERENCES public.cor_narratives(id);


--
-- Name: scientia_historical_measures fk_rails_70d1026dc7; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.scientia_historical_measures
    ADD CONSTRAINT fk_rails_70d1026dc7 FOREIGN KEY (scientia_variable_id) REFERENCES public.scientia_variables(id);


--
-- Name: mercatus_index_components fk_rails_7b0442edc8; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_index_components
    ADD CONSTRAINT fk_rails_7b0442edc8 FOREIGN KEY (index_id) REFERENCES public.mercatus_assets(id);


--
-- Name: oraculum_forecast_measures fk_rails_9ddf60c318; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.oraculum_forecast_measures
    ADD CONSTRAINT fk_rails_9ddf60c318 FOREIGN KEY (oraculum_forecast_id) REFERENCES public.oraculum_forecasts(id);


--
-- Name: cor_replicas fk_rails_a161a3a8ee; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_replicas
    ADD CONSTRAINT fk_rails_a161a3a8ee FOREIGN KEY (mercatus_asset_id) REFERENCES public.mercatus_assets(id);


--
-- Name: cor_replicas fk_rails_bea0eefe82; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.cor_replicas
    ADD CONSTRAINT fk_rails_bea0eefe82 FOREIGN KEY (cor_narrative_id) REFERENCES public.cor_narratives(id);


--
-- Name: mercatus_index_components fk_rails_cd61c06555; Type: FK CONSTRAINT; Schema: public; Owner: jsuarezb
--

ALTER TABLE ONLY public.mercatus_index_components
    ADD CONSTRAINT fk_rails_cd61c06555 FOREIGN KEY (component_id) REFERENCES public.mercatus_assets(id);


--
-- PostgreSQL database dump complete
--

