--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: absence_request_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.absence_request_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


--
-- Name: absence_request_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.absence_request_type AS ENUM (
    'TUTOR_LEAVE',
    'STUDENT_LEAVE'
);


--
-- Name: application_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.application_status AS ENUM (
    'PENDING',
    'ACCEPTED',
    'REJECTED',
    'CANCELLED',
    'APPROVED'
);


--
-- Name: assessment_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.assessment_type AS ENUM (
    'EXAM',
    'HOMEWORK'
);


--
-- Name: class_mode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.class_mode AS ENUM (
    'ONLINE',
    'OFFLINE'
);


--
-- Name: class_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.class_status AS ENUM (
    'PENDING_APPROVAL',
    'OPEN',
    'ASSIGNED',
    'MATCHED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED',
    'AUTO_CLOSED'
);


--
-- Name: invoice_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status AS ENUM (
    'PENDING',
    'RECEIPT_UPLOADED',
    'APPROVED',
    'REJECTED'
);


--
-- Name: material_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.material_type AS ENUM (
    'DOCUMENT',
    'VIDEO',
    'IMAGE',
    'LINK',
    'OTHER'
);


--
-- Name: notification_channel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel AS ENUM (
    'IN_APP',
    'FCM'
);


--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_type AS ENUM (
    'CLASS_OPENED',
    'APPLICATION_RECEIVED',
    'APPLICATION_ACCEPTED',
    'APPLICATION_REJECTED',
    'INVOICE_RECEIPT_UPLOADED',
    'INVOICE_APPROVED',
    'INVOICE_REJECTED',
    'SESSION_REMINDER',
    'MEET_LINK_SET',
    'ASSESSMENT_PUBLISHED',
    'SUBMISSION_GRADED',
    'PAYOUT_TRANSFERRED',
    'CLASS_CANCELLED',
    'NEW_MESSAGE'
);


--
-- Name: payout_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payout_status AS ENUM (
    'PENDING',
    'TRANSFERRED',
    'FAILED',
    'LOCKED',
    'PAID_OUT'
);


--
-- Name: question_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.question_type AS ENUM (
    'MCQ',
    'ESSAY'
);


--
-- Name: session_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.session_status AS ENUM (
    'DRAFT',
    'SCHEDULED',
    'LIVE',
    'COMPLETED',
    'CANCELLED',
    'COMPLETED_PENDING',
    'CANCELLED_BY_TUTOR',
    'CANCELLED_BY_STUDENT',
    'DISPUTED'
);


--
-- Name: session_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.session_type AS ENUM (
    'REGULAR',
    'MAKEUP',
    'EXTRA'
);


--
-- Name: submission_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.submission_status AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'GRADED'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'ADMIN',
    'TUTOR',
    'PARENT',
    'STUDENT'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: absence_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.absence_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    requester_id uuid,
    reason text,
    make_up_required boolean DEFAULT true NOT NULL,
    status public.absence_request_status DEFAULT 'PENDING'::public.absence_request_status NOT NULL,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    request_type public.absence_request_type DEFAULT 'STUDENT_LEAVE'::public.absence_request_type NOT NULL,
    proof_url text,
    makeup_date date,
    makeup_time time without time zone
);


--
-- Name: admin_bank_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_bank_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    method_type character varying(20) NOT NULL,
    account_number character varying(50) NOT NULL,
    account_name character varying(150) NOT NULL,
    bank_name character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: assessment_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assessment_id uuid NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    type public.question_type DEFAULT 'MCQ'::public.question_type NOT NULL,
    content text NOT NULL,
    options jsonb DEFAULT '[]'::jsonb NOT NULL,
    max_length integer,
    score numeric(5,2) DEFAULT 1 NOT NULL,
    explanation text
);


--
-- Name: assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    created_by uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    type public.assessment_type DEFAULT 'EXAM'::public.assessment_type NOT NULL,
    opens_at timestamp with time zone NOT NULL,
    closes_at timestamp with time zone,
    duration_min integer,
    total_score numeric(6,2) DEFAULT 100 NOT NULL,
    pass_score numeric(6,2),
    solution_url character varying(500),
    solution_text text,
    is_published boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: billings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billings (
    id uuid NOT NULL,
    class_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    total_sessions integer NOT NULL,
    parent_fee_amount numeric(15,2) NOT NULL,
    tutor_payout_amount numeric(15,2) NOT NULL,
    transaction_code character varying(50) NOT NULL,
    status character varying(50) NOT NULL,
    verified_by_admin_id uuid,
    verified_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by character varying(255),
    updated_by character varying(255)
);


