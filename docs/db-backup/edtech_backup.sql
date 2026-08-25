--
-- PostgreSQL database dump
--

\restrict B2nqKEo6rpzLwqLmRbrkDrHOVjuhYMUx2l1rtjAo4cahuxGgQNyQYcfthri1tLu

-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)

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
-- Name: ai_message_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ai_message_role AS ENUM (
    'USER',
    'ASSISTANT'
);


--
-- Name: ai_subscription_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ai_subscription_status AS ENUM (
    'TRIAL',
    'ACTIVE',
    'EXPIRED',
    'CANCELLED'
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
    'AUTO_CLOSED',
    'SUSPENDED'
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
    'NEW_MESSAGE',
    'CLASS_SUSPENDED',
    'CLASS_RESUMED',
    'CLASS_SUSPEND_REMINDER',
    'ABSENCE_REQUESTED',
    'ABSENCE_APPROVED',
    'ABSENCE_REJECTED',
    'SCHEDULE_UPDATED',
    'SCHEDULE_CONFIRMED',
    'CONTACT_MESSAGE_RECEIVED',
    'MATERIAL_UPLOADED',
    'HOMEWORK_ASSIGNED',
    'HOMEWORK_DEADLINE_REMINDER',
    'HOMEWORK_SUBMITTED',
    'TEST_SCHEDULED',
    'SESSION_NOTE_UPDATED',
    'AI_TRIAL_EXPIRING',
    'AI_TRIAL_EXPIRED',
    'AI_SUBSCRIPTION_RENEWED'
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
    'GRADED',
    'REVIEWING',
    'COMPLETED',
    'ARCHIVED'
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
-- Name: ai_conversation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_conversation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    title character varying(200),
    subject character varying(100),
    grade character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    learning_goal character varying(500)
);