--
-- Name: class_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_applications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    tutor_id uuid NOT NULL,
    status public.application_status DEFAULT 'PENDING'::public.application_status NOT NULL,
    note text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: class_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    parent_id uuid NOT NULL,
    subject character varying(100) NOT NULL,
    grade character varying(50) NOT NULL,
    mode public.class_mode NOT NULL,
    address character varying(500),
    preferred_schedule jsonb DEFAULT '[]'::jsonb NOT NULL,
    expected_fee numeric(12,2),
    note text,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    class_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    time_frame character varying(100)
);


--
-- Name: class_students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_students (
    class_id uuid NOT NULL,
    student_id uuid NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    admin_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    tutor_id uuid,
    title character varying(255) NOT NULL,
    subject character varying(100) NOT NULL,
    grade character varying(50) NOT NULL,
    description text,
    mode public.class_mode NOT NULL,
    address character varying(500),
    schedule jsonb DEFAULT '[]'::jsonb NOT NULL,
    sessions_per_week integer DEFAULT 1 NOT NULL,
    session_duration_min integer DEFAULT 90 NOT NULL,
    parent_fee numeric(12,2) NOT NULL,
    platform_fee numeric(12,2) DEFAULT 0 NOT NULL,
    status public.class_status DEFAULT 'OPEN'::public.class_status NOT NULL,
    start_date date,
    end_date date,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    time_frame character varying(100),
    class_code character varying(6) NOT NULL,
    fee_percentage integer DEFAULT 30 NOT NULL,
    gender_requirement character varying(50) DEFAULT 'Không yêu cầu'::character varying NOT NULL,
    tutor_fee numeric(12,2),
    level_fees jsonb DEFAULT '[]'::jsonb,
    tutor_proposals jsonb DEFAULT '{}'::jsonb NOT NULL,
    rejection_reason text,
    learning_start_date date,
    meet_link character varying(500),
    is_mock boolean DEFAULT false
);


--
-- Name: conversation_backups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_backups (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    user_role character varying(20) NOT NULL,
    last_message_preview character varying(255),
    last_message_at timestamp without time zone,
    last_message_sender_name character varying(100),
    unread_count_admin integer DEFAULT 0,
    unread_count_user integer DEFAULT 0,
    is_closed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    archived_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    user_role character varying(20) NOT NULL,
    last_message_preview character varying(255),
    last_message_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    unread_count_admin integer DEFAULT 0,
    unread_count_user integer DEFAULT 0,
    is_closed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_message_sender_name character varying(255)
);


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    tutor_id uuid NOT NULL,
    rating smallint NOT NULL,
    comment text,
    is_visible boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feedbacks_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    admin_bank_id uuid,
    amount numeric(12,2) NOT NULL,
    period_label character varying(100),
    receipt_url character varying(500),
    receipt_uploaded_at timestamp with time zone,
    status public.invoice_status DEFAULT 'PENDING'::public.invoice_status NOT NULL,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    reject_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.materials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    uploaded_by uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    type public.material_type DEFAULT 'DOCUMENT'::public.material_type NOT NULL,
    file_url character varying(500),
    file_size bigint,
    external_url character varying(500),
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_file_size CHECK (((file_size IS NULL) OR (file_size <= 52428800))),
    CONSTRAINT chk_material_source CHECK (((file_url IS NOT NULL) OR (external_url IS NOT NULL)))
);


--
-- Name: message_backups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_backups (
    id uuid NOT NULL,
    conversation_id uuid NOT NULL,
    sender_id uuid NOT NULL,
    content text NOT NULL,
    message_type character varying(20) DEFAULT 'TEXT'::character varying,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone,
    archived_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    sender_id uuid NOT NULL,
    content text NOT NULL,
    message_type character varying(20) DEFAULT 'TEXT'::character varying,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: notification_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token character varying(500) NOT NULL,
    device_type character varying(20) DEFAULT 'ANDROID'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    recipient_id uuid NOT NULL,
    type public.notification_type NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    entity_type character varying(50),
    entity_id uuid,
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: parent_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parent_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    address character varying(500),
    note text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tutor_id uuid NOT NULL,
    method_type character varying(20) NOT NULL,
    account_number character varying(50) NOT NULL,
    account_name character varying(150) NOT NULL,
    bank_name character varying(100),
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: platform_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    config_key character varying(100) NOT NULL,
    config_value character varying(500) NOT NULL,
    description character varying(255),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provinces (
    code character varying(10) NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash character varying(255) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: session_attendances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_attendances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    student_id uuid NOT NULL,
    is_present boolean DEFAULT false NOT NULL,
    note text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    session_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    meet_link character varying(500),
    meet_link_set_at timestamp with time zone,
    status public.session_status DEFAULT 'SCHEDULED'::public.session_status NOT NULL,
    tutor_note text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    requires_makeup boolean DEFAULT false NOT NULL,
    session_type public.session_type DEFAULT 'REGULAR'::public.session_type NOT NULL,
    makeup_for_session_id uuid
);


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    grade character varying(50),
    school character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    link_status character varying(20) DEFAULT 'ACCEPTED'::character varying NOT NULL,
    initiated_by character varying(20) DEFAULT 'PARENT'::character varying NOT NULL
);


--
-- Name: submission_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    submission_id uuid NOT NULL,
    question_id uuid NOT NULL,
    answer_mcq character varying(10),
    answer_essay text,
    is_correct boolean,
    score_awarded numeric(5,2),
    tutor_feedback text
);


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assessment_id uuid NOT NULL,
    student_id uuid NOT NULL,
    status public.submission_status DEFAULT 'DRAFT'::public.submission_status NOT NULL,
    total_score numeric(6,2),
    tutor_comment text,
    submitted_at timestamp with time zone,
    graded_at timestamp with time zone,
    graded_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    description character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: tutor_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tutor_applications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid NOT NULL,
    tutor_id uuid NOT NULL,
    cover_note text,
    status public.application_status DEFAULT 'PENDING'::public.application_status NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: tutor_payouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tutor_payouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id uuid,
    tutor_id uuid NOT NULL,
    payment_method_id uuid,
    gross_amount numeric(12,2),
    platform_fee numeric(12,2) DEFAULT 0 NOT NULL,
    net_amount numeric(12,2),
    period_label character varying(100),
    transfer_note text,
    status public.payout_status DEFAULT 'PENDING'::public.payout_status NOT NULL,
    paid_by uuid,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    transaction_code character varying(50),
    billing_id uuid,
    admin_note text,
    confirmed_by_tutor_at timestamp with time zone
);


--
-- Name: tutor_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tutor_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    bio text,
    subjects text[] DEFAULT '{}'::text[] NOT NULL,
    location character varying(255),
    teaching_mode character varying(20) DEFAULT 'BOTH'::character varying NOT NULL,
    hourly_rate numeric(12,2),
    rating numeric(3,2) DEFAULT 5.00 NOT NULL,
    rating_count integer DEFAULT 1 NOT NULL,
    cert_base64s text[] DEFAULT '{}'::text[] NOT NULL,
    verification_status character varying(20) DEFAULT 'UNVERIFIED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    tutor_type character varying(50),
    id_card_number character varying(20),
    teaching_levels text[] DEFAULT '{}'::text[],
    date_of_birth date,
    achievements text,
    experience_years integer DEFAULT 0,
    bank_name character varying(100),
    bank_account_number character varying(50),
    bank_owner_name character varying(150),
    is_mock boolean DEFAULT false
);


--
-- Name: user_devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    fcm_token character varying(255) NOT NULL,
    device_name character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone character varying(20),
    password_hash character varying(255) NOT NULL,
    full_name character varying(150) NOT NULL,
    avatar_base64 text,
    role public.user_role NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    failed_attempts integer DEFAULT 0 NOT NULL,
    locked_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    email character varying(255),
    username character varying(50),
    address character varying(500),
    school character varying(255),
    grade character varying(50),
    is_mock boolean DEFAULT false
);


--
-- Name: wards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wards (
    code character varying(10) NOT NULL,
    name character varying(255) NOT NULL,
    province_code character varying(10) NOT NULL
);


--
-- Name: absence_requests absence_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.absence_requests
    ADD CONSTRAINT absence_requests_pkey PRIMARY KEY (id);


--
-- Name: absence_requests absence_requests_session_requester_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.absence_requests
    ADD CONSTRAINT absence_requests_session_requester_unique UNIQUE (session_id, requester_id);


--
-- Name: admin_bank_accounts admin_bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_bank_accounts
    ADD CONSTRAINT admin_bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: assessment_questions assessment_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_pkey PRIMARY KEY (id);


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: billings billings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billings
    ADD CONSTRAINT billings_pkey PRIMARY KEY (id);