--
-- Name: ai_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_message (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    role public.ai_message_role NOT NULL,
    content text NOT NULL,
    image_url character varying(500),
    tokens_used integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: ai_subscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_subscription (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    status public.ai_subscription_status DEFAULT 'TRIAL'::public.ai_subscription_status NOT NULL,
    trial_started_at timestamp with time zone,
    trial_ends_at timestamp with time zone,
    paid_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: ai_usage_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_usage_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    log_date date NOT NULL,
    message_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    attachment_url character varying(500),
    attachment_name character varying(255)
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
    is_mock boolean DEFAULT false,
    suspended_at timestamp with time zone,
    suspend_reason text,
    suspend_start_date date,
    suspend_end_date date
);


--
-- Name: consultation_leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consultation_leads (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(50) NOT NULL,
    is_contacted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_messages (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
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
    file_name character varying(255),
    mime_type character varying(100),
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    file_url character varying(500),
    file_name character varying(255),
    file_size bigint,
    tutor_file_url character varying(500),
    tutor_file_name character varying(255),
    completed_at timestamp with time zone,
    last_interaction_at timestamp with time zone DEFAULT now(),
    files_cleaned boolean DEFAULT false,
    student_attachments jsonb DEFAULT '[]'::jsonb,
    tutor_attachments jsonb DEFAULT '[]'::jsonb
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
-- Name: user_linked_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_linked_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    provider character varying(20) NOT NULL,
    provider_user_id character varying(255),
    provider_email character varying(255),
    linked_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


--
-- Name: user_push_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_push_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token character varying(512) NOT NULL,
    device_type character varying(20) DEFAULT 'WEB'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone character varying(20),
    password_hash character varying(255),
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
    is_mock boolean DEFAULT false,
    must_change_password boolean DEFAULT false NOT NULL,
    auth_provider character varying(20) DEFAULT 'PHONE'::character varying NOT NULL
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
-- Data for Name: absence_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.absence_requests (id, session_id, requester_id, reason, make_up_required, status, reviewed_by, reviewed_at, created_at, updated_at, request_type, proof_url, makeup_date, makeup_time) FROM stdin;
\.


--
-- Data for Name: admin_bank_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_bank_accounts (id, method_type, account_number, account_name, bank_name, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: ai_conversation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_conversation (id, student_id, title, subject, grade, created_at, updated_at, learning_goal) FROM stdin;
\.


--
-- Data for Name: ai_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_message (id, conversation_id, role, content, image_url, tokens_used, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ai_subscription; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_subscription (id, student_id, status, trial_started_at, trial_ends_at, paid_until, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ai_usage_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_usage_log (id, student_id, log_date, message_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assessment_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_questions (id, assessment_id, order_index, type, content, options, max_length, score, explanation) FROM stdin;
\.


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessments (id, class_id, created_by, title, description, type, opens_at, closes_at, duration_min, total_score, pass_score, solution_url, solution_text, is_published, is_deleted, created_at, updated_at, attachment_url, attachment_name) FROM stdin;
\.


--
-- Data for Name: billings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.billings (id, class_id, parent_id, month, year, total_sessions, parent_fee_amount, tutor_payout_amount, transaction_code, status, verified_by_admin_id, verified_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: class_applications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_applications (id, class_id, tutor_id, status, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: class_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_requests (id, parent_id, subject, grade, mode, address, preferred_schedule, expected_fee, note, status, class_id, created_at, time_frame) FROM stdin;
\.


--
-- Data for Name: class_students; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_students (class_id, student_id, joined_at) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.classes (id, admin_id, parent_id, tutor_id, title, subject, grade, description, mode, address, schedule, sessions_per_week, session_duration_min, parent_fee, platform_fee, status, start_date, end_date, is_deleted, created_at, updated_at, time_frame, class_code, fee_percentage, gender_requirement, tutor_fee, level_fees, tutor_proposals, rejection_reason, learning_start_date, meet_link, is_mock, suspended_at, suspend_reason, suspend_start_date, suspend_end_date) FROM stdin;
8d584e8c-b3da-47d6-a11a-c69e753f3e7d	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Cần gia sư luyện thi cấp tốc IELTS 6.5	IELTS	Người đi làm	Học viên đã có nền tảng, cần mock test	ONLINE	Online	[]	3	90	2800000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK001	30	Không yêu cầu	\N	[{"fee": 2800000, "level": "Sinh viên"}, {"fee": 3000000, "level": "Tốt nghiệp"}, {"fee": 3200000, "level": "Giáo viên"}]	[{"fee": 1800000, "level": "Sinh viên"}, {"fee": 2200000, "level": "Tốt nghiệp"}, {"fee": 2800000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
8185662a-b675-4ea1-a32b-9d0a912cd1cb	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Tìm gia sư kèm Toán 12	Toán	Lớp 12	HS mất gốc toán hình, cần cải thiện ngay	OFFLINE	Quận 10, Hồ Chí Minh	[]	2	120	2000000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK002	30	Không yêu cầu	\N	[{"fee": 2000000, "level": "Sinh viên"}, {"fee": 2200000, "level": "Tốt nghiệp"}, {"fee": 2500000, "level": "Giáo viên"}]	[{"fee": 1400000, "level": "Sinh viên"}, {"fee": 1750000, "level": "Tốt nghiệp"}, {"fee": 2200000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
bcf61ba4-3ca1-437c-9395-454b6f29dee7	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Dạy rèn chữ đẹp & Toán Tiếng Việt Lớp 1	Tiếng Việt	Lớp 1	Bé mới vào lớp 1, cần người kiên nhẫn	OFFLINE	Cầu Giấy, Hà Nội	[]	4	60	2200000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK003	30	Nữ	\N	[{"fee": 2200000, "level": "Sinh viên"}, {"fee": 2500000, "level": "Tốt nghiệp"}, {"fee": 2800000, "level": "Giáo viên"}]	[{"fee": 1500000, "level": "Sinh viên"}, {"fee": 1960000, "level": "Tốt nghiệp"}, {"fee": 2400000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
b52f8f69-e404-41fd-9fcc-ba1b6bef5d3a	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Gia sư Ngữ Văn 9 luyện thi vào 10	Ngữ Văn	Lớp 9	Cần rèn kỹ năng viết nghị luận xã hội	ONLINE	Online	[]	2	90	1500000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK004	30	Không yêu cầu	\N	[{"fee": 1500000, "level": "Sinh viên"}, {"fee": 1800000, "level": "Tốt nghiệp"}, {"fee": 2000000, "level": "Giáo viên"}]	[{"fee": 1000000, "level": "Sinh viên"}, {"fee": 1400000, "level": "Tốt nghiệp"}, {"fee": 1800000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
43aada87-3764-408f-b54c-ab065bc7dcfc	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Dạy giao tiếp Tiếng Anh từ con số 0	Tiếng Anh	Người đi làm	Nhân viên văn phòng cần T.A giao tiếp	OFFLINE	Quận 3, Hồ Chí Minh	[]	3	90	2800000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK005	30	Không yêu cầu	\N	[{"fee": 2800000, "level": "Sinh viên"}, {"fee": 3000000, "level": "Tốt nghiệp"}, {"fee": 3500000, "level": "Giáo viên"}]	[{"fee": 2000000, "level": "Sinh viên"}, {"fee": 2450000, "level": "Tốt nghiệp"}, {"fee": 3100000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
7650fb31-6494-488f-b292-8113c34d5a32	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Cần Sinh viên Y Dược kèm Sinh học cấp 3	Sinh học	Lớp 11	Định hướng thi khối B, cần củng cố kiến thức	OFFLINE	Thanh Xuân, Hà Nội	[]	2	120	1200000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK006	30	Không yêu cầu	\N	[{"fee": 1200000, "level": "Sinh viên"}, {"fee": 1500000, "level": "Tốt nghiệp"}, {"fee": 1800000, "level": "Giáo viên"}]	[{"fee": 900000, "level": "Sinh viên"}, {"fee": 1260000, "level": "Tốt nghiệp"}, {"fee": 1600000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
50ccfc6b-bde6-4307-bd56-e1808a77e0ec	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Dạy lập trình cơ bản Scratch cho trẻ	Tin Học	Lớp 5	Dạy lập trình kéo thả tư duy	ONLINE	Online	[]	1	90	1000000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK007	30	Không yêu cầu	\N	[{"fee": 1000000, "level": "Sinh viên"}, {"fee": 1200000, "level": "Tốt nghiệp"}, {"fee": 1500000, "level": "Giáo viên"}]	[{"fee": 750000, "level": "Sinh viên"}, {"fee": 1050000, "level": "Tốt nghiệp"}, {"fee": 1350000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
ad94b61b-6c77-4d68-a8e8-a832afe82503	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Kèm báo bài Toán Lý Hóa 8	Lý-Hóa	Lớp 8	Kèm combo 3 môn KHTN, HS học trung bình	OFFLINE	Hải Châu, Đà Nẵng	[]	3	120	2200000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK008	30	Không yêu cầu	\N	[{"fee": 2200000, "level": "Sinh viên"}, {"fee": 2600000, "level": "Tốt nghiệp"}, {"fee": 3000000, "level": "Giáo viên"}]	[{"fee": 1500000, "level": "Sinh viên"}, {"fee": 2100000, "level": "Tốt nghiệp"}, {"fee": 2700000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
793e8080-35b0-4fdc-a3b8-e4ed5abe5554	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Gia sư đàn Piano căn bản tại nhà	Piano	Mầm non	Bé 5 tuổi cần làm quen với Piano	OFFLINE	Quận 7, Hồ Chí Minh	[]	2	60	3200000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK009	30	Nữ	\N	[{"fee": 3200000, "level": "Tốt nghiệp"}, {"fee": 4000000, "level": "Giáo viên"}]	[{"fee": 2800000, "level": "Tốt nghiệp"}, {"fee": 3600000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
18792c97-8429-48ed-aae4-378a6bdae273	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Cần giáo viên chuyên Lí kèm ôn ĐH	Vật Lý	Lớp 12	Mục tiêu 8.5+ Đại học	ONLINE	Online	[]	3	120	3500000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK010	30	Không yêu cầu	\N	[{"fee": 3500000, "level": "Sinh viên"}, {"fee": 4000000, "level": "Tốt nghiệp"}, {"fee": 5000000, "level": "Giáo viên"}]	[{"fee": 2500000, "level": "Sinh viên"}, {"fee": 3500000, "level": "Tốt nghiệp"}, {"fee": 4500000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
a40f752e-30c3-41be-a72e-c2287191c176	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Tiếng Anh cấp tốc thi TOEIC 600+	Tiếng Anh	Sinh viên	Đang nợ chuẩn đầu ra, cần thi lẹ	OFFLINE	Cẩm Lệ, Đà Nẵng	[]	4	90	1600000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK011	30	Không yêu cầu	\N	[{"fee": 1600000, "level": "Sinh viên"}, {"fee": 1800000, "level": "Tốt nghiệp"}, {"fee": 2200000, "level": "Giáo viên"}]	[{"fee": 1100000, "level": "Sinh viên"}, {"fee": 1540000, "level": "Tốt nghiệp"}, {"fee": 1980000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
6d9a8558-df49-40b5-80f7-33e423d92f49	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Cần gia sư tiếng Nhật N4	Ngoại ngữ	Người đi làm	Đã học xong N5, muốn luyện hội thoại	ONLINE	Online	[]	2	90	2400000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK012	30	Không yêu cầu	\N	[{"fee": 2400000, "level": "Sinh viên"}, {"fee": 2800000, "level": "Tốt nghiệp"}, {"fee": 3500000, "level": "Giáo viên"}]	[{"fee": 1750000, "level": "Sinh viên"}, {"fee": 2450000, "level": "Tốt nghiệp"}, {"fee": 3150000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
a25a96ff-c0d1-4d64-b8d2-49caf43c3c68	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Kèm đánh vần Tiếng Việt lớp mầm non	Tiếng Việt	Mầm non	Cho bé chuẩn bị vào lớp 1	OFFLINE	Bình Thạnh, Hồ Chí Minh	[]	5	45	1000000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK013	30	Nữ	\N	[{"fee": 1000000, "level": "Sinh viên"}, {"fee": 1200000, "level": "Tốt nghiệp"}, {"fee": 1500000, "level": "Giáo viên"}]	[{"fee": 750000, "level": "Sinh viên"}, {"fee": 1050000, "level": "Tốt nghiệp"}, {"fee": 1350000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
37d5d302-47f1-4ee2-a454-af95d326ffe6	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Gia sư Mỹ Thuật / Vẽ tranh màu nước	Khác	Khác	Dạy vẽ cơ bản cho người lớn	OFFLINE	Hoàn Kiếm, Hà Nội	[]	1	120	1800000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK014	30	Không yêu cầu	\N	[{"fee": 1800000, "level": "Tốt nghiệp"}, {"fee": 2000000, "level": "Giáo viên"}]	[{"fee": 1400000, "level": "Tốt nghiệp"}, {"fee": 1800000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
09ea3491-1a05-4186-88ff-a505b9c65214	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Kèm Toán lớp 6, học trò bướng bỉnh	Toán	Lớp 6	Cần SV thật nghiêm khắc	OFFLINE	Quận 1, Hồ Chí Minh	[]	3	90	1800000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK015	30	Nam	\N	[{"fee": 1800000, "level": "Sinh viên"}, {"fee": 2200000, "level": "Tốt nghiệp"}, {"fee": 2600000, "level": "Giáo viên"}]	[{"fee": 1300000, "level": "Sinh viên"}, {"fee": 1820000, "level": "Tốt nghiệp"}, {"fee": 2340000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
6728aa37-9009-4784-81b7-d5418dd51d4e	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Dạy Toán Hóa khối B lớp 10	Toán	Lớp 10	Giúp lấy gốc mất gốc tự tin	ONLINE	Online	[]	2	120	1300000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK016	30	Không yêu cầu	\N	[{"fee": 1300000, "level": "Sinh viên"}, {"fee": 1600000, "level": "Tốt nghiệp"}, {"fee": 1900000, "level": "Giáo viên"}]	[{"fee": 950000, "level": "Sinh viên"}, {"fee": 1330000, "level": "Tốt nghiệp"}, {"fee": 1710000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
b9de743a-2202-421f-b4a2-fb22cc59eb31	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Toán nâng cao HSG cấp huyện	Toán	Lớp 9	HS chăm chỉ, cần giáo viên hướng dẫn đề khó	OFFLINE	Sơn Trà, Đà Nẵng	[]	2	120	3800000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK017	30	Không yêu cầu	\N	[{"fee": 3800000, "level": "Tốt nghiệp"}, {"fee": 4500000, "level": "Giáo viên"}]	[{"fee": 3150000, "level": "Tốt nghiệp"}, {"fee": 4050000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
147c5c9e-6811-408f-9647-56a6dc1e605a	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Giảng viên dạy lập trình C++ cho SV năm 1	Tin Học	Đại học	Cần người hiểu sâu giải thuật	ONLINE	Online	[]	1	150	4000000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK018	30	Không yêu cầu	\N	[{"fee": 4000000, "level": "Tốt nghiệp"}, {"fee": 5000000, "level": "Giáo viên"}]	[{"fee": 3500000, "level": "Tốt nghiệp"}, {"fee": 4500000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
4f3e3336-e1cf-4723-a500-32bccaf813da	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Kèm Sử Địa lớp 12 luyện thi QG	Sử-Địa	Lớp 12	Khoanh vùng kiến thức trọng tâm	OFFLINE	Thủ Đức, Hồ Chí Minh	[]	3	90	1600000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK019	30	Không yêu cầu	\N	[{"fee": 1600000, "level": "Sinh viên"}, {"fee": 1900000, "level": "Tốt nghiệp"}, {"fee": 2300000, "level": "Giáo viên"}]	[{"fee": 1150000, "level": "Sinh viên"}, {"fee": 1610000, "level": "Tốt nghiệp"}, {"fee": 2070000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
dad66496-0079-4f85-a1c1-cd9bf01c63a0	a0000000-0000-0000-0000-000000000001	c0000000-0000-0000-0000-000000000001	\N	Anh văn cơ bản hè cho bé lên lớp 3	Tiếng Anh	Lớp 3	Tạo hứng thú, chơi trò chơi	OFFLINE	Tây Hồ, Hà Nội	[]	3	90	1100000.00	0.00	OPEN	\N	\N	f	2026-04-10 19:10:49.286921+00	2026-04-10 19:10:49.286921+00	\N	MCK020	30	Không yêu cầu	\N	[{"fee": 1100000, "level": "Sinh viên"}, {"fee": 1300000, "level": "Tốt nghiệp"}, {"fee": 1600000, "level": "Giáo viên"}]	[{"fee": 800000, "level": "Sinh viên"}, {"fee": 1120000, "level": "Tốt nghiệp"}, {"fee": 1440000, "level": "Giáo viên"}]	\N	\N	\N	t	\N	\N	\N	\N
\.


--
-- Data for Name: consultation_leads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.consultation_leads (id, name, phone, is_contacted, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contact_messages (id, name, email, subject, message, is_read, created_at, updated_at) FROM stdin;
f4128633-3b80-4a26-9793-238cb5c08a62	Sophie Lane	sophie@sendproud.com	Hỗ trợ tìm gia sư	Hi, I’m Sophie! I tried to find you on LinkedIn but couldn’t, so I’m reaching out here. I help businesses book meetings, drive traffic, and generate user sign ups through targeted outreach using my extensive private network, built over 12+ years, with access to over 100 million contacts. We’ll have a quick call to set a clear goal for your business, and I’ll personally work to make sure we reach it. You choose the result you want, whether that’s booked meetings, website traffic, user sign ups, or another measurable outcome, and if I fall short by even one, I’ll refund your money in full. Schedule a time with me here: https://calendly.com/sendproud/30min	t	2026-04-11 13:33:07.98083	2026-04-14 03:14:15.931114
\.


--
-- Data for Name: conversation_backups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conversation_backups (id, user_id, user_role, last_message_preview, last_message_at, last_message_sender_name, unread_count_admin, unread_count_user, is_closed, created_at, updated_at, archived_at) FROM stdin;
\.


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conversations (id, user_id, user_role, last_message_preview, last_message_at, unread_count_admin, unread_count_user, is_closed, created_at, updated_at, last_message_sender_name) FROM stdin;
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.feedbacks (id, class_id, parent_id, tutor_id, rating, comment, is_visible, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	init schema	SQL	V1__init_schema.sql	1074146194	edtech	2026-04-10 19:10:46.939893	674	t
2	2	mock data	SQL	V2__mock_data.sql	-408003197	edtech	2026-04-10 19:10:47.853794	12	t
3	3	system configs	SQL	V3__system_configs.sql	897783947	edtech	2026-04-10 19:10:47.892218	3	t
4	4	provinces wards	SQL	V4__provinces_wards.sql	-1072884730	edtech	2026-04-10 19:10:47.905686	1042	t
5	5	fix mock classes	SQL	V5__fix_mock_classes.sql	-78337145	edtech	2026-04-10 19:10:49.272919	15	t
6	6	create consultation leads	SQL	V6__create_consultation_leads.sql	-725128381	edtech	2026-04-10 19:10:49.307537	13	t
7	7	add must change password	SQL	V7__add_must_change_password.sql	1467694396	edtech	2026-04-10 19:10:49.328405	3	t
8	8	create user push tokens	SQL	V8__create_user_push_tokens.sql	581438617	edtech	2026-04-10 19:10:49.339881	13	t
9	9	add class suspended	SQL	V9__add_class_suspended.sql	439600428	edtech	2026-04-10 19:10:49.362162	4	t
10	10	add absence schedule notification types	SQL	V10__add_absence_schedule_notification_types.sql	1240780114	edtech	2026-04-10 19:10:49.37397	4	t
11	11	create contact messages	SQL	V11__create_contact_messages.sql	876154330	edtech	2026-04-10 19:10:49.385047	14	t
12	12	teaching module	SQL	V12__teaching_module.sql	922016404	edtech	2026-04-14 11:05:16.508231	75	t
13	13	multiple files submission	SQL	V13__multiple_files_submission.sql	-361243253	edtech	2026-04-14 11:05:16.701473	24	t
14	14	add session note notification	SQL	V14__add_session_note_notification.sql	304966473	edtech	2026-04-14 12:47:26.736628	20	t
15	15	ai module	SQL	V15__ai_module.sql	-524337725	edtech	2026-04-23 06:28:02.635738	173	t
16	16	fix ai message updated at	SQL	V16__fix_ai_message_updated_at.sql	1670003489	edtech	2026-04-23 06:28:02.917716	6	t
17	17	fix ai tables base columns	SQL	V17__fix_ai_tables_base_columns.sql	1602570944	edtech	2026-04-23 06:28:02.948615	36	t
18	18	oauth2 support	SQL	V18__oauth2_support.sql	-2095169708	edtech	2026-04-23 06:28:03.021996	43	t
19	19	fix user linked providers base columns	SQL	V19__fix_user_linked_providers_base_columns.sql	-294057277	edtech	2026-04-23 06:28:03.094502	5	t
20	20	add ai learning goal	SQL	V20__add_ai_learning_goal.sql	200951500	edtech	2026-04-23 06:28:03.114404	14	t
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (id, class_id, parent_id, admin_bank_id, amount, period_label, receipt_url, receipt_uploaded_at, status, reviewed_by, reviewed_at, reject_reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.materials (id, class_id, uploaded_by, title, description, type, file_url, file_size, external_url, is_deleted, created_at, updated_at, file_name, mime_type) FROM stdin;
\.


--
-- Data for Name: message_backups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.message_backups (id, conversation_id, sender_id, content, message_type, is_read, created_at, archived_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.messages (id, conversation_id, sender_id, content, message_type, is_read, created_at) FROM stdin;
\.


--
-- Data for Name: notification_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification_tokens (id, user_id, token, device_type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, recipient_id, type, title, body, entity_type, entity_id, is_read, read_at, created_at) FROM stdin;
1b184c61-8aa9-41ff-8ca0-35e0364a51c0	a0000000-0000-0000-0000-000000000001	CONTACT_MESSAGE_RECEIVED	Tin nhắn liên hệ mới	Sophie Lane (sophie@sendproud.com) gửi tin nhắn: Hỗ trợ tìm gia sư	CONTACT	f4128633-3b80-4a26-9793-238cb5c08a62	t	2026-04-12 07:53:06.863095+00	2026-04-11 13:33:08.223435+00
\.


--
-- Data for Name: parent_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.parent_profiles (id, user_id, address, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_methods (id, tutor_id, method_type, account_number, account_name, bank_name, is_default, created_at) FROM stdin;
\.


--
-- Data for Name: platform_configs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.platform_configs (id, config_key, config_value, description, updated_by, updated_at) FROM stdin;
\.


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.provinces (code, name) FROM stdin;
1	An Giang
2	Bắc Ninh
3	Cà Mau
4	Cao Bằng
5	Cần Thơ
6	Đà Nẵng
7	Đắk Lắk
8	Điện Biên
9	Đồng Nai
10	Đồng Tháp
11	Gia Lai
12	Hà Nội
13	Hà Tĩnh
14	Hải Phòng
15	Huế
16	Hưng Yên
17	Khánh Hòa
18	Lai Châu
19	Lạng Sơn
20	Lào Cai
21	Lâm Đồng
22	Nghệ An
23	Ninh Bình
24	Phú Thọ
25	Quảng Ngãi
26	Quảng Ninh
27	Quảng Trị
28	Sơn La
29	Tây Ninh
30	Thái Nguyên
31	Thanh Hóa
32	TP HCM
33	Tuyên Quang
34	Vĩnh Long
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refresh_tokens (id, user_id, token_hash, expires_at, created_at) FROM stdin;
9175c73e-b035-4c08-ba7a-0657a58a2a36	c0000000-0000-0000-0000-000000000001	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtb2NrX3BhcmVudCIsImlhdCI6MTc3NjEzNjUyMywiZXhwIjoxODA3NjcyNTIzfQ.E9aADXzQH5oSkC3KDGyTVXbK_JLALMpppr9xX8eJUFucYHvgTmVhXgUpq5fo4oWLBmFsQ7xGqS1Pb__WlBwHTQ	2027-04-14 03:15:23.222355+00	2026-04-14 03:15:23.222359+00
17198b1a-debf-4ac9-b248-3ba1437ac93e	11000000-0000-0000-0000-000000000001	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0dXRvcl9tb2NrXzEiLCJpYXQiOjE3NzYxNjU2MDAsImV4cCI6MTgwNzcwMTYwMH0.OF0TAVrtR7zhz_ZLFhANoHlCiQwPmvwSyl9EanLqf3Hfr9Wig4oS4RDaah91K7_fa2lHJ5H2FXC-xQlJbwv_QA	2027-04-14 11:20:00.197142+00	2026-04-14 11:20:00.197156+00
9fd82e3d-20c7-4b99-ab6c-c235f7261004	a0000000-0000-0000-0000-000000000001	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZF9lZHRlY2giLCJpYXQiOjE3ODE4NTM1NjQsImV4cCI6MTc4MTkzOTk2NH0.XS3yV6aZXJm1cjBkd2ffAvQmo3j3TsiIhd-uODRqJCg5Qfs_LJQmwxD-E3lHNGrYAxF2eLDEIH8-GaCeUBxKLA	2026-06-20 07:19:24.389826+00	2026-06-19 07:19:24.38985+00
\.


--
-- Data for Name: session_attendances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.session_attendances (id, session_id, student_id, is_present, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sessions (id, class_id, session_date, start_time, end_time, meet_link, meet_link_set_at, status, tutor_note, created_at, updated_at, requires_makeup, session_type, makeup_for_session_id) FROM stdin;
\.


--
-- Data for Name: student_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_profiles (id, user_id, parent_id, grade, school, created_at, updated_at, link_status, initiated_by) FROM stdin;
\.


--
-- Data for Name: submission_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.submission_answers (id, submission_id, question_id, answer_mcq, answer_essay, is_correct, score_awarded, tutor_feedback) FROM stdin;
\.


--
-- Data for Name: submissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.submissions (id, assessment_id, student_id, status, total_score, tutor_comment, submitted_at, graded_at, graded_by, created_at, updated_at, file_url, file_name, file_size, tutor_file_url, tutor_file_name, completed_at, last_interaction_at, files_cleaned, student_attachments, tutor_attachments) FROM stdin;
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.system_settings (id, key, value, description, created_at, updated_at) FROM stdin;
f36e01b1-2dc6-4813-9ffd-9b6adbcac600	site_name	EdTech	Tên hệ thống nền tảng	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
07d17f31-bf9c-4c13-9c92-8a3d82e03267	contact_email	support@edtech.vn	Email hỗ trợ	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
41e89bec-ae8c-4fa8-846c-f970c9e25a97	contact_phone	1800 1234	SĐT tổng đài	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
56dfbbbe-bf7d-439b-babe-16de2dda2bcd	maintenance_mode	false	Bảo trì hệ thống	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
8cf43ff2-99cb-4ce9-983a-de44a79aac75	mock_data_enabled	true	Cho phép dùng dữ liệu mock	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
388e381a-b6df-486e-9ee6-d7ff5bfaa1cc	platform_fee_percent	20	Phí nạp nền tảng (%)	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
0f72dafa-dfc6-4cb6-b77c-d0b644a65902	min_hourly_rate	50000	Giá mở lớp - Thấp nhất/giờ (VND)	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
2eb750a4-a022-4dc4-8491-e39582bab331	max_hourly_rate	2000000	Giá mở lớp - Cao nhất/giờ (VND)	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
cdfea434-528f-434f-9ad9-dd32fa44fa49	max_classes_per_tutor	5	Số lớp tối đa cho GS	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
737ef6a0-b3e0-4f46-a19f-31316fa902aa	auto_approve_enabled	false	Tự động duyệt profile gia sư	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
b42d430c-30c3-4181-ad0a-9eea6b918b52	email_on_new_user	true	Gửi email khi user đăng ký	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
9c15f37b-7e7f-4612-80d9-db6eea5c493c	email_on_verification	true	Gửi email khi GS xác thực	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
aff480e8-0cad-4d59-bce2-1f787f649446	email_on_new_class	false	Gửi email khi có lớp mới	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
0916d6f5-f682-4090-bcea-73597a92330f	email_on_payment	true	Gửi email giao dịch	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
41ace7aa-fa51-4dcd-bc9a-03c8e0043bed	primary_color	#6366f1	Màu chủ đề	2026-04-10 19:10:47.897614+00	2026-04-10 19:10:47.897614+00
\.


--
-- Data for Name: tutor_applications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tutor_applications (id, class_id, tutor_id, cover_note, status, applied_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tutor_payouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tutor_payouts (id, class_id, tutor_id, payment_method_id, gross_amount, platform_fee, net_amount, period_label, transfer_note, status, paid_by, paid_at, created_at, updated_at, amount, transaction_code, billing_id, admin_note, confirmed_by_tutor_at) FROM stdin;
\.


--
-- Data for Name: tutor_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tutor_profiles (id, user_id, bio, subjects, location, teaching_mode, hourly_rate, rating, rating_count, cert_base64s, verification_status, created_at, updated_at, tutor_type, id_card_number, teaching_levels, date_of_birth, achievements, experience_years, bank_name, bank_account_number, bank_owner_name, is_mock) FROM stdin;
f7aee60f-ebae-47bc-a24d-f93aa4899821	11000000-0000-0000-0000-000000000002	Sinh viên năm 3 Bách Khoa, giỏi Khoa học.	{Toán,"Hóa Học","Vật Lý"}	Hai Bà Trưng, Hà Nội	{OFFLINE}	100000.00	4.70	45	{}	APPROVED	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	STUDENT	\N	{}	\N	\N	2	\N	\N	\N	t
c96889ee-5898-40f2-99d2-b6bd0dafb112	11000000-0000-0000-0000-000000000003	Giáo viên Tiếng Anh IELTS 8.0, 10 năm kinh nghiệm.	{"Tiếng Anh"}	Quận 1, Hồ Chí Minh	{ONLINE}	300000.00	5.00	310	{}	APPROVED	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	TEACHER	\N	{}	\N	\N	10	\N	\N	\N	t
2b0b083d-d520-4738-80a0-140f27d27e50	11000000-0000-0000-0000-000000000004	Dạy rèn chữ đẹp, Ngữ Văn cơ bản cấp 1-2.	{"Ngữ Văn","Tiếng Việt"}	Hà Đông, Hà Nội	{OFFLINE}	150000.00	4.80	89	{}	APPROVED	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	GRADUATED	\N	{}	\N	\N	3	\N	\N	\N	t
c98bcd74-0c67-4177-a1cc-866f0d689334	11000000-0000-0000-0000-000000000001	Cử nhân Sư phạm Toán xuất sắc, 5 năm kinh nghiệm.	{Toán,"Vật Lý"}	Cầu Giấy, Hà Nội	{OFFLINE,ONLINE}	200000.00	4.90	120	{}	APPROVED	2026-04-10 19:10:47.872511+00	2026-04-11 05:52:02.384659+00	TEACHER	\N	{}	\N	\N	5				t
\.


--
-- Data for Name: user_devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_devices (id, user_id, fcm_token, device_name, created_at) FROM stdin;
\.


--
-- Data for Name: user_linked_providers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_linked_providers (id, user_id, provider, provider_user_id, provider_email, linked_at, created_at, updated_at, is_deleted) FROM stdin;
\.


--
-- Data for Name: user_push_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_push_tokens (id, user_id, token, device_type, created_at) FROM stdin;
d63f2f21-b555-4f80-890d-d325d334392a	a0000000-0000-0000-0000-000000000001	eUmwbdELC8esXgi3EBLrKd:APA91bHi0Z1nT42fR7b83MJfLRYQh1uZaJe7D7-uPoT_if_xXoNZgXVxAqzcnzgv9R22VndhiqxLPMBKBZ3twddzgRPQU1tx4aZXRIOz9YTsFkbkh5PtPzE	WEB	2026-04-11 11:28:12.823229
1613b0b8-167f-4af3-b4ca-fb7a19f4d616	a0000000-0000-0000-0000-000000000001	e0BWrrBpCrX12zPGQm8Seo:APA91bF0nZgbxm3ZgVouyS3qTLo2MsxSd9lVsUtvgBIzMP3HmWFGMIUupjwqgOyWrUeh0ABrWLEAcNyoj1NhrzApQFP0DuQB0VtyCFed3XtNLjE3b7dgEWg	WEB	2026-06-19 07:19:29.199157
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, phone, password_hash, full_name, avatar_base64, role, is_active, is_deleted, failed_attempts, locked_until, created_at, updated_at, email, username, address, school, grade, is_mock, must_change_password, auth_provider) FROM stdin;
a0000000-0000-0000-0000-000000000001	\N	$2a$10$P6cV1yLDvMxZL6hO0A5y0O9Z6oV8W4Vx7ba5Ewoic6.L1Rp8RCaYS	Admin Hoàng	\N	ADMIN	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	\N	ad_edtech	\N	\N	\N	f	f	PHONE
c0000000-0000-0000-0000-000000000001	\N	$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.	Nguyễn Văn Phụ Huynh	\N	PARENT	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	\N	mock_parent	\N	\N	\N	t	f	PHONE
11000000-0000-0000-0000-000000000002	\N	$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.	Phạm Thu Hà	\N	TUTOR	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	\N	tutor_mock_2	\N	\N	\N	t	f	PHONE
11000000-0000-0000-0000-000000000003	\N	$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.	Trần Hoàng Long	\N	TUTOR	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	\N	tutor_mock_3	\N	\N	\N	t	f	PHONE
11000000-0000-0000-0000-000000000004	\N	$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.	Ngô Quỳnh Trang	\N	TUTOR	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-10 19:10:47.872511+00	\N	tutor_mock_4	\N	\N	\N	t	f	PHONE
11000000-0000-0000-0000-000000000001	\N	$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.	Nguyễn Tuấn Vũ	GZ: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	TUTOR	t	f	0	\N	2026-04-10 19:10:47.872511+00	2026-04-11 05:52:02.353456+00	\N	tutor_mock_1	\N	\N	\N	t	f	PHONE
\.


--
-- Data for Name: wards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wards (code, name, province_code) FROM stdin;
1_1	An Biên	1
1_2	An Châu	1
1_3	An Cư	1
1_4	An Minh	1
1_5	An Phú	1
1_6	Ba Chúc	1
1_7	Bình An	1
1_8	Bình Đức	1
1_9	Bình Giang	1
1_10	Bình Hòa	1
1_11	Bình Mỹ	1
1_12	Bình Sơn	1
1_13	Bình Thạnh Đông	1
1_14	Cần Đăng	1
1_15	Châu Đốc	1
1_16	Châu Phong	1
1_17	Châu Phú	1
1_18	Châu Thành	1
1_19	Chi Lăng	1
1_20	Chợ Mới	1
1_21	Chợ Vàm	1
1_22	Cô Tô	1
1_23	Cù Lao Giêng	1
1_24	Định Hòa	1
1_25	Định Mỹ	1
1_26	Đông Hòa	1
1_27	Đông Hưng	1
1_28	Đông Thái	1
1_29	Giang Thành	1
1_30	Giồng Riềng	1
1_31	Gò Quao	1
1_32	Hà Tiên	1
1_33	Hòa Điền	1
1_34	Hòa Hưng	1
1_35	Hòa Lạc	1
1_36	Hòa Thuận	1
1_37	Hòn Đất	1
1_38	Hòn Nghệ	1
1_39	Hội An	1
1_40	Khánh Bình	1
1_41	Kiên Hải	1
1_42	Kiên Lương	1
1_43	Long Điền	1
1_44	Long Kiến	1
1_45	Long Phú	1
1_46	Long Thạnh	1
1_47	Long Xuyên	1
1_48	Mỹ Đức	1
1_49	Mỹ Hòa Hưng	1
1_50	Mỹ Thới	1
1_51	Mỹ Thuận	1
1_52	Ngọc Chúc	1
1_53	Nhơn Hội	1
1_54	Nhơn Mỹ	1
1_55	Núi Cấm	1
1_56	Óc Eo	1
1_57	Ô Lâm	1
1_58	Phú An	1
1_59	Phú Hòa	1
1_60	Phú Hữu	1
1_61	Phú Lâm	1
1_62	Phú Quốc	1
1_63	Phú Tân	1
1_64	Rạch Giá	1
1_65	Sơn Hải	1
1_66	Sơn Kiên	1
1_67	Tân An	1
1_68	Tân Châu	1
1_69	Tân Hiệp	1
1_70	Tân Hội	1
1_71	Tân Thạnh	1
1_72	Tây Phú	1
1_73	Tây Yên	1
1_74	Thạnh Đông	1
1_75	Thạnh Hưng	1
1_76	Thạnh Lộc	1
1_77	Thạnh Mỹ Tây	1
1_78	Thoại Sơn	1
1_79	Thổ Châu	1
1_80	Thới Sơn	1
1_81	Tiên Hải	1
1_82	Tịnh Biên	1
1_83	Tô Châu	1
1_84	Tri Tôn	1
1_85	U Minh Thượng	1
1_86	Vân Khánh	1
1_87	Vĩnh An	1
1_88	Vĩnh Bình	1
1_89	Vĩnh Điều	1
1_90	Vĩnh Gia	1
1_91	Vĩnh Hanh	1
1_92	Vĩnh Hậu	1
1_93	Vĩnh Hòa	1
1_94	Vĩnh Hòa Hưng	1
1_95	Vĩnh Phong	1
1_96	Vĩnh Tế	1
1_97	Vĩnh Thạnh Trung	1
1_98	Vĩnh Thông	1
1_99	Vĩnh Thuận	1
1_100	Vĩnh Trạch	1
1_101	Vĩnh Tuy	1
1_102	Vĩnh Xương	1
2_1	An Lạc	2
2_2	Bảo Đài	2
2_3	Bắc Giang	2
2_4	Bắc Lũng	2
2_5	Biển Động	2
2_6	Biên Sơn	2
2_7	Bố Hạ	2
2_8	Bồng Lai	2
2_9	Cảnh Thụy	2
2_10	Cao Đức	2
2_11	Cẩm Lý	2
2_12	Chi Lăng	2
2_13	Chũ	2
2_14	Dương Hưu	2
2_15	Đa Mai	2
2_16	Đại Đồng	2
2_17	Đại Lai	2
2_18	Đại Sơn	2
2_19	Đào Viên	2
2_20	Đèo Gia	2
2_21	Đông Cứu	2
2_22	Đồng Kỳ	2
2_23	Đồng Nguyên	2
2_24	Đông Phú	2
2_25	Đồng Việt	2
2_26	Gia Bình	2
2_27	Hạp Lĩnh	2
2_28	Hiệp Hòa	2
2_29	Hoàng Vân	2
2_30	Hợp Thịnh	2
2_31	Kép	2
2_32	Kiên Lao	2
2_33	Kinh Bắc	2
2_34	Lạng Giang	2
2_35	Lâm Thao	2
2_36	Liên Bão	2
2_37	Lục Nam	2
2_38	Lục Ngạn	2
2_39	Lục Sơn	2
2_40	Lương Tài	2
2_41	Mão Điền	2
2_42	Mỹ Thái	2
2_43	Nam Dương	2
2_44	Nam Sơn	2
2_45	Nếnh	2
2_46	Nghĩa Phương	2
2_47	Ngọc Thiện	2
2_48	Nhã Nam	2
2_49	Nhân Hòa	2
2_50	Nhân Thắng	2
2_51	Ninh Xá	2
2_52	Phật Tích	2
2_53	Phù Khê	2
2_54	Phù Lãng	2
2_55	Phúc Hoà	2
2_56	Phương Liễu	2
2_57	Phượng Sơn	2
2_58	Quang Trung	2
2_59	Quế Võ	2
2_60	Sa Lý	2
2_61	Song Liễu	2
2_62	Sơn Động	2
2_63	Sơn Hải	2
2_64	Tam Đa	2
2_65	Tam Giang	2
2_66	Tam Sơn	2
2_67	Tam Tiến	2
2_68	Tân An	2
2_69	Tân Chi	2
2_70	Tân Dĩnh	2
2_71	Tân Sơn	2
2_72	Tân Tiến	2
2_73	Tân Yên	2
2_74	Tây Yên Tử	2
2_75	Thuận Thành	2
2_76	Tiên Du	2
2_77	Tiên Lục	2
2_78	Tiền Phong	2
2_79	Trạm Lộ	2
2_80	Trí Quả	2
2_81	Trung Chính	2
2_82	Trung Kênh	2
2_83	Trường Sơn	2
2_84	Tuấn Đạo	2
2_85	Tự Lạn	2
2_86	Từ Sơn	2
2_87	Văn Môn	2
2_88	Vân Hà	2
2_89	Vân Sơn	2
2_90	Việt Yên	2
2_91	Võ Cường	2
2_92	Vũ Ninh	2
2_93	Xuân Cẩm	2
2_94	Xuân Lương	2
2_95	Yên Dũng	2
2_96	Yên Định	2
2_97	Yên Phong	2
2_98	Yên Thế	2
2_99	Yên Trung	2
3_1	An Trạch	3
3_2	An Xuyên	3
3_3	Bạc Liêu	3
3_4	Biển Bạch	3
3_5	Cái Đôi Vàm	3
3_6	Cái Nước	3
3_7	Châu Thới	3
3_8	Đá Bạc	3
3_9	Đầm Dơi	3
3_10	Đất Mới	3
3_11	Đất Mũi	3
3_12	Định Thành	3
3_13	Đông Hải	3
3_14	Gành Hào	3
3_15	Giá Rai	3
3_16	Hiệp Thành	3
3_17	Hoà Bình	3
3_18	Hoà Thành	3
3_19	Hồ Thị Kỷ	3
3_20	Hồng Dân	3
3_21	Hưng Hội	3
3_22	Hưng Mỹ	3
3_23	Khánh An	3
3_24	Khánh Bình	3
3_25	Khánh Hưng	3
3_26	Khánh Lâm	3
3_27	Láng Tròn	3
3_28	Long Điền	3
3_29	Lương Thế Trân	3
3_30	Lý Văn Lâm	3
3_31	Năm Căn	3
3_32	Nguyễn Phích	3
3_33	Nguyễn Việt Khái	3
3_34	Ninh Quới	3
3_35	Ninh Thạnh Lợi	3
3_36	Phan Ngọc Hiển	3
3_37	Phong Hiệp	3
3_38	Phong Thạnh	3
3_39	Phú Mỹ	3
3_40	Phú Tân	3
3_41	Phước Long	3
3_42	Quách Phẩm	3
3_43	Sông Đốc	3
3_44	Tạ An Khương	3
3_45	Tam Giang	3
3_46	Tân Ân	3
3_47	Tân Hưng	3
3_48	Tân Lộc	3
3_49	Tân Thành	3
3_50	Tân Thuận	3
3_51	Tân Tiến	3
3_52	Thanh Tùng	3
3_53	Thới Bình	3
3_54	Trần Phán	3
3_55	Trần Văn Thời	3
3_56	Trí Phải	3
3_57	U Minh	3
3_58	Vĩnh Hậu	3
3_59	Vĩnh Lộc	3
3_60	Vĩnh Lợi	3
3_61	Vĩnh Mỹ	3
3_62	Vĩnh Phước	3
3_63	Vĩnh Thanh	3
3_64	Vĩnh Trạch	3
4_1	Bạch Đằng	4
4_2	Bảo Lạc	4
4_3	Bảo Lâm	4
4_4	Bế Văn Đàn	4
4_5	Ca Thành	4
4_6	Canh Tân	4
4_7	Cần Yên	4
4_8	Cô Ba	4
4_9	Cốc Pàng	4
4_10	Đàm Thủy	4
4_11	Đình Phong	4
4_12	Đoài Dương	4
4_13	Độc Lập	4
4_14	Đông Khê	4
4_15	Đức Long	4
4_16	Hạ Lang	4
4_17	Hà Quảng	4
4_18	Hạnh Phúc	4
4_19	Hòa An	4
4_20	Huy Giáp	4
4_21	Hưng Đạo	4
4_22	Khánh Xuân	4
4_23	Kim Đồng	4
4_24	Lũng Nặm	4
4_25	Lý Bôn	4
4_26	Lý Quốc	4
4_27	Minh Khai	4
4_28	Minh Tâm	4
4_29	Nam Quang	4
4_30	Nam Tuấn	4
4_31	Nguyên Bình	4
4_32	Nguyễn Huệ	4
4_33	Nùng Trí Cao	4
4_34	Phan Thanh	4
4_35	Phục Hòa	4
4_36	Quang Hán	4
4_37	Quảng Lâm	4
4_38	Quang Long	4
4_39	Quang Trung	4
4_40	Quảng Uyên	4
4_41	Sơn Lộ	4
4_42	Tam Kim	4
4_43	Tân Giang	4
4_44	Thạch An	4
4_45	Thành Công	4
4_46	Thanh Long	4
4_47	Thông Nông	4
4_48	Thục Phán	4
4_49	Tĩnh Túc	4
4_50	Tổng Cọt	4
4_51	Trà Lĩnh	4
4_52	Trùng Khánh	4
4_53	Trường Hà	4
4_54	Vinh Quý	4
4_55	Xuân Trường	4
4_56	Yên Thổ	4
5_1	An Bình	5
5_2	An Lạc Thôn	5
5_3	An Ninh	5
5_4	An Thạnh	5
5_5	Bình Thủy	5
5_6	Cái Khế	5
5_7	Cái Răng	5
5_8	Châu Thành	5
5_9	Cờ Đỏ	5
5_10	Cù Lao Dung	5
5_11	Đại Hải	5
5_12	Đại Ngãi	5
5_13	Đại Thành	5
5_14	Đông Hiệp	5
5_15	Đông Phước	5
5_16	Đông Thuận	5
5_17	Gia Hòa	5
5_18	Hiệp Hưng	5
5_19	Hòa An	5
5_20	Hỏa Lựu	5
5_21	Hòa Tú	5
5_22	Hồ Đắc Kiện	5
5_23	Hưng Phú	5
5_24	Kế Sách	5
5_25	Khánh Hòa	5
5_26	Lai Hòa	5
5_27	Lâm Tân	5
5_28	Lịch Hội Thượng	5
5_29	Liêu Tú	5
5_30	Long Bình	5
5_31	Long Hưng	5
5_32	Long Mỹ	5
5_33	Long Phú	5
5_34	Long Phú 1	5
5_35	Long Tuyền	5
5_36	Lương Tâm	5
5_37	Mỹ Hương	5
5_38	Mỹ Phước	5
5_39	Mỹ Quới	5
5_40	Mỹ Tú	5
5_41	Mỹ Xuyên	5
5_42	Ngã Bảy	5
5_43	Ngã Năm	5
5_44	Ngọc Tố	5
5_45	Nhơn Ái	5
5_46	Nhơn Mỹ	5
5_47	Nhu Gia	5
5_48	Ninh Kiều	5
5_49	Ô Môn	5
5_50	Phong Điền	5
5_51	Phong Nẫm	5
5_52	Phú Hữu	5
5_53	Phú Lộc	5
5_54	Phú Lợi	5
5_55	Phú Tâm	5
5_56	Phụng Hiệp	5
5_57	Phước Thới	5
5_58	Phương Bình	5
5_59	Sóc Trăng	5
5_60	Tài Văn	5
5_61	Tân An	5
5_62	Tân Bình	5
5_63	Tân Hòa	5
5_64	Tân Long	5
5_65	Tân Lộc	5
5_66	Tân Phước Hưng	5
5_67	Tân Thạnh	5
5_68	Thạnh An	5
5_69	Thạnh Hòa	5
5_70	Thạnh Phú	5
5_71	Thạnh Quới	5
5_72	Thạnh Thới An	5
5_73	Thạnh Xuân	5
5_74	Thốt Nốt	5
5_75	Thới An Đông	5
5_76	Thới An Hội	5
5_77	Thới Hưng	5
5_78	Thới Lai	5
5_79	Thới Long	5
5_80	Thuận Hòa	5
5_81	Thuận Hưng	5
5_82	Trần Đề	5
5_83	Trung Hưng	5
5_84	Trung Nhứt	5
5_85	Trường Khánh	5
5_86	Trường Long	5
5_87	Trường Long Tây	5
5_88	Trường Thành	5
5_89	Trường Xuân	5
5_90	Vị Tân	5
5_91	Vị Thanh	5
5_92	Vị Thanh 1	5
5_93	Vị Thủy	5
5_94	Vĩnh Châu	5
5_95	Vĩnh Hải	5
5_96	Vĩnh Lợi	5
5_97	Vĩnh Phước	5
5_98	Vĩnh Thạnh	5
5_99	Vĩnh Thuận Đông	5
5_100	Vĩnh Trinh	5
5_101	Vĩnh Tường	5
5_102	Vĩnh Viễn	5
5_103	Xà Phiên	5
6_1	An Hải	6
6_2	An Khê	6
6_3	An Thắng	6
6_4	Avương	6
6_5	Bà Nà	6
6_6	Bàn Thạch	6
6_7	Bến Giằng	6
6_8	Bến Hiên	6
6_9	Cẩm Lệ	6
6_10	Chiên Đàn	6
6_11	Duy Nghĩa	6
6_12	Duy Xuyên	6
6_13	Đại Lộc	6
6_14	Đắc Pring	6
6_15	Điện Bàn	6
6_16	Điện Bàn Bắc	6
6_17	Điện Bàn Đông	6
6_18	Điện Bàn Tây	6
6_19	Đồng Dương	6
6_20	Đông Giang	6
6_21	Đức Phú	6
6_22	Gò Nổi	6
6_23	Hà Nha	6
6_24	Hải Châu	6
6_25	Hải Vân	6
6_26	Hiệp Đức	6
6_27	Hòa Cường	6
6_28	Hòa Khánh	6
6_29	Hòa Tiến	6
6_30	Hòa Vang	6
6_31	Hòa Xuân	6
6_32	Hoàng Sa	6
6_33	Hội An	6
6_34	Hội An Đông	6
6_35	Hội An Tây	6
6_36	Hùng Sơn	6
6_37	Hương Trà	6
6_38	Khâm Đức	6
6_39	La Dêê	6
6_40	La Êê	6
6_41	Lãnh Ngọc	6
6_42	Liên Chiểu	6
6_43	Nam Giang	6
6_44	Nam Phước	6
6_45	Nam Trà My	6
6_46	Ngũ Hành Sơn	6
6_47	Nông Sơn	6
6_48	Núi Thành	6
6_49	Phú Ninh	6
6_50	Phú Thuận	6
6_51	Phước Chánh	6
6_52	Phước Hiệp	6
6_53	Phước Năng	6
6_54	Phước Thành	6
6_55	Phước Trà	6
6_56	Quảng Phú	6
6_57	Quế Phước	6
6_58	Quế Sơn	6
6_59	Quế Sơn Trung	6
6_60	Sông Kôn	6
6_61	Sông Vàng	6
6_62	Sơn Cẩm Hà	6
6_63	Sơn Trà	6
6_64	Tam Anh	6
6_65	Tam Hải	6
6_66	Tam Kỳ	6
6_67	Tam Mỹ	6
6_68	Tam Xuân	6
6_69	Tân Hiệp	6
6_70	Tây Giang	6
6_71	Tây Hồ	6
6_72	Thạnh Bình	6
6_73	Thanh Khê	6
6_74	Thạnh Mỹ	6
6_75	Thăng An	6
6_76	Thăng Bình	6
6_77	Thăng Điền	6
6_78	Thăng Phú	6
6_79	Thăng Trường	6
6_80	Thu Bồn	6
6_81	Thượng Đức	6
6_82	Tiên Phước	6
6_83	Trà Đốc	6
6_84	Trà Giáp	6
6_85	Trà Leng	6
6_86	Trà Liên	6
6_87	Trà Linh	6
6_88	Trà My	6
6_89	Trà Tân	6
6_90	Trà Tập	6
6_91	Trà Vân	6
6_92	Việt An	6
6_93	Vu Gia	6
6_94	Xuân Phú	6
7_1	Bình Kiến	7
7_2	Buôn Đôn	7
7_3	Buôn Hồ	7
7_4	Buôn Ma Thuột	7
7_5	Cuôr Đăng	7
7_6	Cư Bao	7
7_7	Cư M’gar	7
7_8	Cư M’ta	7
7_9	Cư Pơng	7
7_10	Cư Prao	7
7_11	Cư Pui	7
7_12	Cư Yang	7
7_13	Dang Kang	7
7_14	Dliê Ya	7
7_15	Dray Bhăng	7
7_16	Dur Kmăl	7
7_17	Đắk Liêng	7
7_18	Đắk Phơi	7
7_19	Đông Hòa	7
7_20	Đồng Xuân	7
7_21	Đức Bình	7
7_22	Ea Bá	7
7_23	Ea Bung	7
7_24	Ea Drăng	7
7_25	Ea Drông	7
7_26	Ea H’Leo	7
7_27	Ea Hiao	7
7_28	Ea Kao	7
7_29	Ea Kar	7
7_30	Ea Khăl	7
7_31	Ea Kiết	7
7_32	Ea Kly	7
7_33	Ea Knốp	7
7_34	Ea Knuếc	7
7_35	Ea Ktur	7
7_36	Ea Ly	7
7_37	Ea M’Droh	7
7_38	Ea Na	7
7_39	Ea Ning	7
7_40	Ea Nuôl	7
7_41	Ea Ô	7
7_42	Ea Păl	7
7_43	Ea Phê	7
7_44	Ea Riêng	7
7_45	Ea Rốk	7
7_46	Ea Súp	7
7_47	Ea Trang	7
7_48	Ea Tul	7
7_49	Ea Wer	7
7_50	Ea Wy	7
7_51	Hòa Hiệp	7
7_52	Hòa Mỹ	7
7_53	Hòa Phú	7
7_54	Hòa Sơn	7
7_55	Hòa Thịnh	7
7_56	Hòa Xuân	7
7_57	Ia Lốp	7
7_58	Ia Rvê	7
7_59	Krông Á	7
7_60	Krông Ana	7
7_61	Krông Bông	7
7_62	Krông Búk	7
7_63	Krông Năng	7
7_64	Krông Nô	7
7_65	Krông Pắc	7
7_66	Liên Sơn Lắk	7
7_67	M’Drắk	7
7_68	Nam Ka	7
7_69	Ô Loan	7
7_70	Phú Hòa 1	7
7_71	Phú Hòa 2	7
7_72	Phú Mỡ	7
7_73	Phú Xuân	7
7_74	Phú Yên	7
7_75	Pơng Drang	7
7_76	Quảng Phú	7
7_77	Sông Cầu	7
7_78	Sông Hinh	7
7_79	Sơn Hòa	7
7_80	Sơn Thành	7
7_81	Suối Trai	7
7_82	Tam Giang	7
7_83	Tân An	7
7_84	Tân Lập	7
7_85	Tân Tiến	7
7_86	Tây Hòa	7
7_87	Tây Sơn	7
7_88	Thành Nhất	7
7_89	Tuy An Bắc	7
7_90	Tuy An Đông	7
7_91	Tuy An Nam	7
7_92	Tuy An Tây	7
7_93	Tuy Hòa	7
7_94	Vân Hòa	7
7_95	Vụ Bổn	7
7_96	Xuân Cảnh	7
7_97	Xuân Đài	7
7_98	Xuân Lãnh	7
7_99	Xuân Lộc	7
7_100	Xuân Phước	7
7_101	Xuân Thọ	7
7_102	Yang Mao	7
8_1	Búng Lao	8
8_2	Chà Tở	8
8_3	Chiềng Sinh	8
8_4	Điện Biên Phủ	8
8_5	Mường Ảng	8
8_6	Mường Chà	8
8_7	Mường Lạn	8
8_8	Mường Lay	8
8_9	Mường Luân	8
8_10	Mường Mùn	8
8_11	Mường Nhà	8
8_12	Mường Nhé	8
8_13	Mường Phăng	8
8_14	Mường Pồn	8
8_15	Mường Thanh	8
8_16	Mường Toong	8
8_17	Mường Tùng	8
8_18	Nà Bủng	8
8_19	Nà Hỳ	8
8_20	Na Sang	8
8_21	Na Son	8
8_22	Nà Tấu	8
8_23	Nậm Kè	8
8_24	Nậm Nèn	8
8_25	Núa Ngam	8
8_26	Pa Ham	8
8_27	Phình Giàng	8
8_28	Pu Nhi	8
8_29	Pú Nhung	8
8_30	Quài Tở	8
8_31	Quảng Lâm	8
8_32	Sam Mứn	8
8_33	Sáng Nhè	8
8_34	Si Pa Phìn	8
8_35	Sín Chải	8
8_36	Sín Thầu	8
8_37	Sính Phình	8
8_38	Thanh An	8
8_39	Thanh Nưa	8
8_40	Thanh Yên	8
8_41	Tìa Dình	8
8_42	Tủa Chùa	8
8_43	Tủa Thàng	8
8_44	Tuần Giáo	8
8_45	Xa Dung	8
9_1	An Lộc	9
9_2	An Phước	9
9_3	An Viễn	9
9_4	Bảo Vinh	9
9_5	Bàu Hàm	9
9_6	Biên Hòa	9
9_7	Bình An	9
9_8	Bình Long	9
9_9	Bình Lộc	9
9_10	Bình Minh	9
9_11	Bình Phước	9
9_12	Bình Tân	9
9_13	Bom Bo	9
9_14	Bù Đăng	9
9_15	Bù Gia Mập	9
9_16	Cẩm Mỹ	9
9_17	Chơn Thành	9
9_18	Dầu Giây	9
9_19	Đa Kia	9
9_20	Đại Phước	9
9_21	Đak Lua	9
9_22	Đak Nhau	9
9_23	Đăk Ơ	9
9_24	Định Quán	9
9_25	Đồng Phú	9
9_26	Đồng Tâm	9
9_27	Đồng Xoài	9
9_28	Gia Kiệm	9
9_29	Hàng Gòn	9
9_30	Hố Nai	9
9_31	Hưng Phước	9
9_32	Hưng Thịnh	9
9_33	La Ngà	9
9_34	Long Bình	9
9_35	Long Hà	9
9_36	Long Hưng	9
9_37	Long Khánh	9
9_38	Long Phước	9
9_39	Long Thành	9
9_40	Lộc Hưng	9
9_41	Lộc Ninh	9
9_42	Lộc Quang	9
9_43	Lộc Tấn	9
9_44	Lộc Thành	9
9_45	Lộc Thạnh	9
9_46	Minh Đức	9
9_47	Minh Hưng	9
9_48	Nam Cát Tiên	9
9_49	Nghĩa Trung	9
9_50	Nha Bích	9
9_51	Nhơn Trạch	9
9_52	Phú Hòa	9
9_53	Phú Lâm	9
9_54	Phú Lý	9
9_55	Phú Nghĩa	9
9_56	Phú Riềng	9
9_57	Phú Trung	9
9_58	Phú Vinh	9
9_59	Phước An	9
9_60	Phước Bình	9
9_61	Phước Long	9
9_62	Phước Sơn	9
9_63	Phước Tân	9
9_64	Phước Thái	9
9_65	Sông Ray	9
9_66	Tà Lài	9
9_67	Tam Hiệp	9
9_68	Tam Phước	9
9_69	Tân An	9
9_70	Tân Hưng	9
9_71	Tân Khai	9
9_72	Tân Lợi	9
9_73	Tân Phú	9
9_74	Tân Quan	9
9_75	Tân Tiến	9
9_76	Tân Triều	9
9_77	Thanh Sơn	9
9_78	Thiện Hưng	9
9_79	Thọ Sơn	9
9_80	Thống Nhất	9
9_81	Thuận Lợi	9
9_82	Trảng Bom	9
9_83	Trảng Dài	9
9_84	Trấn Biên	9
9_85	Trị An	9
9_86	Xuân Bắc	9
9_87	Xuân Định	9
9_88	Xuân Đông	9
9_89	Xuân Đường	9
9_90	Xuân Hòa	9
9_91	Xuân Lập	9
9_92	Xuân Lộc	9
9_93	Xuân Phú	9
9_94	Xuân Quế	9
9_95	Xuân Thành	9
10_1	An Bình	10
10_2	An Hòa	10
10_3	An Hữu	10
10_4	An Long	10
10_5	An Phước	10
10_6	An Thạnh Thủy	10
10_7	Ba Sao	10
10_8	Bình Hàng Trung	10
10_9	Bình Ninh	10
10_10	Bình Phú	10
10_11	Bình Thành	10
10_12	Bình Trưng	10
10_13	Bình Xuân	10
10_14	Cái Bè	10
10_15	Cai Lậy	10
10_16	Cao Lãnh	10
10_17	Châu Thành	10
10_18	Chợ Gạo	10
10_19	Đạo Thạnh	10
10_20	Đốc Binh Kiều	10
10_21	Đồng Sơn	10
10_22	Gia Thuận	10
10_23	Gò Công	10
10_24	Gò Công Đông	10
10_25	Hậu Mỹ	10
10_26	Hiệp Đức	10
10_27	Hòa Long	10
10_28	Hội Cư	10
10_29	Hồng Ngự	10
10_30	Hưng Thạnh	10
10_31	Kim Sơn	10
10_32	Lai Vung	10
10_33	Lấp Vò	10
10_34	Long Bình	10
10_35	Long Định	10
10_36	Long Hưng	10
10_37	Long Khánh	10
10_38	Long Phú Thuận	10
10_39	Long Thuận	10
10_40	Long Tiên	10
10_41	Lương Hòa Lạc	10
10_42	Mỹ An Hưng	10
10_43	Mỹ Đức Tây	10
10_44	Mỹ Hiệp	10
10_45	Mỹ Lợi	10
10_46	Mỹ Ngãi	10
10_47	Mỹ Phong	10
10_48	Mỹ Phước Tây	10
10_49	Mỹ Quí	10
10_50	Mỹ Thành	10
10_51	Mỹ Thiện	10
10_52	Mỹ Tho	10
10_53	Mỹ Thọ	10
10_54	Mỹ Tịnh An	10
10_55	Mỹ Trà	10
10_56	Ngũ Hiệp	10
10_57	Nhị Quý	10
10_58	Phong Hòa	10
10_59	Phong Mỹ	10
10_60	Phú Cường	10
10_61	Phú Hựu	10
10_62	Phú Thành	10
10_63	Phú Thọ	10
10_64	Phương Thịnh	10
10_65	Sa Đéc	10
10_66	Sơn Qui	10
10_67	Tam Nông	10
10_68	Tân Dương	10
10_69	Tân Điền	10
10_70	Tân Đông	10
10_71	Tân Hòa	10
10_72	Tân Hộ Cơ	10
10_73	Tân Hồng	10
10_74	Tân Hương	10
10_75	Tân Khánh Trung	10
10_76	Tân Long	10
10_77	Tân Nhuận Đông	10
10_78	Tân Phú	10
10_79	Tân Phú Đông	10
10_80	Tân Phú Trung	10
10_81	Tân Phước 1	10
10_82	Tân Phước 2	10
10_83	Tân Phước 3	10
10_84	Tân Thành	10
10_85	Tân Thạnh	10
10_86	Tân Thới	10
10_87	Tân Thuận Bình	10
10_88	Thanh Bình	10
10_89	Thanh Hòa	10
10_90	Thanh Hưng	10
10_91	Thanh Mỹ	10
10_92	Thạnh Phú	10
10_93	Tháp Mười	10
10_94	Thới Sơn	10
10_95	Thường Lạc	10
10_96	Thường Phước	10
10_97	Tràm Chim	10
10_98	Trung An	10
10_99	Trường Xuân	10
10_100	Vĩnh Bình	10
10_101	Vĩnh Hựu	10
10_102	Vĩnh Kim	10
11_1	Al Bá	11
11_2	An Bình	11
11_3	An Hòa	11
11_4	An Khê	11
11_5	An Lão	11
11_6	An Lương	11
11_7	An Nhơn	11
11_8	An Nhơn Bắc	11
11_9	An Nhơn Đông	11
11_10	An Nhơn Nam	11
11_11	An Nhơn Tây	11
11_12	An Phú	11
11_13	An Toàn	11
11_14	An Vinh	11
11_15	Ayun	11
11_16	Ayun Pa	11
11_17	Ân Hảo	11
11_18	Ân Tường	11
11_19	Bàu Cạn	11
11_20	Biển Hồ	11
11_21	Bình An	11
11_22	Bình Dương	11
11_23	Bình Định	11
11_24	Bình Hiệp	11
11_25	Bình Khê	11
11_26	Bình Phú	11
11_27	Bồng Sơn	11
11_28	Bờ Ngoong	11
11_29	Canh Liên	11
11_30	Canh Vinh	11
11_31	Cát Tiến	11
11_32	Chơ Long	11
11_33	Chư A Thai	11
11_34	Chư Krey	11
11_35	Chư Păh	11
11_36	Chư Prông	11
11_37	Chư Pưh	11
11_38	Chư Sê	11
11_39	Cửu An	11
11_40	Diên Hồng	11
11_41	Đak Đoa	11
11_42	Đak Pơ	11
11_43	Đak Rong	11
11_44	Đak Sơmei	11
11_45	Đăk Song	11
11_46	Đề Gi	11
11_47	Đức Cơ	11
11_48	Gào	11
11_49	Hòa Hội	11
11_50	Hoài Ân	11
11_51	Hoài Nhơn	11
11_52	Hoài Nhơn Bắc	11
11_53	Hoài Nhơn Đông	11
11_54	Hoài Nhơn Nam	11
11_55	Hoài Nhơn Tây	11
11_56	Hội Phú	11
11_57	Hội Sơn	11
11_58	Hra	11
11_59	Ia Băng	11
11_60	Ia Boòng	11
11_61	Ia Chia	11
11_62	Ia Dom	11
11_63	Ia Dơk	11
11_64	Ia Dreh	11
11_65	Ia Grai	11
11_66	Ia Hiao	11
11_67	Ia Hrú	11
11_68	Ia Hrung	11
11_69	Ia Khươl	11
11_70	Ia Ko	11
11_71	Ia Krái	11
11_72	Ia Krêl	11
11_73	Ia Lâu	11
11_74	Ia Le	11
11_75	Ia Ly	11
11_76	Ia Mơ	11
11_77	Ia Nan	11
11_78	Ia O	11
11_79	Ia Pa	11
11_80	Ia Phí	11
11_81	Ia Pia	11
11_82	Ia Pnôn	11
11_83	Ia Púch	11
11_84	Ia Rbol	11
11_85	Ia Rsai	11
11_86	Ia Sao	11
11_87	Ia Tôr	11
11_88	Ia Tul	11
11_89	Kbang	11
11_90	KDang	11
11_91	Kim Sơn	11
11_92	Kon Chiêng	11
11_93	Kon Gang	11
11_94	Kông Bơ La	11
11_95	Kông Chro	11
11_96	Krong	11
11_97	Lơ Pang	11
11_98	Mang Yang	11
11_99	Ngô Mây	11
11_100	Nhơn Châu	11
11_101	Phù Cát	11
11_102	Phù Mỹ	11
11_103	Phù Mỹ Bắc	11
11_104	Phù Mỹ Đông	11
11_105	Phù Mỹ Nam	11
11_106	Phù Mỹ Tây	11
11_107	Phú Thiện	11
11_108	Phú Túc	11
11_109	Pleiku	11
11_110	Pờ Tó	11
11_111	Quy Nhơn	11
11_112	Quy Nhơn Bắc	11
11_113	Quy Nhơn Đông	11
11_114	Quy Nhơn Nam	11
11_115	Quy Nhơn Tây	11
11_116	Sơn Lang	11
11_117	SRó	11
11_118	Tam Quan	11
11_119	Tây Sơn	11
11_120	Thống Nhất	11
11_121	Tơ Tung	11
11_122	Tuy Phước	11
11_123	Tuy Phước Bắc	11
11_124	Tuy Phước Đông	11
11_125	Tuy Phước Tây	11
11_126	Uar	11
11_127	Vạn Đức	11
11_128	Vân Canh	11
11_129	Vĩnh Quang	11
11_130	Vĩnh Sơn	11
11_131	Vĩnh Thạnh	11
11_132	Vĩnh Thịnh	11
11_133	Xuân An	11
11_134	Ya Hội	11
11_135	Ya Ma	11
12_1	An Khánh	12
12_2	Ba Đình	12
12_3	Ba Vì	12
12_4	Bạch Mai	12
12_5	Bát Tràng	12
12_6	Bất Bạt	12
12_7	Bình Minh	12
12_8	Bồ Đề	12
12_9	Cầu Giấy	12
12_10	Chuyên Mỹ	12
12_11	Chương Dương	12
12_12	Chương Mỹ	12
12_13	Cổ Đô	12
12_14	Cửa Nam	12
12_15	Dân Hòa	12
12_16	Dương Hòa	12
12_17	Dương Nội	12
12_18	Đa Phúc	12
12_19	Đại Mỗ	12
12_20	Đại Thanh	12
12_21	Đại Xuyên	12
12_22	Đan Phượng	12
12_23	Định Công	12
12_24	Đoài Phương	12
12_25	Đông Anh	12
12_26	Đống Đa	12
12_27	Đông Ngạc	12
12_28	Gia Lâm	12
12_29	Giảng Võ	12
12_30	Hạ Bằng	12
12_31	Hà Đông	12
12_32	Hai Bà Trưng	12
12_33	Hát Môn	12
12_34	Hòa Lạc	12
12_35	Hòa Phú	12
12_36	Hòa Xá	12
12_37	Hoài Đức	12
12_38	Hoàn Kiếm	12
12_39	Hoàng Liệt	12
12_40	Hoàng Mai	12
12_41	Hồng Hà	12
12_42	Hồng Sơn	12
12_43	Hồng Vân	12
12_44	Hưng Đạo	12
12_45	Hương Sơn	12
12_46	Khương Đình	12
12_47	Kiến Hưng	12
12_48	Kiều Phú	12
12_49	Kim Anh	12
12_50	Kim Liên	12
12_51	Láng	12
12_52	Liên Minh	12
12_53	Lĩnh Nam	12
12_54	Long Biên	12
12_55	Mê Linh	12
12_56	Minh Châu	12
12_57	Mỹ Đức	12
12_58	Nam Phù	12
12_59	Nghĩa Đô	12
12_60	Ngọc Hà	12
12_61	Ngọc Hồi	12
12_62	Nội Bài	12
12_63	Ô Chợ Dừa	12
12_64	Ô Diên	12
12_65	Phú Cát	12
12_66	Phú Diễn	12
12_67	Phù Đổng	12
12_68	Phú Lương	12
12_69	Phú Nghĩa	12
12_70	Phú Thượng	12
12_71	Phú Xuyên	12
12_72	Phúc Lộc	12
12_73	Phúc Lợi	12
12_74	Phúc Sơn	12
12_75	Phúc Thịnh	12
12_76	Phúc Thọ	12
12_77	Phượng Dực	12
12_78	Phương Liệt	12
12_79	Quảng Bị	12
12_80	Quang Minh	12
12_81	Quảng Oai	12
12_82	Quốc Oai	12
12_83	Sóc Sơn	12
12_84	Sơn Đồng	12
12_85	Sơn Tây	12
12_86	Suối Hai	12
12_87	Tam Hưng	12
12_88	Tây Hồ	12
12_89	Tây Mỗ	12
12_90	Tây Phương	12
12_91	Tây Tựu	12
12_92	Thạch Thất	12
12_93	Thanh Liệt	12
12_94	Thanh Oai	12
12_95	Thanh Trì	12
12_96	Thanh Xuân	12
12_97	Thiên Lộc	12
12_98	Thuận An	12
12_99	Thư Lâm	12
12_100	Thượng Cát	12
12_101	Thượng Phúc	12
12_102	Thường Tín	12
12_103	Tiến Thắng	12
12_104	Trần Phú	12
12_105	Trung Giã	12
12_106	Tùng Thiện	12
12_107	Từ Liêm	12
12_108	Tương Mai	12
12_109	Ứng Hòa	12
12_110	Ứng Thiên	12
12_111	Văn Miếu - Quốc Tử Giám	12
12_112	Vân Đình	12
12_113	Vật Lại	12
12_114	Việt Hưng	12
12_115	Vĩnh Hưng	12
12_116	Vĩnh Thanh	12
12_117	Vĩnh Tuy	12
12_118	Xuân Đỉnh	12
12_119	Xuân Mai	12
12_120	Xuân Phương	12
12_121	Yên Bài	12
12_122	Yên Hòa	12
12_123	Yên Lãng	12
12_124	Yên Nghĩa	12
12_125	Yên Sở	12
12_126	Yên Xuân	12
13_1	Bắc Hồng Lĩnh	13
13_2	Can Lộc	13
13_3	Cẩm Bình	13
13_4	Cẩm Duệ	13
13_5	Cẩm Hưng	13
13_6	Cẩm Lạc	13
13_7	Cẩm Trung	13
13_8	Cẩm Xuyên	13
13_9	Cổ Đạm	13
13_10	Đan Hải	13
13_11	Đông Kinh	13
13_12	Đồng Lộc	13
13_13	Đồng Tiến	13
13_14	Đức Đồng	13
13_15	Đức Minh	13
13_16	Đức Quang	13
13_17	Đức Thịnh	13
13_18	Đức Thọ	13
13_19	Gia Hanh	13
13_20	Hà Huy Tập	13
13_21	Hà Linh	13
13_22	Hải Ninh	13
13_23	Hoành Sơn	13
13_24	Hồng Lộc	13
13_25	Hương Bình	13
13_26	Hương Đô	13
13_27	Hương Khê	13
13_28	Hương Phố	13
13_29	Hương Sơn	13
13_30	Hương Xuân	13
13_31	Kim Hoa	13
13_32	Kỳ Anh	13
13_33	Kỳ Hoa	13
13_34	Kỳ Khang	13
13_35	Kỳ Lạc	13
13_36	Kỳ Thượng	13
13_37	Kỳ Văn	13
13_38	Kỳ Xuân	13
13_39	Lộc Hà	13
13_40	Mai Hoa	13
13_41	Mai Phụ	13
13_42	Nam Hồng Lĩnh	13
13_43	Nghi Xuân	13
13_44	Phúc Trạch	13
13_45	Sông Trí	13
13_46	Sơn Giang	13
13_47	Sơn Hồng	13
13_48	Sơn Kim 1	13
13_49	Sơn Kim 2	13
13_50	Sơn Tây	13
13_51	Sơn Tiến	13
13_52	Thạch Hà	13
13_53	Thạch Khê	13
13_54	Thạch Lạc	13
13_55	Thạch Xuân	13
13_56	Thành Sen	13
13_57	Thiên Cầm	13
13_58	Thượng Đức	13
13_59	Tiên Điền	13
13_60	Toàn Lưu	13
13_61	Trần Phú	13
13_62	Trường Lưu	13
13_63	Tùng Lộc	13
13_64	Tứ Mỹ	13
13_65	Việt Xuyên	13
13_66	Vũ Quang	13
13_67	Vũng Áng	13
13_68	Xuân Lộc	13
13_69	Yên Hòa	13
14_1	Ái Quốc	14
14_2	An Biên	14
14_3	An Dương	14
14_4	An Hải	14
14_5	An Hưng	14
14_6	An Khánh	14
14_7	An Lão	14
14_8	An Phong	14
14_9	An Phú	14
14_10	An Quang	14
14_11	An Thành	14
14_12	An Trường	14
14_13	Bạch Đằng	14
14_14	Bạch Long Vĩ	14
14_15	Bắc An Phụ	14
14_16	Bắc Thanh Miện	14
14_17	Bình Giang	14
14_18	Cát Hải	14
14_19	Cẩm Giang	14
14_20	Cẩm Giàng	14
14_21	Chấn Hưng	14
14_22	Chí Linh	14
14_23	Chí Minh	14
14_24	Chu Văn An	14
14_25	Dương Kinh	14
14_26	Đại Sơn	14
14_27	Đồ Sơn	14
14_28	Đông Hải	14
14_29	Đường An	14
14_30	Gia Lộc	14
14_31	Gia Phúc	14
14_32	Gia Viên	14
14_33	Hà Bắc	14
14_34	Hà Đông	14
14_35	Hà Nam	14
14_36	Hà Tây	14
14_37	Hải An	14
14_38	Hải Dương	14
14_39	Hải Hưng	14
14_40	Hòa Bình	14
14_41	Hồng An	14
14_42	Hồng Bàng	14
14_43	Hồng Châu	14
14_44	Hợp Tiến	14
14_45	Hùng Thắng	14
14_46	Hưng Đạo	14
14_47	Kẻ Sặt	14
14_48	Khúc Thừa Dụ	14
14_49	Kiến An	14
14_50	Kiến Hải	14
14_51	Kiến Hưng	14
14_52	Kiến Minh	14
14_53	Kiến Thụy	14
14_54	Kim Thành	14
14_55	Kinh Môn	14
14_56	Lạc Phượng	14
14_57	Lai Khê	14
14_58	Lê Chân	14
14_59	Lê Đại Hành	14
14_60	Lê Ích Mộc	14
14_61	Lê Thanh Nghị	14
14_62	Lưu Kiếm	14
14_63	Mao Điền	14
14_64	Nam An Phụ	14
14_65	Nam Đồ Sơn	14
14_66	Nam Đồng	14
14_67	Nam Sách	14
14_68	Nam Thanh Miện	14
14_69	Nam Triệu	14
14_70	Nghi Dương	14
14_71	Ngô Quyền	14
14_72	Nguyễn Bỉnh Khiêm	14
14_73	Nguyễn Đại Năng	14
14_74	Nguyên Giáp	14
14_75	Nguyễn Lương Bằng	14
14_76	Nguyễn Trãi	14
14_77	Nhị Chiểu	14
14_78	Ninh Giang	14
14_79	Phạm Sư Mạnh	14
14_80	Phù Liễn	14
14_81	Phú Thái	14
14_82	Quyết Thắng	14
14_83	Tân An	14
14_84	Tân Hưng	14
14_85	Tân Kỳ	14
14_86	Tân Minh	14
14_87	Thạch Khôi	14
14_88	Thái Tân	14
14_89	Thành Đông	14
14_90	Thanh Hà	14
14_91	Thanh Miện	14
14_92	Thiên Hương	14
14_93	Thủy Nguyên	14
14_94	Thượng Hồng	14
14_95	Tiên Lãng	14
14_96	Tiên Minh	14
14_97	Trần Hưng Đạo	14
14_98	Trần Liễu	14
14_99	Trần Nhân Tông	14
14_100	Trần Phú	14
14_101	Trường Tân	14
14_102	Tuệ Tĩnh	14
14_103	Tứ Kỳ	14
14_104	Tứ Minh	14
14_105	Việt Hòa	14
14_106	Việt Khê	14
14_107	Vĩnh Am	14
14_108	Vĩnh Bảo	14
14_109	Vĩnh Hải	14
14_110	Vĩnh Hòa	14
14_111	Vĩnh Lại	14
14_112	Vĩnh Thịnh	14
14_113	Vĩnh Thuận	14
14_114	Yết Kiêu	14
15_1	A Lưới 1	15
15_2	A Lưới 2	15
15_3	A Lưới 3	15
15_4	A Lưới 4	15
15_5	A Lưới 5	15
15_6	An Cựu	15
15_7	Bình Điền	15
15_8	Chân Mây - Lăng Cô	15
15_9	Dương Nỗ	15
15_10	Đan Điền	15
15_11	Hóa Châu	15
15_12	Hưng Lộc	15
15_13	Hương An	15
15_14	Hương Thủy	15
15_15	Hương Trà	15
15_16	Khe Tre	15
15_17	Kim Long	15
15_18	Kim Trà	15
15_19	Long Quảng	15
15_20	Lộc An	15
15_21	Mỹ Thượng	15
15_22	Nam Đông	15
15_23	Phong Dinh	15
15_24	Phong Điền	15
15_25	Phong Phú	15
15_26	Phong Quảng	15
15_27	Phong Thái	15
15_28	Phú Bài	15
15_29	Phú Hồ	15
15_30	Phú Lộc	15
15_31	Phú Vang	15
15_32	Phú Vinh	15
15_33	Phú Xuân	15
15_34	Quảng Điền	15
15_35	Thanh Thủy	15
15_36	Thuận An	15
15_37	Thuận Hóa	15
15_38	Thủy Xuân	15
15_39	Vinh Lộc	15
15_40	Vỹ Dạ	15
16_1	A Sào	16
16_2	Ái Quốc	16
16_3	Ân Thi	16
16_4	Bắc Đông Hưng	16
16_5	Bắc Đông Quan	16
16_6	Bắc Thái Ninh	16
16_7	Bắc Thụy Anh	16
16_8	Bắc Tiên Hưng	16
16_9	Bình Định	16
16_10	Bình Nguyên	16
16_11	Bình Thanh	16
16_12	Châu Ninh	16
16_13	Chí Minh	16
16_14	Diên Hà	16
16_15	Đại Đồng	16
16_16	Đoàn Đào	16
16_17	Đồng Bằng	16
16_18	Đồng Châu	16
16_19	Đông Hưng	16
16_20	Đông Quan	16
16_21	Đông Thái Ninh	16
16_22	Đông Thụy Anh	16
16_23	Đông Tiền Hải	16
16_24	Đông Tiên Hưng	16
16_25	Đức Hợp	16
16_26	Đường Hào	16
16_27	Hiệp Cường	16
16_28	Hoàn Long	16
16_29	Hoàng Hoa Thám	16
16_30	Hồng Châu	16
16_31	Hồng Minh	16
16_32	Hồng Quang	16
16_33	Hồng Vũ	16
16_34	Hưng Hà	16
16_35	Hưng Phú	16
16_36	Khoái Châu	16
16_37	Kiến Xương	16
16_38	Lạc Đạo	16
16_39	Lê Lợi	16
16_40	Lê Quý Đôn	16
16_41	Long Hưng	16
16_42	Lương Bằng	16
16_43	Mễ Sở	16
16_44	Minh Thọ	16
16_45	Mỹ Hào	16
16_46	Nam Cường	16
16_47	Nam Đông Hưng	16
16_48	Nam Thái Ninh	16
16_49	Nam Thụy Anh	16
16_50	Nam Tiền Hải	16
16_51	Nam Tiên Hưng	16
16_52	Nghĩa Dân	16
16_53	Nghĩa Trụ	16
16_54	Ngọc Lâm	16
16_55	Nguyễn Du	16
16_56	Nguyễn Trãi	16
16_57	Nguyễn Văn Linh	16
16_58	Ngự Thiên	16
16_59	Như Quỳnh	16
16_60	Phạm Ngũ Lão	16
16_61	Phố Hiến	16
16_62	Phụ Dực	16
16_63	Phụng Công	16
16_64	Quang Hưng	16
16_65	Quang Lịch	16
16_66	Quỳnh An	16
16_67	Quỳnh Phụ	16
16_68	Sơn Nam	16
16_69	Tân Hưng	16
16_70	Tân Thuận	16
16_71	Tân Tiến	16
16_72	Tây Thái Ninh	16
16_73	Tây Thụy Anh	16
16_74	Tây Tiền Hải	16
16_75	Thái Bình	16
16_76	Thái Ninh	16
16_77	Thái Thụy	16
16_78	Thần Khê	16
16_79	Thụy Anh	16
16_80	Thư Trì	16
16_81	Thư Vũ	16
16_82	Thượng Hồng	16
16_83	Tiền Hải	16
16_84	Tiên Hoa	16
16_85	Tiên Hưng	16
16_86	Tiên La	16
16_87	Tiên Lữ	16
16_88	Tiên Tiến	16
16_89	Tống Trân	16
16_90	Trà Giang	16
16_91	Trà Lý	16
16_92	Trần Hưng Đạo	16
16_93	Trần Lãm	16
16_94	Triệu Việt Vương	16
16_95	Vạn Xuân	16
16_96	Văn Giang	16
16_97	Việt Tiến	16
16_98	Việt Yên	16
16_99	Vũ Phúc	16
16_100	Vũ Quý	16
16_101	Vũ Thư	16
16_102	Vũ Tiên	16
16_103	Xuân Trúc	16
16_104	Yên Mỹ	16
17_1	Anh Dũng	17
17_2	Ba Ngòi	17
17_3	Bác Ái	17
17_4	Bác Ái Đông	17
17_5	Bác Ái Tây	17
17_6	Bảo An	17
17_7	Bắc Cam Ranh	17
17_8	Bắc Khánh Vĩnh	17
17_9	Bắc Nha Trang	17
17_10	Bắc Ninh Hòa	17
17_11	Cà Ná	17
17_12	Cam An	17
17_13	Cam Hiệp	17
17_14	Cam Lâm	17
17_15	Cam Linh	17
17_16	Cam Ranh	17
17_17	Công Hải	17
17_18	Diên Điền	17
17_19	Diên Khánh	17
17_20	Diên Lạc	17
17_21	Diên Lâm	17
17_22	Diên Thọ	17
17_23	Đại Lãnh	17
17_24	Đô Vinh	17
17_25	Đông Hải	17
17_26	Đông Khánh Sơn	17
17_27	Đông Ninh Hòa	17
17_28	Hòa Thắng	17
17_29	Hòa Trí	17
17_30	Khánh Sơn	17
17_31	Khánh Vĩnh	17
17_32	Lâm Sơn	17
17_33	Mỹ Sơn	17
17_34	Nam Cam Ranh	17
17_35	Nam Khánh Vĩnh	17
17_36	Nam Nha Trang	17
17_37	Nam Ninh Hòa	17
17_38	Nha Trang	17
17_39	Ninh Chử	17
17_40	Ninh Hải	17
17_41	Ninh Hòa	17
17_42	Ninh Phước	17
17_43	Ninh Sơn	17
17_44	Phan Rang	17
17_45	Phước Dinh	17
17_46	Phước Hà	17
17_47	Phước Hậu	17
17_48	Phước Hữu	17
17_49	Suối Dầu	17
17_50	Suối Hiệp	17
17_51	Tân Định	17
17_52	Tây Khánh Sơn	17
17_53	Tây Khánh Vĩnh	17
17_54	Tây Nha Trang	17
17_55	Tây Ninh Hòa	17
17_56	Thuận Bắc	17
17_57	Thuận Nam	17
17_58	Trung Khánh Vĩnh	17
17_59	Trường Sa	17
17_60	Tu Bông	17
17_61	Vạn Hưng	17
17_62	Vạn Ninh	17
17_63	Vạn Thắng	17
17_64	Vĩnh Hải	17
17_65	Xuân Hải	17
18_1	Bản Bo	18
18_2	Bình Lư	18
18_3	Bum Nưa	18
18_4	Bum Tở	18
18_5	Dào San	18
18_6	Đoàn Kết	18
18_7	Hồng Thu	18
18_8	Hua Bum	18
18_9	Khoen On	18
18_10	Khổng Lào	18
18_11	Khun Há	18
18_12	Lê Lợi	18
18_13	Mù Cả	18
18_14	Mường Khoa	18
18_15	Mường Kim	18
18_16	Mường Mô	18
18_17	Mường Tè	18
18_18	Mường Than	18
18_19	Nậm Cuổi	18
18_20	Nậm Hàng	18
18_21	Nậm Mạ	18
18_22	Nậm Sỏ	18
18_23	Nậm Tăm	18
18_24	Pa Tần	18
18_25	Pa Ủ	18
18_26	Pắc Ta	18
18_27	Phong Thổ	18
18_28	Pu Sam Cáp	18
18_29	Sì Lở Lầu	18
18_30	Sìn Hồ	18
18_31	Sin Suối Hồ	18
18_32	Tả Lèng	18
18_33	Tà Tổng	18
18_34	Tân Phong	18
18_35	Tân Uyên	18
18_36	Than Uyên	18
18_37	Thu Lũm	18
18_38	Tủa Sín Chải	18
19_1	Ba Sơn	19
19_2	Bắc Sơn	19
19_3	Bằng Mạc	19
19_4	Bình Gia	19
19_5	Cai Kinh	19
19_6	Cao Lộc	19
19_7	Châu Sơn	19
19_8	Chi Lăng	19
19_9	Chiến Thắng	19
19_10	Công Sơn	19
19_11	Điềm He	19
19_12	Đình Lập	19
19_13	Đoàn Kết	19
19_14	Đồng Đăng	19
19_15	Đông Kinh	19
19_16	Hoa Thám	19
19_17	Hoàng Văn Thụ	19
19_18	Hội Hoan	19
19_19	Hồng Phong	19
19_20	Hưng Vũ	19
19_21	Hữu Liên	19
19_22	Hữu Lũng	19
19_23	Kháng Chiến	19
19_24	Khánh Khê	19
19_25	Khuất Xá	19
19_26	Kiên Mộc	19
19_27	Kỳ Lừa	19
19_28	Lộc Bình	19
19_29	Lợi Bác	19
19_30	Lương Văn Tri	19
19_31	Mẫu Sơn	19
19_32	Na Dương	19
19_33	Na Sầm	19
19_34	Nhân Lý	19
19_35	Nhất Hòa	19
19_36	Quan Sơn	19
19_37	Quốc Khánh	19
19_38	Quốc Việt	19
19_39	Quý Hòa	19
19_40	Tam Thanh	19
19_41	Tân Đoàn	19
19_42	Tân Thành	19
19_43	Tân Tiến	19
19_44	Tân Tri	19
19_45	Tân Văn	19
19_46	Thái Bình	19
19_47	Thất Khê	19
19_48	Thiện Hòa	19
19_49	Thiện Long	19
19_50	Thiện Tân	19
19_51	Thiện Thuật	19
19_52	Thống Nhất	19
19_53	Thụy Hùng	19
19_54	Tràng Định	19
19_55	Tri Lễ	19
19_56	Tuấn Sơn	19
19_57	Vạn Linh	19
19_58	Văn Lãng	19
19_59	Văn Quan	19
19_60	Vân Nham	19
19_61	Vũ Lăng	19
19_62	Vũ Lễ	19
19_63	Xuân Dương	19
19_64	Yên Bình	19
19_65	Yên Phúc	19
20_1	A Mú Sung	20
20_2	Âu Lâu	20
20_3	Bản Hồ	20
20_4	Bản Lầu	20
20_5	Bản Liền	20
20_6	Bản Xèo	20
20_7	Bảo Ái	20
20_8	Bảo Hà	20
20_9	Bảo Nhai	20
20_10	Bảo Thắng	20
20_11	Bảo Yên	20
20_12	Bát Xát	20
20_13	Bắc Hà	20
20_14	Cam Đường	20
20_15	Cảm Nhân	20
20_16	Cao Sơn	20
20_17	Cát Thịnh	20
20_18	Cầu Thia	20
20_19	Chấn Thịnh	20
20_20	Châu Quế	20
20_21	Chế Tạo	20
20_22	Chiềng Ken	20
20_23	Cốc Lầu	20
20_24	Cốc San	20
20_25	Dền Sáng	20
20_26	Dương Quỳ	20
20_27	Đông Cuông	20
20_28	Gia Hội	20
20_29	Gia Phú	20
20_30	Hạnh Phúc	20
20_31	Hợp Thành	20
20_32	Hưng Khánh	20
20_33	Khánh Hòa	20
20_34	Khánh Yên	20
20_35	Khao Mang	20
20_36	Lào Cai	20
20_37	Lao Chải	20
20_38	Lâm Giang	20
20_39	Lâm Thượng	20
20_40	Liên Sơn	20
20_41	Lục Yên	20
20_42	Lùng Phình	20
20_43	Lương Thịnh	20
20_44	Mậu A	20
20_45	Minh Lương	20
20_46	Mỏ Vàng	20
20_47	Mù Cang Chải	20
20_48	Mường Bo	20
20_49	Mường Hum	20
20_50	Mường Khương	20
20_51	Mường Lai	20
20_52	Nam Cường	20
20_53	Nậm Chày	20
20_54	Nậm Có	20
20_55	Nậm Xé	20
20_56	Nghĩa Đô	20
20_57	Nghĩa Lộ	20
20_58	Nghĩa Tâm	20
20_59	Ngũ Chỉ Sơn	20
20_60	Pha Long	20
20_61	Phình Hồ	20
20_62	Phong Dụ Hạ	20
20_63	Phong Dụ Thượng	20
20_64	Phong Hải	20
20_65	Phúc Khánh	20
20_66	Phúc Lợi	20
20_67	Púng Luông	20
20_68	Quy Mông	20
20_69	Sa Pa	20
20_70	Si Ma Cai	20
20_71	Sín Chéng	20
20_72	Sơn Lương	20
20_73	Tả Củ Tỷ	20
20_74	Tả Phìn	20
20_75	Tả Van	20
20_76	Tà Xi Láng	20
20_77	Tằng Loỏng	20
20_78	Tân Hợp	20
20_79	Tân Lĩnh	20
20_80	Thác Bà	20
20_81	Thượng Bằng La	20
20_82	Thượng Hà	20
20_83	Trạm Tấu	20
20_84	Trấn Yên	20
20_85	Trịnh Tường	20
20_86	Trung Tâm	20
20_87	Tú Lệ	20
20_88	Văn Bàn	20
20_89	Văn Chấn	20
20_90	Văn Phú	20
20_91	Việt Hồng	20
20_92	Võ Lao	20
20_93	Xuân Ái	20
20_94	Xuân Hòa	20
20_95	Xuân Quang	20
20_96	Y Tý	20
20_97	Yên Bái	20
20_98	Yên Bình	20
20_99	Yên Thành	20
21_1	1 Bảo Lộc	21
21_2	2 Bảo Lộc	21
21_3	3 Bảo Lộc	21
21_4	B’Lao	21
21_5	Bảo Lâm 1	21
21_6	Bảo Lâm 2	21
21_7	Bảo Lâm 3	21
21_8	Bảo Lâm 4	21
21_9	Bảo Lâm 5	21
21_10	Bảo Thuận	21
21_11	Bắc Bình	21
21_12	Bắc Gia Nghĩa	21
21_13	Bắc Ruộng	21
21_14	Bình Thuận	21
21_15	Cam Ly - Đà Lạt	21
21_16	Cát Tiên	21
21_17	Cát Tiên 2	21
21_18	Cát Tiên 3	21
21_19	Cư Jút	21
21_20	D’Ran	21
21_21	Di Linh	21
21_22	Đạ Huoai	21
21_23	Đạ Huoai 2	21
21_24	Đạ Huoai 3	21
21_25	Đạ Tẻh	21
21_26	Đạ Tẻh 2	21
21_27	Đạ Tẻh 3	21
21_28	Đam Rông 1	21
21_29	Đam Rông 2	21
21_30	Đam Rông 3	21
21_31	Đam Rông 4	21
21_32	Đắk Mil	21
21_33	Đắk Sắk	21
21_34	Đắk Song	21
21_35	Đắk Wil	21
21_36	Đinh Trang Thượng	21
21_37	Đinh Văn Lâm Hà	21
21_38	Đông Gia Nghĩa	21
21_39	Đông Giang	21
21_40	Đồng Kho	21
21_41	Đơn Dương	21
21_42	Đức An	21
21_43	Đức Lập	21
21_44	Đức Linh	21
21_45	Đức Trọng	21
21_46	Gia Hiệp	21
21_47	Hải Ninh	21
21_48	Hàm Kiệm	21
21_49	Hàm Liêm	21
21_50	Hàm Tân	21
21_51	Hàm Thạnh	21
21_52	Hàm Thắng	21
21_53	Hàm Thuận	21
21_54	Hàm Thuận Bắc	21
21_55	Hàm Thuận Nam	21
21_56	Hiệp Thạnh	21
21_57	Hòa Bắc	21
21_58	Hòa Ninh	21
21_59	Hòa Thắng	21
21_60	Hoài Đức	21
21_61	Hồng Sơn	21
21_62	Hồng Thái	21
21_63	Ka Đô	21
21_64	Kiến Đức	21
21_65	Krông Nô	21
21_66	La Dạ	21
21_67	La Gi	21
21_68	Lạc Dương	21
21_69	Lang Biang - Đà Lạt	21
21_70	Lâm Viên - Đà Lạt	21
21_71	Liên Hương	21
21_72	Lương Sơn	21
21_73	Mũi Né	21
21_74	Nam Ban Lâm Hà	21
21_75	Nam Dong	21
21_76	Nam Đà	21
21_77	Nam Gia Nghĩa	21
21_78	Nam Hà Lâm Hà	21
21_79	Nam Thành	21
21_80	Nâm Nung	21
21_81	Nghị Đức	21
21_82	Nhân Cơ	21
21_83	Ninh Gia	21
21_84	Phan Rí Cửa	21
21_85	Phan Sơn	21
21_86	Phan Thiết	21
21_87	Phú Quý	21
21_88	Phú Sơn Lâm Hà	21
21_89	Phú Thủy	21
21_90	Phúc Thọ Lâm Hà	21
21_91	Phước Hội	21
21_92	Quảng Hòa	21
21_93	Quảng Khê	21
21_94	Quảng Lập	21
21_95	Quảng Phú	21
21_96	Quảng Sơn	21
21_97	Quảng Tân	21
21_98	Quảng Tín	21
21_99	Quảng Trực	21
21_100	Sông Lũy	21
21_101	Sơn Điền	21
21_102	Sơn Mỹ	21
21_103	Suối Kiết	21
21_104	Tà Đùng	21
21_105	Tà Hine	21
21_106	Tà Năng	21
21_107	Tánh Linh	21
21_108	Tân Hà Lâm Hà	21
21_109	Tân Hải	21
21_110	Tân Hội	21
21_111	Tân Lập	21
21_112	Tân Minh	21
21_113	Tân Thành	21
21_114	Thuận An	21
21_115	Thuận Hạnh	21
21_116	Tiến Thành	21
21_117	Trà Tân	21
21_118	Trường Xuân	21
21_119	Tuy Đức	21
21_120	Tuy Phong	21
21_121	Tuyên Quang	21
21_122	Vĩnh Hảo	21
21_123	Xuân Hương - Đà Lạt	21
21_124	Xuân Trường - Đà Lạt	21
22_1	An Châu	22
22_2	Anh Sơn	22
22_3	Anh Sơn Đông	22
22_4	Bạch Hà	22
22_5	Bạch Ngọc	22
22_6	Bắc Lý	22
22_7	Bích Hào	22
22_8	Bình Chuẩn	22
22_9	Bình Minh	22
22_10	Cam Phục	22
22_11	Cát Ngạn	22
22_12	Châu Bình	22
22_13	Châu Hồng	22
22_14	Châu Khê	22
22_15	Châu Lộc	22
22_16	Châu Tiến	22
22_17	Chiêu Lưu	22
22_18	Con Cuông	22
22_19	Cửa Lò	22
22_20	Diễn Châu	22
22_21	Đại Đồng	22
22_22	Đại Huệ	22
22_23	Đô Lương	22
22_24	Đông Hiếu	22
22_25	Đông Lộc	22
22_26	Đông Thành	22
22_27	Đức Châu	22
22_28	Giai Lạc	22
22_29	Giai Xuân	22
22_30	Hải Châu	22
22_31	Hải Lộc	22
22_32	Hạnh Lâm	22
22_33	Hoa Quân	22
22_34	Hoàng Mai	22
22_35	Hợp Minh	22
22_36	Hùng Chân	22
22_37	Hùng Châu	22
22_38	Huồi Tụ	22
22_39	Hưng Nguyên	22
22_40	Hưng Nguyên Nam	22
22_41	Hữu Khuông	22
22_42	Hữu Kiệm	22
22_43	Keng Đu	22
22_44	Kim Bảng	22
22_45	Kim Liên	22
22_46	Lam Thành	22
22_47	Lượng Minh	22
22_48	Lương Sơn	22
22_49	Mậu Thạch	22
22_50	Minh Châu	22
22_51	Minh Hợp	22
22_52	Môn Sơn	22
22_53	Mường Chọng	22
22_54	Mường Ham	22
22_55	Mường Lống	22
22_56	Mường Quàng	22
22_57	Mường Típ	22
22_58	Mường Xén	22
22_59	Mỹ Lý	22
22_60	Na Loi	22
22_61	Na Ngoi	22
22_62	Nam Đàn	22
22_63	Nậm Cắn	22
22_64	Nga My	22
22_65	Nghi Lộc	22
22_66	Nghĩa Đàn	22
22_67	Nghĩa Đồng	22
22_68	Nghĩa Hành	22
22_69	Nghĩa Hưng	22
22_70	Nghĩa Khánh	22
22_71	Nghĩa Lâm	22
22_72	Nghĩa Lộc	22
22_73	Nghĩa Mai	22
22_74	Nghĩa Thọ	22
22_75	Nhân Hòa	22
22_76	Nhôn Mai	22
22_77	Phúc Lộc	22
22_78	Quan Thành	22
22_79	Quảng Châu	22
22_80	Quang Đồng	22
22_81	Quế Phong	22
22_82	Quỳ Châu	22
22_83	Quỳ Hợp	22
22_84	Quỳnh Anh	22
22_85	Quỳnh Lưu	22
22_86	Quỳnh Mai	22
22_87	Quỳnh Phú	22
22_88	Quỳnh Sơn	22
22_89	Quỳnh Tam	22
22_90	Quỳnh Thắng	22
22_91	Quỳnh Văn	22
22_92	Sơn Lâm	22
22_93	Tam Đồng	22
22_94	Tam Hợp	22
22_95	Tam Quang	22
22_96	Tam Thái	22
22_97	Tân An	22
22_98	Tân Châu	22
22_99	Tân Kỳ	22
22_100	Tân Mai	22
22_101	Tân Phú	22
22_102	Tây Hiếu	22
22_103	Thái Hòa	22
22_104	Thành Bình Thọ	22
22_105	Thành Vinh	22
22_106	Thần Lĩnh	22
22_107	Thiên Nhẫn	22
22_108	Thông Thụ	22
22_109	Thuần Trung	22
22_110	Tiên Đồng	22
22_111	Tiền Phong	22
22_112	Tri Lễ	22
22_113	Trung Lộc	22
22_114	Trường Vinh	22
22_115	Tương Dương	22
22_116	Vạn An	22
22_117	Văn Hiến	22
22_118	Văn Kiều	22
22_119	Vân Du	22
22_120	Vân Tụ	22
22_121	Vinh Hưng	22
22_122	Vinh Lộc	22
22_123	Vinh Phú	22
22_124	Vĩnh Tường	22
22_125	Xuân Lâm	22
22_126	Yên Hòa	22
22_127	Yên Na	22
22_128	Yên Thành	22
22_129	Yên Trung	22
22_130	Yên Xuân	22
23_1	Bắc Lý	23
23_2	Bình An	23
23_3	Bình Giang	23
23_4	Bình Lục	23
23_5	Bình Minh	23
23_6	Bình Mỹ	23
23_7	Bình Sơn	23
23_8	Cát Thành	23
23_9	Chất Bình	23
23_10	Châu Sơn	23
23_11	Cổ Lễ	23
23_12	Cúc Phương	23
23_13	Duy Hà	23
23_14	Duy Tân	23
23_15	Duy Tiên	23
23_16	Đại Hoàng	23
23_17	Định Hóa	23
23_18	Đông A	23
23_19	Đông Hoa Lư	23
23_20	Đồng Thái	23
23_21	Đồng Thịnh	23
23_22	Đồng Văn	23
23_23	Gia Hưng	23
23_24	Gia Lâm	23
23_25	Gia Phong	23
23_26	Gia Trấn	23
23_27	Gia Tường	23
23_28	Gia Vân	23
23_29	Gia Viễn	23
23_30	Giao Bình	23
23_31	Giao Hòa	23
23_32	Giao Hưng	23
23_33	Giao Minh	23
23_34	Giao Ninh	23
23_35	Giao Phúc	23
23_36	Giao Thủy	23
23_37	Hà Nam	23
23_38	Hải An	23
23_39	Hải Anh	23
23_40	Hải Hậu	23
23_41	Hải Hưng	23
23_42	Hải Quang	23
23_43	Hải Thịnh	23
23_44	Hải Tiến	23
23_45	Hải Xuân	23
23_46	Hiển Khánh	23
23_47	Hoa Lư	23
23_48	Hồng Phong	23
23_49	Hồng Quang	23
23_50	Khánh Hội	23
23_51	Khánh Nhạc	23
23_52	Khánh Thiện	23
23_53	Khánh Trung	23
23_54	Kim Bảng	23
23_55	Kim Đông	23
23_56	Kim Sơn	23
23_57	Kim Thanh	23
23_58	Lai Thành	23
23_59	Lê Hồ	23
23_60	Liêm Hà	23
23_61	Liêm Tuyền	23
23_62	Liên Minh	23
23_63	Lý Nhân	23
23_64	Lý Thường Kiệt	23
23_65	Minh Tân	23
23_66	Minh Thái	23
23_67	Mỹ Lộc	23
23_68	Nam Định	23
23_69	Nam Đồng	23
23_70	Nam Hoa Lư	23
23_71	Nam Hồng	23
23_72	Nam Lý	23
23_73	Nam Minh	23
23_74	Nam Ninh	23
23_75	Nam Trực	23
23_76	Nam Xang	23
23_77	Nghĩa Hưng	23
23_78	Nghĩa Lâm	23
23_79	Nghĩa Sơn	23
23_80	Nguyễn Úy	23
23_81	Nhân Hà	23
23_82	Nho Quan	23
23_83	Ninh Cường	23
23_84	Ninh Giang	23
23_85	Phát Diệm	23
23_86	Phong Doanh	23
23_87	Phú Long	23
23_88	Phủ Lý	23
23_89	Phú Sơn	23
23_90	Phù Vân	23
23_91	Quang Hưng	23
23_92	Quang Thiện	23
23_93	Quỹ Nhất	23
23_94	Quỳnh Lưu	23
23_95	Rạng Đông	23
23_96	Tam Chúc	23
23_97	Tam Điệp	23
23_98	Tân Minh	23
23_99	Tân Thanh	23
23_100	Tây Hoa Lư	23
23_101	Thanh Bình	23
23_102	Thanh Lâm	23
23_103	Thanh Liêm	23
23_104	Thành Nam	23
23_105	Thanh Sơn	23
23_106	Thiên Trường	23
23_107	Tiên Sơn	23
23_108	Trần Thương	23
23_109	Trung Sơn	23
23_110	Trực Ninh	23
23_111	Trường Thi	23
23_112	Vạn Thắng	23
23_113	Vị Khê	23
23_114	Vĩnh Trụ	23
23_115	Vụ Bản	23
23_116	Vũ Dương	23
23_117	Xuân Giang	23
23_118	Xuân Hồng	23
23_119	Xuân Hưng	23
23_120	Xuân Trường	23
23_121	Ý Yên	23
23_122	Yên Cường	23
23_123	Yên Đồng	23
23_124	Yên Khánh	23
23_125	Yên Mạc	23
23_126	Yên Mô	23
23_127	Yên Sơn	23
23_128	Yên Thắng	23
23_129	Yên Từ	23
24_1	An Bình	24
24_2	An Nghĩa	24
24_3	Âu Cơ	24
24_4	Bản Nguyên	24
24_5	Bao La	24
24_6	Bằng Luân	24
24_7	Bình Nguyên	24
24_8	Bình Phú	24
24_9	Bình Tuyền	24
24_10	Bình Xuyên	24
24_11	Cao Dương	24
24_12	Cao Phong	24
24_13	Cao Sơn	24
24_14	Cẩm Khê	24
24_15	Chân Mộng	24
24_16	Chí Đám	24
24_17	Chí Tiên	24
24_18	Cự Đồng	24
24_19	Dân Chủ	24
24_20	Dũng Tiến	24
24_21	Đà Bắc	24
24_22	Đại Đình	24
24_23	Đại Đồng	24
24_24	Đan Thượng	24
24_25	Đạo Trù	24
24_26	Đào Xá	24
24_27	Đoan Hùng	24
24_28	Đồng Lương	24
24_29	Đông Thành	24
24_30	Đức Nhàn	24
24_31	Hạ Hòa	24
24_32	Hải Lựu	24
24_33	Hiền Lương	24
24_34	Hiền Quan	24
24_35	Hòa Bình	24
24_36	Hoàng An	24
24_37	Hoàng Cương	24
24_38	Hội Thịnh	24
24_39	Hợp Kim	24
24_40	Hợp Lý	24
24_41	Hùng Việt	24
24_42	Hương Cần	24
24_43	Hy Cương	24
24_44	Khả Cửu	24
24_45	Kim Bôi	24
24_46	Kỳ Sơn	24
24_47	Lạc Lương	24
24_48	Lạc Sơn	24
24_49	Lạc Thủy	24
24_50	Lai Đồng	24
24_51	Lâm Thao	24
24_52	Lập Thạch	24
24_53	Liên Châu	24
24_54	Liên Hòa	24
24_55	Liên Minh	24
24_56	Liên Sơn	24
24_57	Long Cốc	24
24_58	Lương Sơn	24
24_59	Mai Châu	24
24_60	Mai Hạ	24
24_61	Minh Đài	24
24_62	Minh Hòa	24
24_63	Mường Bi	24
24_64	Mường Động	24
24_65	Mường Hoa	24
24_66	Mường Thàng	24
24_67	Mường Vang	24
24_68	Nật Sơn	24
24_69	Ngọc Sơn	24
24_70	Nguyệt Đức	24
24_71	Nhân Nghĩa	24
24_72	Nông Trang	24
24_73	Pà Cò	24
24_74	Phong Châu	24
24_75	Phú Khê	24
24_76	Phú Mỹ	24
24_77	Phù Ninh	24
24_78	Phú Thọ	24
24_79	Phúc Yên	24
24_80	Phùng Nguyên	24
24_81	Quảng Yên	24
24_82	Quy Đức	24
24_83	Quyết Thắng	24
24_84	Sông Lô	24
24_85	Sơn Đông	24
24_86	Sơn Lương	24
24_87	Tam Dương	24
24_88	Tam Dương Bắc	24
24_89	Tam Đảo	24
24_90	Tam Hồng	24
24_91	Tam Nông	24
24_92	Tam Sơn	24
24_93	Tân Hòa	24
24_94	Tân Lạc	24
24_95	Tân Mai	24
24_96	Tân Pheo	24
24_97	Tân Sơn	24
24_98	Tây Cốc	24
24_99	Tề Lỗ	24
24_100	Thái Hòa	24
24_101	Thanh Ba	24
24_102	Thanh Miếu	24
24_103	Thanh Sơn	24
24_104	Thanh Thủy	24
24_105	Thịnh Minh	24
24_106	Thọ Văn	24
24_107	Thổ Tang	24
24_108	Thống Nhất	24
24_109	Thu Cúc	24
24_110	Thung Nai	24
24_111	Thượng Cốc	24
24_112	Thượng Long	24
24_113	Tiên Lữ	24
24_114	Tiên Lương	24
24_115	Tiền Phong	24
24_116	Toàn Thắng	24
24_117	Trạm Thản	24
24_118	Trung Sơn	24
24_119	Tu Vũ	24
24_120	Vạn Xuân	24
24_121	Văn Lang	24
24_122	Văn Miếu	24
24_123	Vân Bán	24
24_124	Vân Phú	24
24_125	Vân Sơn	24
24_126	Việt Trì	24
24_127	Vĩnh An	24
24_128	Vĩnh Chân	24
24_129	Vĩnh Hưng	24
24_130	Vĩnh Phú	24
24_131	Vĩnh Phúc	24
24_132	Vĩnh Thành	24
24_133	Vĩnh Tường	24
24_134	Vĩnh Yên	24
24_135	Võ Miếu	24
24_136	Xuân Đài	24
24_137	Xuân Hòa	24
24_138	Xuân Lãng	24
24_139	Xuân Lũng	24
24_140	Xuân Viên	24
24_141	Yên Kỳ	24
24_142	Yên Lạc	24
24_143	Yên Lãng	24
24_144	Yên Lập	24
24_145	Yên Phú	24
24_146	Yên Sơn	24
24_147	Yên Thủy	24
24_148	Yên Trị	24
25_1	An Phú	25
25_2	Ba Dinh	25
25_3	Ba Động	25
25_4	Ba Gia	25
25_5	Ba Tô	25
25_6	Ba Tơ	25
25_7	Ba Vì	25
25_8	Ba Vinh	25
25_9	Ba Xa	25
25_10	Bình Chương	25
25_11	Bình Minh	25
25_12	Bình Sơn	25
25_13	Bờ Y	25
25_14	Cà Đam	25
25_15	Cẩm Thành	25
25_16	Dục Nông	25
25_17	Đăk Bla	25
25_18	Đăk Cấm	25
25_19	Đăk Hà	25
25_20	Đăk Kôi	25
25_21	Đăk Long	25
25_22	Đăk Mar	25
25_23	Đăk Môn	25
25_24	Đăk Pék	25
25_25	Đăk Plô	25
25_26	Đăk Pxi	25
25_27	Đăk Rơ Wa	25
25_28	Đăk Rve	25
25_29	Đăk Sao	25
25_30	Đăk Tô	25
25_31	Đăk Tờ Kan	25
25_32	Đăk Ui	25
25_33	Đặng Thùy Trâm	25
25_34	Đình Cương	25
25_35	Đông Sơn	25
25_36	Đông Trà Bồng	25
25_37	Đức Phổ	25
25_38	Ia Chim	25
25_39	Ia Đal	25
25_40	Ia Tơi	25
25_41	Khánh Cường	25
25_42	Kon Braih	25
25_43	Kon Đào	25
25_44	Kon Plông	25
25_45	Kon Tum	25
25_46	Lân Phong	25
25_47	Long Phụng	25
25_48	Lý Sơn	25
25_49	Măng Bút	25
25_50	Măng Đen	25
25_51	Măng Ri	25
25_52	Minh Long	25
25_53	Mỏ Cày	25
25_54	Mộ Đức	25
25_55	Mô Rai	25
25_56	Nghĩa Giang	25
25_57	Nghĩa Hành	25
25_58	Nghĩa Lộ	25
25_59	Ngọc Linh	25
25_60	Ngọk Bay	25
25_61	Ngọk Réo	25
25_62	Ngọk Tụ	25
25_63	Nguyễn Nghiêm	25
25_64	Phước Giang	25
25_65	Rờ Kơi	25
25_66	Sa Bình	25
25_67	Sa Huỳnh	25
25_68	Sa Loong	25
25_69	Sa Thầy	25
25_70	Sơn Hà	25
25_71	Sơn Hạ	25
25_72	Sơn Kỳ	25
25_73	Sơn Linh	25
25_74	Sơn Mai	25
25_75	Sơn Tây	25
25_76	Sơn Tây Hạ	25
25_77	Sơn Tây Thượng	25
25_78	Sơn Thủy	25
25_79	Sơn Tịnh	25
25_80	Tây Trà	25
25_81	Tây Trà Bồng	25
25_82	Thanh Bồng	25
25_83	Thiện Tín	25
25_84	Thọ Phong	25
25_85	Tịnh Khê	25
25_86	Trà Bồng	25
25_87	Trà Câu	25
25_88	Trà Giang	25
25_89	Trường Giang	25
25_90	Trương Quang Trọng	25
25_91	Tu Mơ Rông	25
25_92	Tư Nghĩa	25
25_93	Vạn Tường	25
25_94	Vệ Giang	25
25_95	Xốp	25
25_96	Ya Ly	25
26_1	An Sinh	26
26_2	Ba Chẽ	26
26_3	Bãi Cháy	26
26_4	Bình Khê	26
26_5	Bình Liêu	26
26_6	Cái Chiên	26
26_7	Cao Xanh	26
26_8	Cẩm Phả	26
26_9	Cô Tô	26
26_10	Cửa Ông	26
26_11	Đầm Hà	26
26_12	Điền Xá	26
26_13	Đông Mai	26
26_14	Đông Ngũ	26
26_15	Đông Triều	26
26_16	Đường Hoa	26
26_17	Hà An	26
26_18	Hà Lầm	26
26_19	Hạ Long	26
26_20	Hà Tu	26
26_21	Hải Hòa	26
26_22	Hải Lạng	26
26_23	Hải Ninh	26
26_24	Hải Sơn	26
26_25	Hiệp Hòa	26
26_26	Hoàng Quế	26
26_27	Hoành Bồ	26
26_28	Hoành Mô	26
26_29	Hồng Gai	26
26_30	Kỳ Thượng	26
26_31	Liên Hòa	26
26_32	Lục Hồn	26
26_33	Lương Minh	26
26_34	Mạo Khê	26
26_35	Móng Cái 1	26
26_36	Móng Cái 2	26
26_37	Móng Cái 3	26
26_38	Mông Dương	26
26_39	Phong Cốc	26
26_40	Quảng Đức	26
26_41	Quảng Hà	26
26_42	Quang Hanh	26
26_43	Quảng La	26
26_44	Quảng Tân	26
26_45	Quảng Yên	26
26_46	Thống Nhất	26
26_47	Tiên Yên	26
26_48	Tuần Châu	26
26_49	Uông Bí	26
26_50	Vàng Danh	26
26_51	Vân Đồn	26
26_52	Việt Hưng	26
26_53	Vĩnh Thực	26
26_54	Yên Tử	26
27_1	A Dơi	27
27_2	Ái Tử	27
27_3	Ba Đồn	27
27_4	Ba Lòng	27
27_5	Bắc Gianh	27
27_6	Bắc Trạch	27
27_7	Bến Hải	27
27_8	Bến Quan	27
27_9	Bố Trạch	27
27_10	Cam Hồng	27
27_11	Cam Lộ	27
27_12	Cồn Cỏ	27
27_13	Cồn Tiên	27
27_14	Cửa Tùng	27
27_15	Cửa Việt	27
27_16	Dân Hóa	27
27_17	Diên Sanh	27
27_18	Đakrông	27
27_19	Đông Hà	27
27_20	Đồng Hới	27
27_21	Đồng Lê	27
27_22	Đồng Sơn	27
27_23	Đồng Thuận	27
27_24	Đông Trạch	27
27_25	Gio Linh	27
27_26	Hải Lăng	27
27_27	Hiếu Giang	27
27_28	Hòa Trạch	27
27_29	Hoàn Lão	27
27_30	Hướng Hiệp	27
27_31	Hướng Lập	27
27_32	Hướng Phùng	27
27_33	Khe Sanh	27
27_34	Kim Điền	27
27_35	Kim Ngân	27
27_36	Kim Phú	27
27_37	La Lay	27
27_38	Lao Bảo	27
27_39	Lệ Ninh	27
27_40	Lệ Thủy	27
27_41	Lìa	27
27_42	Minh Hóa	27
27_43	Mỹ Thủy	27
27_44	Nam Ba Đồn	27
27_45	Nam Cửa Việt	27
27_46	Nam Đông Hà	27
27_47	Nam Gianh	27
27_48	Nam Hải Lăng	27
27_49	Nam Trạch	27
27_50	Ninh Châu	27
27_51	Phong Nha	27
27_52	Phú Trạch	27
27_53	Quảng Ninh	27
27_54	Quảng Trạch	27
27_55	Quảng Trị	27
27_56	Sen Ngư	27
27_57	Tà Rụt	27
27_58	Tân Gianh	27
27_59	Tân Lập	27
27_60	Tân Mỹ	27
27_61	Tân Thành	27
27_62	Thượng Trạch	27
27_63	Triệu Bình	27
27_64	Triệu Cơ	27
27_65	Triệu Phong	27
27_66	Trung Thuần	27
27_67	Trường Ninh	27
27_68	Trường Phú	27
27_69	Trường Sơn	27
27_70	Tuyên Bình	27
27_71	Tuyên Hóa	27
27_72	Tuyên Lâm	27
27_73	Tuyên Phú	27
27_74	Tuyên Sơn	27
27_75	Vĩnh Định	27
27_76	Vĩnh Hoàng	27
27_77	Vĩnh Linh	27
27_78	Vĩnh Thủy	27
28_1	Bắc Yên	28
28_2	Bình Thuận	28
28_3	Bó Sinh	28
28_4	Chiềng An	28
28_5	Chiềng Cơi	28
28_6	Chiềng Hặc	28
28_7	Chiềng Hoa	28
28_8	Chiềng Khoong	28
28_9	Chiềng Khương	28
28_10	Chiềng La	28
28_11	Chiềng Lao	28
28_12	Chiềng Mai	28
28_13	Chiềng Mung	28
28_14	Chiềng Sại	28
28_15	Chiềng Sinh	28
28_16	Chiềng Sơ	28
28_17	Chiềng Sơn	28
28_18	Chiềng Sung	28
28_19	Co Mạ	28
28_20	Đoàn Kết	28
28_21	Gia Phù	28
28_22	Huổi Một	28
28_23	Kim Bon	28
28_24	Long Hẹ	28
28_25	Lóng Phiêng	28
28_26	Lóng Sập	28
28_27	Mai Sơn	28
28_28	Mộc Châu	28
28_29	Mộc Sơn	28
28_30	Muổi Nọi	28
28_31	Mường Bám	28
28_32	Mường Bang	28
28_33	Mường Bú	28
28_34	Mường Chanh	28
28_35	Mường Chiên	28
28_36	Mường Cơi	28
28_37	Mường É	28
28_38	Mường Giôn	28
28_39	Mường Hung	28
28_40	Mường Khiêng	28
28_41	Mường La	28
28_42	Mường Lạn	28
28_43	Mường Lầm	28
28_44	Mường Lèo	28
28_45	Mường Sại	28
28_46	Nậm Lầu	28
28_47	Nậm Ty	28
28_48	Ngọc Chiến	28
28_49	Pắc Ngà	28
28_50	Phiêng Cằm	28
28_51	Phiêng Khoài	28
28_52	Phiêng Pằn	28
28_53	Phù Yên	28
28_54	Púng Bánh	28
28_55	Quỳnh Nhai	28
28_56	Song Khủa	28
28_57	Sông Mã	28
28_58	Sốp Cộp	28
28_59	Suối Tọ	28
28_60	Tà Hộc	28
28_61	Tạ Khoa	28
28_62	Tà Xùa	28
28_63	Tân Phong	28
28_64	Tân Yên	28
28_65	Thảo Nguyên	28
28_66	Thuận Châu	28
28_67	Tô Hiệu	28
28_68	Tô Múa	28
28_69	Tường Hạ	28
28_70	Vân Hồ	28
28_71	Vân Sơn	28
28_72	Xím Vàng	28
28_73	Xuân Nha	28
28_74	Yên Châu	28
28_75	Yên Sơn	28
29_1	An Lục Long	29
29_2	An Ninh	29
29_3	An Tịnh	29
29_4	Bến Cầu	29
29_5	Bến Lức	29
29_6	Bình Đức	29
29_7	Bình Hiệp	29
29_8	Bình Hòa	29
29_9	Bình Minh	29
29_10	Bình Thành	29
29_11	Cần Đước	29
29_12	Cần Giuộc	29
29_13	Cầu Khởi	29
29_14	Châu Thành	29
29_15	Dương Minh Châu	29
29_16	Đông Thành	29
29_17	Đức Hòa	29
29_18	Đức Huệ	29
29_19	Đức Lập	29
29_20	Gia Lộc	29
29_21	Gò Dầu	29
29_22	Hảo Đước	29
29_23	Hậu Nghĩa	29
29_24	Hậu Thạnh	29
29_25	Hiệp Hòa	29
29_26	Hòa Hội	29
29_27	Hòa Khánh	29
29_28	Hòa Thành	29
29_29	Hưng Điền	29
29_30	Hưng Thuận	29
29_31	Khánh Hậu	29
29_32	Khánh Hưng	29
29_33	Kiến Tường	29
29_34	Long An	29
29_35	Long Cang	29
29_36	Long Chữ	29
29_37	Long Hoa	29
29_38	Long Hựu	29
29_39	Long Thuận	29
29_40	Lộc Ninh	29
29_41	Lương Hòa	29
29_42	Mộc Hóa	29
29_43	Mỹ An	29
29_44	Mỹ Hạnh	29
29_45	Mỹ Lệ	29
29_46	Mỹ Lộc	29
29_47	Mỹ Quý	29
29_48	Mỹ Thạnh	29
29_49	Mỹ Yên	29
29_50	Nhơn Hòa Lập	29
29_51	Nhơn Ninh	29
29_52	Nhựt Tảo	29
29_53	Ninh Điền	29
29_54	Ninh Thạnh	29
29_55	Phước Chỉ	29
29_56	Phước Lý	29
29_57	Phước Thạnh	29
29_58	Phước Vinh	29
29_59	Phước Vĩnh Tây	29
29_60	Rạch Kiến	29
29_61	Tầm Vu	29
29_62	Tân An	29
29_63	Tân Biên	29
29_64	Tân Châu	29
29_65	Tân Đông	29
29_66	Tân Hòa	29
29_67	Tân Hội	29
29_68	Tân Hưng	29
29_69	Tân Lân	29
29_70	Tân Lập	29
29_71	Tân Long	29
29_72	Tân Ninh	29
29_73	Tân Phú	29
29_74	Tân Tập	29
29_75	Tân Tây	29
29_76	Tân Thành	29
29_77	Tân Thạnh	29
29_78	Tân Trụ	29
29_79	Thạnh Bình	29
29_80	Thanh Điền	29
29_81	Thạnh Đức	29
29_82	Thạnh Hóa	29
29_83	Thạnh Lợi	29
29_84	Thạnh Phước	29
29_85	Thủ Thừa	29
29_86	Thuận Mỹ	29
29_87	Trà Vong	29
29_88	Trảng Bàng	29
29_89	Truông Mít	29
29_90	Tuyên Bình	29
29_91	Tuyên Thạnh	29
29_92	Vàm Cỏ	29
29_93	Vĩnh Châu	29
29_94	Vĩnh Công	29
29_95	Vĩnh Hưng	29
29_96	Vĩnh Thạnh	29
30_1	An Khánh	30
30_2	Ba Bể	30
30_3	Bá Xuyên	30
30_4	Bách Quang	30
30_5	Bạch Thông	30
30_6	Bắc Kạn	30
30_7	Bằng Thành	30
30_8	Bằng Vân	30
30_9	Bình Thành	30
30_10	Bình Yên	30
30_11	Cao Minh	30
30_12	Cẩm Giàng	30
30_13	Chợ Đồn	30
30_14	Chợ Mới	30
30_15	Chợ Rã	30
30_16	Côn Minh	30
30_17	Cường Lợi	30
30_18	Dân Tiến	30
30_19	Đại Phúc	30
30_20	Đại Từ	30
30_21	Điềm Thụy	30
30_22	Định Hóa	30
30_23	Đồng Hỷ	30
30_24	Đồng Phúc	30
30_25	Đức Lương	30
30_26	Đức Xuân	30
30_27	Gia Sàng	30
30_28	Hiệp Lực	30
30_29	Hợp Thành	30
30_30	Kha Sơn	30
30_31	Kim Phượng	30
30_32	La Bằng	30
30_33	La Hiên	30
30_34	Lam Vỹ	30
30_35	Linh Sơn	30
30_36	Nà Phặc	30
30_37	Na Rì	30
30_38	Nam Cường	30
30_39	Nam Hòa	30
30_40	Ngân Sơn	30
30_41	Nghĩa Tá	30
30_42	Nghiên Loan	30
30_43	Nghinh Tường	30
30_44	Phan Đình Phùng	30
30_45	Phong Quang	30
30_46	Phổ Yên	30
30_47	Phú Bình	30
30_48	Phú Đình	30
30_49	Phú Lạc	30
30_50	Phú Lương	30
30_51	Phú Thịnh	30
30_52	Phủ Thông	30
30_53	Phú Xuyên	30
30_54	Phúc Lộc	30
30_55	Phúc Thuận	30
30_56	Phượng Tiến	30
30_57	Quan Triều	30
30_58	Quảng Bạch	30
30_59	Quang Sơn	30
30_60	Quân Chu	30
30_61	Quyết Thắng	30
30_62	Sảng Mộc	30
30_63	Sông Công	30
30_64	Tân Cương	30
30_65	Tân Khánh	30
30_66	Tân Kỳ	30
30_67	Tân Thành	30
30_68	Thành Công	30
30_69	Thanh Mai	30
30_70	Thanh Thịnh	30
30_71	Thần Sa	30
30_72	Thượng Minh	30
30_73	Thượng Quan	30
30_74	Tích Lương	30
30_75	Trại Cau	30
30_76	Tràng Xá	30
30_77	Trần Phú	30
30_78	Trung Hội	30
30_79	Trung Thành	30
30_80	Vạn Phú	30
30_81	Vạn Xuân	30
30_82	Văn Hán	30
30_83	Văn Lang	30
30_84	Văn Lăng	30
30_85	Vĩnh Thông	30
30_86	Võ Nhai	30
30_87	Vô Tranh	30
30_88	Xuân Dương	30
30_89	Yên Bình	30
30_90	Yên Phong	30
30_91	Yên Thịnh	30
30_92	Yên Trạch	30
31_1	An Nông	31
31_2	Ba Đình	31
31_3	Bá Thước	31
31_4	Bát Mọt	31
31_5	Biện Thượng	31
31_6	Bỉm Sơn	31
31_7	Các Sơn	31
31_8	Cẩm Tân	31
31_9	Cẩm Thạch	31
31_10	Cẩm Thủy	31
31_11	Cẩm Tú	31
31_12	Cẩm Vân	31
31_13	Cổ Lũng	31
31_14	Công Chính	31
31_15	Đào Duy Từ	31
31_16	Điền Lư	31
31_17	Điền Quang	31
31_18	Định Hòa	31
31_19	Định Tân	31
31_20	Đồng Lương	31
31_21	Đông Quang	31
31_22	Đông Sơn	31
31_23	Đông Thành	31
31_24	Đông Tiến	31
31_25	Đồng Tiến	31
31_26	Giao An	31
31_27	Hà Long	31
31_28	Hà Trung	31
31_29	Hạc Thành	31
31_30	Hải Bình	31
31_31	Hải Lĩnh	31
31_32	Hàm Rồng	31
31_33	Hậu Lộc	31
31_34	Hiền Kiệt	31
31_35	Hoa Lộc	31
31_36	Hóa Quỳ	31
31_37	Hoạt Giang	31
31_38	Hoằng Châu	31
31_39	Hoằng Giang	31
31_40	Hoằng Hóa	31
31_41	Hoằng Lộc	31
31_42	Hoằng Phú	31
31_43	Hoằng Sơn	31
31_44	Hoằng Thanh	31
31_45	Hoằng Tiến	31
31_46	Hồ Vương	31
31_47	Hồi Xuân	31
31_48	Hợp Tiến	31
31_49	Kiên Thọ	31
31_50	Kim Tân	31
31_51	Lam Sơn	31
31_52	Linh Sơn	31
31_53	Lĩnh Toại	31
31_54	Luận Thành	31
31_55	Lương Sơn	31
31_56	Lưu Vệ	31
31_57	Mậu Lâm	31
31_58	Minh Sơn	31
31_59	Mường Chanh	31
31_60	Mường Lát	31
31_61	Mường Lý	31
31_62	Mường Mìn	31
31_63	Na Mèo	31
31_64	Nam Sầm Sơn	31
31_65	Nam Xuân	31
31_66	Nga An	31
31_67	Nga Sơn	31
31_68	Nga Thắng	31
31_69	Nghi Sơn	31
31_70	Ngọc Lặc	31
31_71	Ngọc Liên	31
31_72	Ngọc Sơn	31
31_73	Ngọc Trạo	31
31_74	Nguyệt Ấn	31
31_75	Nguyệt Viên	31
31_76	Nhi Sơn	31
31_77	Như Thanh	31
31_78	Như Xuân	31
31_79	Nông Cống	31
31_80	Phú Lệ	31
31_81	Phú Xuân	31
31_82	Pù Luông	31
31_83	Pù Nhi	31
31_84	Quan Sơn	31
31_85	Quảng Bình	31
31_86	Quang Chiểu	31
31_87	Quảng Chính	31
31_88	Quảng Ngọc	31
31_89	Quảng Ninh	31
31_90	Quảng Phú	31
31_91	Quang Trung	31
31_92	Quảng Yên	31
31_93	Quý Lộc	31
31_94	Quý Lương	31
31_95	Sao Vàng	31
31_96	Sầm Sơn	31
31_97	Sơn Điện	31
31_98	Sơn Thủy	31
31_99	Tam Chung	31
31_100	Tam Lư	31
31_101	Tam Thanh	31
31_102	Tân Dân	31
31_103	Tân Ninh	31
31_104	Tân Thành	31
31_105	Tân Tiến	31
31_106	Tây Đô	31
31_107	Thạch Bình	31
31_108	Thạch Lập	31
31_109	Thạch Quảng	31
31_110	Thanh Kỳ	31
31_111	Thanh Phong	31
31_112	Thanh Quân	31
31_113	Thành Vinh	31
31_114	Thăng Bình	31
31_115	Thắng Lộc	31
31_116	Thắng Lợi	31
31_117	Thiên Phủ	31
31_118	Thiết Ống	31
31_119	Thiệu Hóa	31
31_120	Thiệu Quang	31
31_121	Thiệu Tiến	31
31_122	Thiệu Toán	31
31_123	Thiệu Trung	31
31_124	Thọ Bình	31
31_125	Thọ Lập	31
31_126	Thọ Long	31
31_127	Thọ Ngọc	31
31_128	Thọ Phú	31
31_129	Thọ Xuân	31
31_130	Thượng Ninh	31
31_131	Thường Xuân	31
31_132	Tiên Trang	31
31_133	Tĩnh Gia	31
31_134	Tống Sơn	31
31_135	Triệu Lộc	31
31_136	Triệu Sơn	31
31_137	Trúc Lâm	31
31_138	Trung Chính	31
31_139	Trung Hạ	31
31_140	Trung Lý	31
31_141	Trung Sơn	31
31_142	Trung Thành	31
31_143	Trường Lâm	31
31_144	Trường Văn	31
31_145	Tượng Lĩnh	31
31_146	Vạn Lộc	31
31_147	Vạn Xuân	31
31_148	Văn Nho	31
31_149	Văn Phú	31
31_150	Vân Du	31
31_151	Vĩnh Lộc	31
31_152	Xuân Bình	31
31_153	Xuân Chinh	31
31_154	Xuân Du	31
31_155	Xuân Hòa	31
31_156	Xuân Lập	31
31_157	Xuân Thái	31
31_158	Xuân Tín	31
31_159	Yên Định	31
31_160	Yên Khương	31
31_161	Yên Nhân	31
31_162	Yên Ninh	31
31_163	Yên Phú	31
31_164	Yên Thắng	31
31_165	Yên Thọ	31
31_166	Yên Trường	31
32_1	An Đông	32
32_2	An Hội Đông	32
32_3	An Hội Tây	32
32_4	An Khánh	32
32_5	An Lạc	32
32_6	An Long	32
32_7	An Nhơn	32
32_8	An Nhơn Tây	32
32_9	An Phú	32
32_10	An Phú Đông	32
32_11	An Thới Đông	32
32_12	Bà Điểm	32
32_13	Bà Rịa	32
32_14	Bàn Cờ	32
32_15	Bàu Bàng	32
32_16	Bàu Lâm	32
32_17	Bảy Hiền	32
32_18	Bắc Tân Uyên	32
32_19	Bến Cát	32
32_20	Bến Thành	32
32_21	Bình Chánh	32
32_22	Bình Châu	32
32_23	Bình Cơ	32
32_24	Bình Dương	32
32_25	Bình Đông	32
32_26	Bình Giã	32
32_27	Bình Hòa	32
32_28	Bình Hưng	32
32_29	Bình Hưng Hòa	32
32_30	Bình Khánh	32
32_31	Bình Lợi	32
32_32	Bình Lợi Trung	32
32_33	Bình Mỹ	32
32_34	Bình Phú	32
32_35	Bình Quới	32
32_36	Bình Tân	32
32_37	Bình Tây	32
32_38	Bình Thạnh	32
32_39	Bình Thới	32
32_40	Bình Tiên	32
32_41	Bình Trị Đông	32
32_42	Bình Trưng	32
32_43	Cát Lái	32
32_44	Cần Giờ	32
32_45	Cầu Kiệu	32
32_46	Cầu Ông Lãnh	32
32_47	Chánh Hiệp	32
32_48	Chánh Hưng	32
32_49	Chánh Phú Hòa	32
32_50	Châu Đức	32
32_51	Châu Pha	32
32_52	Chợ Lớn	32
32_53	Chợ Quán	32
32_54	Côn Đảo	32
32_55	Củ Chi	32
32_56	Dầu Tiếng	32
32_57	Dĩ An	32
32_58	Diên Hồng	32
32_59	Đất Đỏ	32
32_60	Đông Hòa	32
32_61	Đông Hưng Thuận	32
32_62	Đông Thạnh	32
32_63	Đức Nhuận	32
32_64	Gia Định	32
32_65	Gò Vấp	32
32_66	Hạnh Thông	32
32_67	Hiệp Bình	32
32_68	Hiệp Phước	32
32_69	Hòa Bình	32
32_70	Hòa Hiệp	32
32_71	Hòa Hội	32
32_72	Hòa Hưng	32
32_73	Hòa Lợi	32
32_74	Hóc Môn	32
32_75	Hồ Tràm	32
32_76	Hưng Long	32
32_77	Khánh Hội	32
32_78	Kim Long	32
32_79	Lái Thiêu	32
32_80	Linh Xuân	32
32_81	Long Bình	32
32_82	Long Điền	32
32_83	Long Hải	32
32_84	Long Hòa	32
32_85	Long Hương	32
32_86	Long Nguyên	32
32_87	Long Phước	32
32_88	Long Sơn	32
32_89	Long Trường	32
32_90	Minh Phụng	32
32_91	Minh Thạnh	32
32_92	Ngãi Giao	32
32_93	Nghĩa Thành	32
32_94	Nhà Bè	32
32_95	Nhiêu Lộc	32
32_96	Nhuận Đức	32
32_97	Phú An	32
32_98	Phú Định	32
32_99	Phú Giáo	32
32_100	Phú Hòa Đông	32
32_101	Phú Lâm	32
32_102	Phú Lợi	32
32_103	Phú Mỹ	32
32_104	Phú Nhuận	32
32_105	Phú Thạnh	32
32_106	Phú Thọ	32
32_107	Phú Thọ Hòa	32
32_108	Phú Thuận	32
32_109	Phước Hải	32
32_110	Phước Hòa	32
32_111	Phước Long	32
32_112	Phước Thành	32
32_113	Phước Thắng	32
32_114	Rạch Dừa	32
32_115	Sài Gòn	32
32_116	Tam Bình	32
32_117	Tam Long	32
32_118	Tam Thắng	32
32_119	Tăng Nhơn Phú	32
32_120	Tân An Hội	32
32_121	Tân Bình	32
32_122	Tân Định	32
32_123	Tân Đông Hiệp	32
32_124	Tân Hải	32
32_125	Tân Hiệp	32
32_126	Tân Hòa	32
32_127	Tân Hưng	32
32_128	Tân Khánh	32
32_129	Tân Mỹ	32
32_130	Tân Nhựt	32
32_131	Tân Phú	32
32_132	Tân Phước	32
32_133	Tân Sơn	32
32_134	Tân Sơn Hòa	32
32_135	Tân Sơn Nhất	32
32_136	Tân Sơn Nhì	32
32_137	Tân Tạo	32
32_138	Tân Thành	32
32_139	Tân Thới Hiệp	32
32_140	Tân Thuận	32
32_141	Tân Uyên	32
32_142	Tân Vĩnh Lộc	32
32_143	Tây Nam	32
32_144	Tây Thạnh	32
32_145	Thái Mỹ	32
32_146	Thanh An	32
32_147	Thạnh An	32
32_148	Thạnh Mỹ Tây	32
32_149	Thông Tây Hội	32
32_150	Thới An	32
32_151	Thới Hòa	32
32_152	Thủ Dầu Một	32
32_153	Thủ Đức	32
32_154	Thuận An	32
32_155	Thuận Giao	32
32_156	Thường Tân	32
32_157	Trung Mỹ Tây	32
32_158	Trừ Văn Thố	32
32_159	Vĩnh Hội	32
32_160	Vĩnh Lộc	32
32_161	Vĩnh Tân	32
32_162	Vũng Tàu	32
32_163	Vườn Lài	32
32_164	Xóm Chiếu	32
32_165	Xuân Hòa	32
32_166	Xuân Sơn	32
32_167	Xuân Thới Sơn	32
32_168	Xuyên Mộc	32
33_1	An Tường	33
33_2	Bạch Đích	33
33_3	Bạch Ngọc	33
33_4	Bạch Xa	33
33_5	Bản Máy	33
33_6	Bắc Mê	33
33_7	Bắc Quang	33
33_8	Bằng Hành	33
33_9	Bằng Lang	33
33_10	Bình An	33
33_11	Bình Ca	33
33_12	Bình Thuận	33
33_13	Bình Xa	33
33_14	Cán Tỷ	33
33_15	Cao Bồ	33
33_16	Chiêm Hóa	33
33_17	Côn Lôn	33
33_18	Du Già	33
33_19	Đồng Tâm	33
33_20	Đông Thọ	33
33_21	Đồng Văn	33
33_22	Đồng Yên	33
33_23	Đường Hồng	33
33_24	Đường Thượng	33
33_25	Giáp Trung	33
33_26	Hà Giang 1	33
33_27	Hà Giang 2	33
33_28	Hàm Yên	33
33_29	Hòa An	33
33_30	Hoàng Su Phì	33
33_31	Hồ Thầu	33
33_32	Hồng Sơn	33
33_33	Hồng Thái	33
33_34	Hùng An	33
33_35	Hùng Đức	33
33_36	Hùng Lợi	33
33_37	Khâu Vai	33
33_38	Khuôn Lùng	33
33_39	Kiên Đài	33
33_40	Kiến Thiết	33
33_41	Kim Bình	33
33_42	Lao Chải	33
33_43	Lâm Bình	33
33_44	Liên Hiệp	33
33_45	Linh Hồ	33
33_46	Lũng Cú	33
33_47	Lũng Phìn	33
33_48	Lùng Tám	33
33_49	Lực Hành	33
33_50	Mậu Duệ	33
33_51	Mèo Vạc	33
33_52	Minh Ngọc	33
33_53	Minh Quang	33
33_54	Minh Sơn	33
33_55	Minh Tân	33
33_56	Minh Thanh	33
33_57	Minh Xuân	33
33_58	Mỹ Lâm	33
33_59	Nà Hang	33
33_60	Nấm Dẩn	33
33_61	Nậm Dịch	33
33_62	Nghĩa Thuận	33
33_63	Ngọc Đường	33
33_64	Ngọc Long	33
33_65	Nhữ Khê	33
33_66	Niêm Sơn	33
33_67	Nông Tiến	33
33_68	Pà Vầy Sủ	33
33_69	Phố Bảng	33
33_70	Phú Linh	33
33_71	Phú Lương	33
33_72	Phù Lưu	33
33_73	Pờ Ly Ngài	33
33_74	Quản Bạ	33
33_75	Quang Bình	33
33_76	Quảng Nguyên	33
33_77	Sà Phìn	33
33_78	Sơn Dương	33
33_79	Sơn Thủy	33
33_80	Sơn Vĩ	33
33_81	Sủng Máng	33
33_82	Tát Ngà	33
33_83	Tân An	33
33_84	Tân Long	33
33_85	Tân Mỹ	33
33_86	Tân Quang	33
33_87	Tân Thanh	33
33_88	Tân Tiến	33
33_89	Tân Trào	33
33_90	Tân Trịnh	33
33_91	Thái Bình	33
33_92	Thái Hòa	33
33_93	Thái Sơn	33
33_94	Thàng Tín	33
33_95	Thanh Thủy	33
33_96	Thắng Mố	33
33_97	Thông Nguyên	33
33_98	Thuận Hòa	33
33_99	Thượng Lâm	33
33_100	Thượng Nông	33
33_101	Thượng Sơn	33
33_102	Tiên Nguyên	33
33_103	Tiên Yên	33
33_104	Tri Phú	33
33_105	Trung Hà	33
33_106	Trung Sơn	33
33_107	Trung Thịnh	33
33_108	Trường Sinh	33
33_109	Tùng Bá	33
33_110	Tùng Vài	33
33_111	Vị Xuyên	33
33_112	Việt Lâm	33
33_113	Vĩnh Tuy	33
33_114	Xín Mần	33
33_115	Xuân Giang	33
33_116	Xuân Vân	33
33_117	Yên Cường	33
33_118	Yên Hoa	33
33_119	Yên Lập	33
33_120	Yên Minh	33
33_121	Yên Nguyên	33
33_122	Yên Phú	33
33_123	Yên Sơn	33
33_124	Yên Thành	33
34_1	An Bình	34
34_2	An Định	34
34_3	An Hiệp	34
34_4	An Hội	34
34_5	An Ngãi Trung	34
34_6	An Phú Tân	34
34_7	An Qui	34
34_8	An Trường	34
34_9	Ba Tri	34
34_10	Bảo Thạnh	34
34_11	Bến Tre	34
34_12	Bình Đại	34
34_13	Bình Minh	34
34_14	Bình Phú	34
34_15	Bình Phước	34
34_16	Cái Ngang	34
34_17	Cái Nhum	34
34_18	Cái Vồn	34
34_19	Càng Long	34
34_20	Cầu Kè	34
34_21	Cầu Ngang	34
34_22	Châu Hòa	34
34_23	Châu Hưng	34
34_24	Châu Thành	34
34_25	Chợ Lách	34
34_26	Duyên Hải	34
34_27	Đại An	34
34_28	Đại Điền	34
34_29	Đôn Châu	34
34_30	Đông Hải	34
34_31	Đồng Khởi	34
34_32	Đông Thành	34
34_33	Giao Long	34
34_34	Giồng Trôm	34
34_35	Hàm Giang	34
34_36	Hiệp Mỹ	34
34_37	Hiếu Phụng	34
34_38	Hiếu Thành	34
34_39	Hòa Bình	34
34_40	Hòa Hiệp	34
34_41	Hòa Minh	34
34_42	Hoà Thuận	34
34_43	Hùng Hoà	34
34_44	Hưng Khánh Trung	34
34_45	Hưng Mỹ	34
34_46	Hưng Nhượng	34
34_47	Hương Mỹ	34
34_48	Long Châu	34
34_49	Long Đức	34
34_50	Long Hiệp	34
34_51	Long Hòa	34
34_52	Long Hồ	34
34_53	Long Hữu	34
34_54	Long Thành	34
34_55	Long Vĩnh	34
34_56	Lộc Thuận	34
34_57	Lục Sĩ Thành	34
34_58	Lương Hòa	34
34_59	Lương Phú	34
34_60	Lưu Nghiệp Anh	34
34_61	Mỏ Cày	34
34_62	Mỹ Chánh Hòa	34
34_63	Mỹ Long	34
34_64	Mỹ Thuận	34
34_65	Ngãi Tứ	34
34_66	Ngũ Lạc	34
34_67	Nguyệt Hoá	34
34_68	Nhị Long	34
34_69	Nhị Trường	34
34_70	Nhơn Phú	34
34_71	Nhuận Phú Tân	34
34_72	Phong Thạnh	34
34_73	Phú Khương	34
34_74	Phú Phụng	34
34_75	Phú Quới	34
34_76	Phú Tân	34
34_77	Phú Thuận	34
34_78	Phú Túc	34
34_79	Phước Hậu	34
34_80	Phước Long	34
34_81	Phước Mỹ Trung	34
34_82	Quới An	34
34_83	Quới Điền	34
34_84	Quới Thiện	34
34_85	Song Lộc	34
34_86	Song Phú	34
34_87	Sơn Đông	34
34_88	Tam Bình	34
34_89	Tam Ngãi	34
34_90	Tân An	34
34_91	Tân Hạnh	34
34_92	Tân Hào	34
34_93	Tân Hoà	34
34_94	Tân Long Hội	34
34_95	Tân Lược	34
34_96	Tân Ngãi	34
34_97	Tân Phú	34
34_98	Tân Quới	34
34_99	Tân Thành Bình	34
34_100	Tân Thủy	34
34_101	Tân Xuân	34
34_102	Tập Ngãi	34
34_103	Tập Sơn	34
34_104	Thanh Đức	34
34_105	Thạnh Hải	34
34_106	Thạnh Phong	34
34_107	Thạnh Phú	34
34_108	Thạnh Phước	34
34_109	Thành Thới	34
34_110	Thạnh Trị	34
34_111	Thới Thuận	34
34_112	Tiên Thủy	34
34_113	Tiểu Cần	34
34_114	Trà Côn	34
34_115	Trà Cú	34
34_116	Trà Ôn	34
34_117	Trà Vinh	34
34_118	Trung Hiệp	34
34_119	Trung Ngãi	34
34_120	Trung Thành	34
34_121	Trường Long Hoà	34
34_122	Vinh Kim	34
34_123	Vĩnh Thành	34
34_124	Vĩnh Xuân	34
\.


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
-- Name: ai_conversation ai_conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_conversation
    ADD CONSTRAINT ai_conversation_pkey PRIMARY KEY (id);


--
-- Name: ai_message ai_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_message
    ADD CONSTRAINT ai_message_pkey PRIMARY KEY (id);


--
-- Name: ai_subscription ai_subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_subscription
    ADD CONSTRAINT ai_subscription_pkey PRIMARY KEY (id);


--
-- Name: ai_subscription ai_subscription_student_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_subscription
    ADD CONSTRAINT ai_subscription_student_id_key UNIQUE (student_id);


--
-- Name: ai_usage_log ai_usage_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage_log
    ADD CONSTRAINT ai_usage_log_pkey PRIMARY KEY (id);


--
-- Name: ai_usage_log ai_usage_log_student_id_log_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage_log
    ADD CONSTRAINT ai_usage_log_student_id_log_date_key UNIQUE (student_id, log_date);


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
-- Name: consultation_leads consultation_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultation_leads
    ADD CONSTRAINT consultation_leads_pkey PRIMARY KEY (id);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


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
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


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
-- Name: user_linked_providers uq_provider_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_linked_providers
    ADD CONSTRAINT uq_provider_email UNIQUE (provider, provider_email);


--
-- Name: user_linked_providers uq_user_provider; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_linked_providers
    ADD CONSTRAINT uq_user_provider UNIQUE (user_id, provider);


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
-- Name: user_linked_providers user_linked_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_linked_providers
    ADD CONSTRAINT user_linked_providers_pkey PRIMARY KEY (id);


--
-- Name: user_push_tokens user_push_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_tokens
    ADD CONSTRAINT user_push_tokens_pkey PRIMARY KEY (id);


--
-- Name: user_push_tokens user_push_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_tokens
    ADD CONSTRAINT user_push_tokens_token_key UNIQUE (token);


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
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


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
-- Name: idx_ai_conversation_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversation_created ON public.ai_conversation USING btree (created_at DESC);


--
-- Name: idx_ai_conversation_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversation_student ON public.ai_conversation USING btree (student_id);


--
-- Name: idx_ai_message_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_message_conversation ON public.ai_message USING btree (conversation_id);


--
-- Name: idx_ai_message_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_message_created ON public.ai_message USING btree (created_at);


--
-- Name: idx_ai_subscription_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_subscription_status ON public.ai_subscription USING btree (status);


--
-- Name: idx_ai_subscription_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_subscription_student ON public.ai_subscription USING btree (student_id);


--
-- Name: idx_ai_usage_student_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_usage_student_date ON public.ai_usage_log USING btree (student_id, log_date);


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
-- Name: idx_consultation_leads_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_consultation_leads_created_at ON public.consultation_leads USING btree (created_at DESC);


--
-- Name: idx_contact_messages_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_contact_messages_created_at ON public.contact_messages USING btree (created_at DESC);


--
-- Name: idx_contact_messages_is_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_contact_messages_is_read ON public.contact_messages USING btree (is_read);


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
-- Name: idx_linked_providers_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_linked_providers_email ON public.user_linked_providers USING btree (provider_email);


--
-- Name: idx_linked_providers_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_linked_providers_user_id ON public.user_linked_providers USING btree (user_id);


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
-- Name: idx_push_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_push_tokens_user_id ON public.user_push_tokens USING btree (user_id);


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
-- Name: ai_conversation ai_conversation_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_conversation
    ADD CONSTRAINT ai_conversation_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_message ai_message_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_message
    ADD CONSTRAINT ai_message_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.ai_conversation(id) ON DELETE CASCADE;


--
-- Name: ai_subscription ai_subscription_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_subscription
    ADD CONSTRAINT ai_subscription_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_usage_log ai_usage_log_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage_log
    ADD CONSTRAINT ai_usage_log_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: user_linked_providers fk_linked_provider_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_linked_providers
    ADD CONSTRAINT fk_linked_provider_user FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- Name: user_push_tokens user_push_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_tokens
    ADD CONSTRAINT user_push_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: wards wards_province_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_province_code_fkey FOREIGN KEY (province_code) REFERENCES public.provinces(code) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict B2nqKEo6rpzLwqLmRbrkDrHOVjuhYMUx2l1rtjAo4cahuxGgQNyQYcfthri1tLu