--
-- Name: class_applications class_applications_class_id_tutor_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_applications
    ADD CONSTRAINT class_applications_class_id_tutor_id_key UNIQUE (class_id, tutor_id);


--
-- Name: class_applications class_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_applications
    ADD CONSTRAINT class_applications_pkey PRIMARY KEY (id);


--
-- Name: class_requests class_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_requests
    ADD CONSTRAINT class_requests_pkey PRIMARY KEY (id);


--
-- Name: class_students class_students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_students
    ADD CONSTRAINT class_students_pkey PRIMARY KEY (class_id, student_id);


--
-- Name: classes classes_class_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_class_code_key UNIQUE (class_code);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: conversation_backups conversation_backups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_backups
    ADD CONSTRAINT conversation_backups_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_class_id_parent_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_class_id_parent_id_key UNIQUE (class_id, parent_id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: message_backups message_backups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_backups
    ADD CONSTRAINT message_backups_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notification_tokens notification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_tokens
    ADD CONSTRAINT notification_tokens_pkey PRIMARY KEY (id);


--
-- Name: notification_tokens notification_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_tokens
    ADD CONSTRAINT notification_tokens_token_key UNIQUE (token);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: parent_profiles parent_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_profiles
    ADD CONSTRAINT parent_profiles_pkey PRIMARY KEY (id);


--
-- Name: parent_profiles parent_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_profiles
    ADD CONSTRAINT parent_profiles_user_id_key UNIQUE (user_id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: platform_configs platform_configs_config_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_configs
    ADD CONSTRAINT platform_configs_config_key_key UNIQUE (config_key);


--
-- Name: platform_configs platform_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_configs
    ADD CONSTRAINT platform_configs_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (code);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: session_attendances session_attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_attendances
    ADD CONSTRAINT session_attendances_pkey PRIMARY KEY (id);


--
-- Name: session_attendances session_attendances_session_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_attendances
    ADD CONSTRAINT session_attendances_session_id_student_id_key UNIQUE (session_id, student_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: submission_answers submission_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_answers
    ADD CONSTRAINT submission_answers_pkey PRIMARY KEY (id);


--
-- Name: submission_answers submission_answers_submission_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_answers
    ADD CONSTRAINT submission_answers_submission_id_question_id_key UNIQUE (submission_id, question_id);


--
-- Name: submissions submissions_assessment_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_assessment_id_student_id_key UNIQUE (assessment_id, student_id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_key_key UNIQUE (key);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: tutor_applications tutor_applications_class_id_tutor_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_applications
    ADD CONSTRAINT tutor_applications_class_id_tutor_id_key UNIQUE (class_id, tutor_id);


--
-- Name: tutor_applications tutor_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_applications
    ADD CONSTRAINT tutor_applications_pkey PRIMARY KEY (id);


--
-- Name: tutor_payouts tutor_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT tutor_payouts_pkey PRIMARY KEY (id);


--
-- Name: tutor_profiles tutor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_profiles
    ADD CONSTRAINT tutor_profiles_pkey PRIMARY KEY (id);


--
-- Name: tutor_profiles tutor_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_profiles
    ADD CONSTRAINT tutor_profiles_user_id_key UNIQUE (user_id);


--
-- Name: conversations uk_conversation_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT uk_conversation_user UNIQUE (user_id);


--
-- Name: user_devices user_devices_fcm_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_fcm_token_key UNIQUE (fcm_token);


--
-- Name: user_devices user_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wards wards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_pkey PRIMARY KEY (code);


--
-- Name: idx_absence_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_absence_session ON public.absence_requests USING btree (session_id);


--
-- Name: idx_absence_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_absence_status ON public.absence_requests USING btree (status);


--
-- Name: idx_absence_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_absence_student ON public.absence_requests USING btree (requester_id, status);


--
-- Name: idx_applications_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_applications_class ON public.tutor_applications USING btree (class_id, status);


--
-- Name: idx_applications_tutor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_applications_tutor ON public.tutor_applications USING btree (tutor_id, status);


--
-- Name: idx_assessments_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessments_class ON public.assessments USING btree (class_id, opens_at DESC) WHERE (is_deleted = false);


--
-- Name: idx_attendance_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attendance_session ON public.session_attendances USING btree (session_id);


--
-- Name: idx_attendance_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attendance_student ON public.session_attendances USING btree (student_id);


--
-- Name: idx_billings_parent_month_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_billings_parent_month_year ON public.billings USING btree (parent_id, month, year);


--
-- Name: idx_billings_tx_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_billings_tx_code ON public.billings USING btree (transaction_code);


--
-- Name: idx_bookings_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_parent ON public.invoices USING btree (parent_id, status);


--
-- Name: idx_class_applications_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_class_applications_class_id ON public.class_applications USING btree (class_id);


--
-- Name: idx_class_applications_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_class_applications_status ON public.class_applications USING btree (status);


--
-- Name: idx_class_applications_tutor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_class_applications_tutor_id ON public.class_applications USING btree (tutor_id);


--
-- Name: idx_class_students_st; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_class_students_st ON public.class_students USING btree (student_id);


--
-- Name: idx_classes_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_classes_parent ON public.classes USING btree (parent_id);


--
-- Name: idx_classes_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_classes_status ON public.classes USING btree (status) WHERE (is_deleted = false);


--
-- Name: idx_classes_tutor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_classes_tutor ON public.classes USING btree (tutor_id);


--
-- Name: idx_conversations_last_msg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversations_last_msg ON public.conversations USING btree (last_message_at DESC);


--
-- Name: idx_conversations_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversations_user ON public.conversations USING btree (user_id);


--
-- Name: idx_feedback_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_parent ON public.feedbacks USING btree (parent_id);


--
-- Name: idx_feedback_tutor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_tutor ON public.feedbacks USING btree (tutor_id);


--
-- Name: idx_invoices_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invoices_class ON public.invoices USING btree (class_id);


--
-- Name: idx_invoices_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invoices_parent ON public.invoices USING btree (parent_id, status);


--
-- Name: idx_materials_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_materials_class ON public.materials USING btree (class_id, created_at DESC) WHERE (is_deleted = false);


--
-- Name: idx_messages_conv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_conv ON public.messages USING btree (conversation_id);


--
-- Name: idx_messages_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_created ON public.messages USING btree (created_at);


--
-- Name: idx_messages_room; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_room ON public.notifications USING btree (recipient_id, created_at DESC);


--
-- Name: idx_notif_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_entity ON public.notifications USING btree (entity_type, entity_id);


--
-- Name: idx_notif_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_recipient ON public.notifications USING btree (recipient_id, is_read, created_at DESC);


--
-- Name: idx_notif_tokens_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_tokens_user ON public.notification_tokens USING btree (user_id);


--
-- Name: idx_payment_tutor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_tutor ON public.payment_methods USING btree (tutor_id);


--
-- Name: idx_payouts_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payouts_class ON public.tutor_payouts USING btree (class_id);


--
-- Name: idx_payouts_tutor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payouts_tutor ON public.tutor_payouts USING btree (tutor_id, status);


--
-- Name: idx_questions_assessment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_assessment ON public.assessment_questions USING btree (assessment_id, order_index);


--
-- Name: idx_refresh_token_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_token_user ON public.refresh_tokens USING btree (user_id);


--
-- Name: idx_requests_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requests_parent ON public.class_requests USING btree (parent_id, status);


--
-- Name: idx_sessions_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_class ON public.sessions USING btree (class_id, session_date);


--
-- Name: idx_sessions_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_date ON public.sessions USING btree (session_date, status);


--
-- Name: idx_students_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_students_parent ON public.student_profiles USING btree (parent_id);


--
-- Name: idx_sub_answers_submission; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_answers_submission ON public.submission_answers USING btree (submission_id);


--
-- Name: idx_submissions_assessment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_assessment ON public.submissions USING btree (assessment_id, status);


--
-- Name: idx_submissions_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_student ON public.submissions USING btree (student_id, status);


--
-- Name: idx_tutor_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_fts ON public.tutor_profiles USING gin (to_tsvector('simple'::regconfig, ((COALESCE(bio, ''::text) || ' '::text) || (COALESCE(location, ''::character varying))::text)));


--
-- Name: idx_tutor_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_location ON public.tutor_profiles USING btree (location);


--
-- Name: idx_tutor_payouts_tutor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_payouts_tutor_id ON public.tutor_payouts USING btree (tutor_id);


--
-- Name: idx_tutor_rate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_rate ON public.tutor_profiles USING btree (hourly_rate);


--
-- Name: idx_tutor_rating; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_rating ON public.tutor_profiles USING btree (rating DESC) WHERE ((verification_status)::text = 'APPROVED'::text);


--
-- Name: idx_tutor_subjects; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tutor_subjects ON public.tutor_profiles USING gin (subjects);


--
-- Name: idx_user_devices_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_devices_user ON public.user_devices USING btree (user_id);


--
-- Name: idx_wards_province_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wards_province_code ON public.wards USING btree (province_code);


--
-- Name: uk_users_active_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_users_active_phone ON public.users USING btree (phone) WHERE ((is_deleted = false) AND (phone IS NOT NULL));


--
-- Name: uk_users_active_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_users_active_username ON public.users USING btree (username) WHERE ((is_deleted = false) AND (username IS NOT NULL));


--
-- Name: absence_requests absence_requests_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.absence_requests
    ADD CONSTRAINT absence_requests_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: absence_requests absence_requests_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.absence_requests
    ADD CONSTRAINT absence_requests_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: absence_requests absence_requests_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.absence_requests
    ADD CONSTRAINT absence_requests_student_id_fkey FOREIGN KEY (requester_id) REFERENCES public.users(id);


--
-- Name: assessment_questions assessment_questions_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.assessments(id) ON DELETE CASCADE;


--
-- Name: assessments assessments_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: assessments assessments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: billings billings_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billings
    ADD CONSTRAINT billings_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: billings billings_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billings
    ADD CONSTRAINT billings_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: billings billings_verified_by_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billings
    ADD CONSTRAINT billings_verified_by_admin_id_fkey FOREIGN KEY (verified_by_admin_id) REFERENCES public.users(id);


--
-- Name: class_applications class_applications_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_applications
    ADD CONSTRAINT class_applications_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_applications class_applications_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_applications
    ADD CONSTRAINT class_applications_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: class_requests class_requests_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_requests
    ADD CONSTRAINT class_requests_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_requests class_requests_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_requests
    ADD CONSTRAINT class_requests_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: class_students class_students_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_students
    ADD CONSTRAINT class_students_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_students class_students_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_students
    ADD CONSTRAINT class_students_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: classes classes_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- Name: classes classes_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: classes classes_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id);


--
-- Name: conversations conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: feedbacks feedbacks_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: feedbacks feedbacks_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: feedbacks feedbacks_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id);


--
-- Name: tutor_payouts fk_tutor_payouts_billing_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT fk_tutor_payouts_billing_id FOREIGN KEY (billing_id) REFERENCES public.billings(id);


--
-- Name: invoices invoices_admin_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_admin_bank_id_fkey FOREIGN KEY (admin_bank_id) REFERENCES public.admin_bank_accounts(id);


--
-- Name: invoices invoices_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: invoices invoices_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: invoices invoices_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: materials materials_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: materials materials_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: notification_tokens notification_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_tokens
    ADD CONSTRAINT notification_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: parent_profiles parent_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_profiles
    ADD CONSTRAINT parent_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payment_methods payment_methods_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: platform_configs platform_configs_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_configs
    ADD CONSTRAINT platform_configs_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: session_attendances session_attendances_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_attendances
    ADD CONSTRAINT session_attendances_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: session_attendances session_attendances_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_attendances
    ADD CONSTRAINT session_attendances_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: sessions sessions_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: student_profiles student_profiles_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: student_profiles student_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: submission_answers submission_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_answers
    ADD CONSTRAINT submission_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.assessment_questions(id) ON DELETE CASCADE;


--
-- Name: submission_answers submission_answers_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_answers
    ADD CONSTRAINT submission_answers_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.submissions(id) ON DELETE CASCADE;


--
-- Name: submissions submissions_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.assessments(id) ON DELETE CASCADE;


--
-- Name: submissions submissions_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.users(id);


--
-- Name: submissions submissions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: tutor_applications tutor_applications_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_applications
    ADD CONSTRAINT tutor_applications_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: tutor_applications tutor_applications_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_applications
    ADD CONSTRAINT tutor_applications_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: tutor_payouts tutor_payouts_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT tutor_payouts_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: tutor_payouts tutor_payouts_paid_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT tutor_payouts_paid_by_fkey FOREIGN KEY (paid_by) REFERENCES public.users(id);


--
-- Name: tutor_payouts tutor_payouts_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT tutor_payouts_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: tutor_payouts tutor_payouts_tutor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_payouts
    ADD CONSTRAINT tutor_payouts_tutor_id_fkey FOREIGN KEY (tutor_id) REFERENCES public.users(id);


--
-- Name: tutor_profiles tutor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tutor_profiles
    ADD CONSTRAINT tutor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_devices user_devices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: wards wards_province_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_province_code_fkey FOREIGN KEY (province_code) REFERENCES public.provinces(code) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

