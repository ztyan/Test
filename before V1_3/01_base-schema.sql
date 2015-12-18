--
-- Jeremy 2015-07-20: snapshot of the beta2 (DROP-058) snapshot production database schema
--

--
-- Name: category; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "parentId" bigint,
    name character varying(64),
    description text,
    ordr integer,
    type character varying(64),
    "ownerId" bigint
);


--
-- Name: query_sub_categories(bigint[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION query_sub_categories(bigint[]) RETURNS SETOF category
    LANGUAGE plpgsql
    AS $_$
DECLARE
itemids ALIAS FOR $1;
itemrecord record;
BEGIN
	
	for itemrecord in SELECT s.* FROM category s where id = any(itemids) LOOP
		RETURN NEXT itemrecord;
		IF (select count(1) from category s where s."parentId"=itemrecord.id) > 0  THEN
			for itemrecord in SELECT s.* FROM category s where s."parentId"=itemrecord.id LOOP
				for itemrecord in select * from query_sub_categories (array[itemrecord.id] :: bigint[]) LOOP
					RETURN NEXT itemrecord;
				end LOOP;
			end LOOP;
		END IF;
	end LOOP;
END;$_$;


--
-- Name: asset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE asset (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "chainId" bigint,
    "folioId" bigint,
    "linkId" bigint,
    "folderId" bigint,
    ordr integer,
    name character varying(128),
    type character varying(1) DEFAULT 'f'::character varying,
    ext character varying(12),
    url character varying(1024),
    location character varying(128),
    realname character varying(256),
    urltype character varying(12),
    "iframeEnable" boolean,
    "fileRecordId" bigint
);


--
-- Name: asset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE asset_id_seq OWNED BY asset.id;


--
-- Name: audit; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE audit (
    id bigint NOT NULL,
    entity character varying(1024) NOT NULL,
    "entityId" bigint NOT NULL,
    action character varying(2048) NOT NULL,
    msg text,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone
);


--
-- Name: audit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audit_id_seq OWNED BY audit.id;


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: categorytenant; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categorytenant (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "categoryId" bigint
);


--
-- Name: categorytenant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categorytenant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorytenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categorytenant_id_seq OWNED BY categorytenant.id;


--
-- Name: chain; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chain (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    name character varying(64),
    "companyName" character varying(64),
    "imageId" character varying(128),
    author character varying(64),
    "chainType" character varying(64),
    "isStar" boolean DEFAULT false NOT NULL,
    "isTemplate" boolean DEFAULT false NOT NULL,
    "categoryId" bigint,
    "isPortfolio" boolean DEFAULT false NOT NULL,
    "bkgId" character varying(128),
    "originId" bigint,
    "isDefault" boolean DEFAULT false NOT NULL,
    "isStandCopy" boolean DEFAULT false NOT NULL
);


--
-- Name: chain_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chain_id_seq OWNED BY chain.id;


--
-- Name: chainnote; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chainnote (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "noteId" bigint,
    "chainId" bigint
);


--
-- Name: chainnote_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chainnote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chainnote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chainnote_id_seq OWNED BY chainnote.id;


--
-- Name: chainuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chainuser (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "userId" bigint,
    "chainId" bigint,
    role character varying(64)
);


--
-- Name: chainuser_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chainuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chainuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chainuser_id_seq OWNED BY chainuser.id;


--
-- Name: connection; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE connection (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "fromLinkId" bigint,
    "toLinkId" bigint,
    "chainId" bigint
);


--
-- Name: connection_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE connection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE connection_id_seq OWNED BY connection.id;


--
-- Name: docpreview; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE docpreview (
    id bigint NOT NULL,
    key character varying(36) NOT NULL,
    "ownerId" bigint,
    "assetId" bigint,
    "tenantId" bigint,
    "isViewed" boolean DEFAULT false NOT NULL,
    "validBeginDate" timestamp without time zone,
    "validEndDate" timestamp without time zone,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone
);


--
-- Name: docpreview_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docpreview_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docpreview_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docpreview_id_seq OWNED BY docpreview.id;


--
-- Name: filerecord; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filerecord (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    realname character varying(256),
    ext character varying(12)
);


--
-- Name: filerecord_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filerecord_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filerecord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE filerecord_id_seq OWNED BY filerecord.id;


--
-- Name: folder; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE folder (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    name character varying(64),
    "linkId" bigint,
    type character varying(64),
    ordr integer
);


--
-- Name: folder_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE folder_id_seq OWNED BY folder.id;


--
-- Name: folio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE folio (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    name character varying(64),
    customer character varying(64),
    "logoId" character varying(256),
    "isStar" boolean DEFAULT false NOT NULL,
    "isTemplate" boolean DEFAULT false NOT NULL,
    "permissionLevel" character varying(32),
    background character varying(128),
    opacity integer
);


--
-- Name: folio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE folio_id_seq OWNED BY folio.id;


--
-- Name: foliocategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foliocategory (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "categoryId" bigint,
    "folioId" bigint
);


--
-- Name: foliocategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE foliocategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foliocategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foliocategory_id_seq OWNED BY foliocategory.id;


--
-- Name: foliochain; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foliochain (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "chainId" bigint,
    "folioId" bigint,
    "isLink" boolean DEFAULT false NOT NULL,
    "isViewCopy" boolean DEFAULT false NOT NULL,
    ordr integer
);


--
-- Name: foliochain_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE foliochain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foliochain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foliochain_id_seq OWNED BY foliochain.id;


--
-- Name: folionote; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE folionote (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "noteId" bigint,
    "folioId" bigint
);


--
-- Name: folionote_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folionote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folionote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE folionote_id_seq OWNED BY folionote.id;


--
-- Name: foliouser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foliouser (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "userId" bigint,
    "folioId" bigint,
    role character varying(64)
);


--
-- Name: foliouser_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE foliouser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foliouser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foliouser_id_seq OWNED BY foliouser.id;


--
-- Name: link; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE link (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "chainId" bigint,
    name character varying(64),
    "rowId" bigint,
    description text,
    "isLock" boolean DEFAULT false NOT NULL,
    "parentId" bigint,
    "subLinkRow" integer,
    stack boolean DEFAULT false NOT NULL,
    ordr integer,
    "lockOwnerId" bigint,
    "originId" bigint,
    "isExtend" boolean DEFAULT false NOT NULL
);


--
-- Name: link_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE link_id_seq OWNED BY link.id;


--
-- Name: note; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE note (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    name character varying(64),
    content text
);


--
-- Name: note_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: notelink; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notelink (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "linkId" bigint,
    "noteId" bigint,
    ordr integer
);


--
-- Name: notelink_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notelink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notelink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notelink_id_seq OWNED BY notelink.id;


--
-- Name: noteuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE noteuser (
    id bigint NOT NULL,
    "userId" bigint,
    "noteId" bigint,
    "readTime" timestamp without time zone
);


--
-- Name: noteuser_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE noteuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: noteuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE noteuser_id_seq OWNED BY noteuser.id;


--
-- Name: row; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "row" (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    name character varying(64),
    "chainId" bigint,
    "graphicId" character varying(128),
    type character varying(64),
    description text,
    ordr integer
);


--
-- Name: row_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE row_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: row_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE row_id_seq OWNED BY "row".id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE session (
    id bigint NOT NULL,
    key character varying(36) NOT NULL,
    "loginId" bigint,
    "tenantId" bigint,
    "validBeginDate" timestamp without time zone,
    "validEndDate" timestamp without time zone,
    "loginDate" timestamp without time zone,
    "requestUrl" character varying(2048),
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "loginType" character varying(36),
    "loginSource" character varying(36),
    "logoutDate" timestamp without time zone
);


--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE session_id_seq OWNED BY session.id;


--
-- Name: tenant; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tenant (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    name character varying(64)
);


--
-- Name: tenant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tenant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tenant_id_seq OWNED BY tenant.id;


--
-- Name: tenantuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tenantuser (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "userId" bigint,
    "tenantId" bigint,
    role character varying(64)
);


--
-- Name: tenantuser_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tenantuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenantuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tenantuser_id_seq OWNED BY tenantuser.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id bigint NOT NULL,
    username character varying(64),
    password character varying(256),
    "firstName" character varying(64),
    "lastName" character varying(64),
    ctime timestamp without time zone,
    utime timestamp without time zone,
    sys boolean DEFAULT false NOT NULL,
    "resetPasswordToken" character varying(40)
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: usercategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usercategory (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "categoryId" bigint,
    "chainId" bigint,
    "userId" bigint
);


--
-- Name: usercategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usercategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usercategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE usercategory_id_seq OWNED BY usercategory.id;


--
-- Name: userprofile; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userprofile (
    id bigint NOT NULL,
    "cuserId" bigint,
    "uuserId" bigint,
    ctime timestamp without time zone,
    utime timestamp without time zone,
    "tenantId" bigint,
    "userId" bigint,
    "photoId" character varying(256),
    email character varying(64),
    phone character varying(32)
);


--
-- Name: userprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE userprofile_id_seq OWNED BY userprofile.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset ALTER COLUMN id SET DEFAULT nextval('asset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit ALTER COLUMN id SET DEFAULT nextval('audit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorytenant ALTER COLUMN id SET DEFAULT nextval('categorytenant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chain ALTER COLUMN id SET DEFAULT nextval('chain_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote ALTER COLUMN id SET DEFAULT nextval('chainnote_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser ALTER COLUMN id SET DEFAULT nextval('chainuser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection ALTER COLUMN id SET DEFAULT nextval('connection_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview ALTER COLUMN id SET DEFAULT nextval('docpreview_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY filerecord ALTER COLUMN id SET DEFAULT nextval('filerecord_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY folder ALTER COLUMN id SET DEFAULT nextval('folder_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY folio ALTER COLUMN id SET DEFAULT nextval('folio_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliocategory ALTER COLUMN id SET DEFAULT nextval('foliocategory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain ALTER COLUMN id SET DEFAULT nextval('foliochain_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote ALTER COLUMN id SET DEFAULT nextval('folionote_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser ALTER COLUMN id SET DEFAULT nextval('foliouser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY link ALTER COLUMN id SET DEFAULT nextval('link_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink ALTER COLUMN id SET DEFAULT nextval('notelink_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY noteuser ALTER COLUMN id SET DEFAULT nextval('noteuser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "row" ALTER COLUMN id SET DEFAULT nextval('row_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY session ALTER COLUMN id SET DEFAULT nextval('session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenant ALTER COLUMN id SET DEFAULT nextval('tenant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenantuser ALTER COLUMN id SET DEFAULT nextval('tenantuser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY usercategory ALTER COLUMN id SET DEFAULT nextval('usercategory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY userprofile ALTER COLUMN id SET DEFAULT nextval('userprofile_id_seq'::regclass);


--
-- Name: asset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (id);


--
-- Name: audit_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (id);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: categorytenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categorytenant
    ADD CONSTRAINT categorytenant_pkey PRIMARY KEY (id);


--
-- Name: chainnote_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_pkey PRIMARY KEY (id);


--
-- Name: chainuser_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_id UNIQUE ("userId", "chainId");


--
-- Name: chainuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_pkey PRIMARY KEY (id);


--
-- Name: connection_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_pkey PRIMARY KEY (id);


--
-- Name: docpreview_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_pkey PRIMARY KEY (id);


--
-- Name: file_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filerecord
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- Name: folder_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (id);


--
-- Name: folio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folio
    ADD CONSTRAINT folio_pkey PRIMARY KEY (id);


--
-- Name: foliocategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foliocategory
    ADD CONSTRAINT foliocategory_pkey PRIMARY KEY (id);


--
-- Name: foliochain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_id UNIQUE ("chainId", "folioId");


--
-- Name: foliochain_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_pkey PRIMARY KEY (id);


--
-- Name: folionote_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_pkey PRIMARY KEY (id);


--
-- Name: foliouser_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_id UNIQUE ("userId", "folioId");


--
-- Name: foliouser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_pkey PRIMARY KEY (id);


--
-- Name: link_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_pkey PRIMARY KEY (id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: notelink_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_id UNIQUE ("linkId", "noteId");


--
-- Name: notelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_pkey PRIMARY KEY (id);


--
-- Name: noteuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY noteuser
    ADD CONSTRAINT noteuser_pkey PRIMARY KEY (id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chain
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: row_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "row"
    ADD CONSTRAINT row_pkey PRIMARY KEY (id);


--
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tenant
    ADD CONSTRAINT tenant_pkey PRIMARY KEY (id);


--
-- Name: tenantuser_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_id UNIQUE ("userId", "tenantId");


--
-- Name: tenantuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_pkey PRIMARY KEY (id);


--
-- Name: user_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_name UNIQUE (username);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: usercategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usercategory
    ADD CONSTRAINT usercategory_pkey PRIMARY KEY (id);


--
-- Name: userprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userprofile
    ADD CONSTRAINT userprofile_pkey PRIMARY KEY (id);


--
-- Name: docpreview_key_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX docpreview_key_idx ON docpreview USING btree (key);


--
-- Name: session_key_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX session_key_idx ON session USING btree (key);


--
-- Name: user_username_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_username_idx ON "user" USING btree (username);


--
-- Name: asset_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE SET NULL;


--
-- Name: asset_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: asset_file_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_file_record_id_fkey FOREIGN KEY ("fileRecordId") REFERENCES filerecord(id) ON DELETE SET NULL;


--
-- Name: asset_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_folder_id_fkey FOREIGN KEY ("folderId") REFERENCES folder(id) ON DELETE SET NULL;


--
-- Name: asset_folio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_folio_id_fkey FOREIGN KEY ("folioId") REFERENCES folio(id) ON DELETE SET NULL;


--
-- Name: asset_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_link_id_fkey FOREIGN KEY ("linkId") REFERENCES link(id) ON DELETE SET NULL;


--
-- Name: asset_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: asset_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: audit_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit
    ADD CONSTRAINT audit_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: audit_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit
    ADD CONSTRAINT audit_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: category_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: category_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_owner_id_fkey FOREIGN KEY ("ownerId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: category_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_parent_id_fkey FOREIGN KEY ("parentId") REFERENCES category(id) ON DELETE CASCADE;


--
-- Name: category_to_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_to_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: category_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: categorytenant_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorytenant
    ADD CONSTRAINT categorytenant_category_id_fkey FOREIGN KEY ("categoryId") REFERENCES category(id) ON DELETE CASCADE;


--
-- Name: categorytenant_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorytenant
    ADD CONSTRAINT categorytenant_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: categorytenant_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorytenant
    ADD CONSTRAINT categorytenant_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: categorytenant_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorytenant
    ADD CONSTRAINT categorytenant_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chain_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chain
    ADD CONSTRAINT chain_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chain_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chain
    ADD CONSTRAINT chain_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: chain_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chain
    ADD CONSTRAINT chain_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chainnote_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE CASCADE;


--
-- Name: chainnote_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chainnote_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_note_id_fkey FOREIGN KEY ("noteId") REFERENCES note(id) ON DELETE CASCADE;


--
-- Name: chainnote_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: chainnote_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainnote
    ADD CONSTRAINT chainnote_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chainuser_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE CASCADE;


--
-- Name: chainuser_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: chainuser_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: chainuser_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_user_id_fkey FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: chainuser_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chainuser
    ADD CONSTRAINT chainuser_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: change_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chain
    ADD CONSTRAINT change_category_id_fkey FOREIGN KEY ("categoryId") REFERENCES category(id) ON DELETE SET NULL;


--
-- Name: connection_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE CASCADE;


--
-- Name: connection_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: connection_from_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_from_link_id_fkey FOREIGN KEY ("fromLinkId") REFERENCES link(id) ON DELETE CASCADE;


--
-- Name: connection_to_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_to_link_id_fkey FOREIGN KEY ("fromLinkId") REFERENCES link(id) ON DELETE CASCADE;


--
-- Name: connection_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY connection
    ADD CONSTRAINT connection_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: docpreview_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_asset_id_fkey FOREIGN KEY ("assetId") REFERENCES asset(id) ON DELETE CASCADE;


--
-- Name: docpreview_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: docpreview_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_owner_id_fkey FOREIGN KEY ("ownerId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: docpreview_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: docpreview_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docpreview
    ADD CONSTRAINT docpreview_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: filerecord_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY filerecord
    ADD CONSTRAINT filerecord_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: filerecord_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY filerecord
    ADD CONSTRAINT filerecord_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: filerecord_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY filerecord
    ADD CONSTRAINT filerecord_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folder_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folder_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_link_id_fkey FOREIGN KEY ("linkId") REFERENCES link(id) ON DELETE CASCADE;


--
-- Name: folder_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: folder_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folio_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folio
    ADD CONSTRAINT folio_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folio_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folio
    ADD CONSTRAINT folio_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: folio_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folio
    ADD CONSTRAINT folio_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliocategory_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliocategory
    ADD CONSTRAINT foliocategory_category_id_fkey FOREIGN KEY ("categoryId") REFERENCES category(id) ON DELETE CASCADE;


--
-- Name: foliocategory_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliocategory
    ADD CONSTRAINT foliocategory_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliocategory_folio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliocategory
    ADD CONSTRAINT foliocategory_folio_id_fkey FOREIGN KEY ("folioId") REFERENCES folio(id) ON DELETE CASCADE;


--
-- Name: foliocategory_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliocategory
    ADD CONSTRAINT foliocategory_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliochain_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE CASCADE;


--
-- Name: foliochain_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliochain_folio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_folio_id_fkey FOREIGN KEY ("folioId") REFERENCES folio(id) ON DELETE CASCADE;


--
-- Name: foliochain_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: foliochain_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliochain
    ADD CONSTRAINT foliochain_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folionote_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: folionote_folio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_folio_id_fkey FOREIGN KEY ("folioId") REFERENCES folio(id) ON DELETE CASCADE;


--
-- Name: folionote_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_note_id_fkey FOREIGN KEY ("noteId") REFERENCES note(id) ON DELETE CASCADE;


--
-- Name: folionote_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: folionote_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY folionote
    ADD CONSTRAINT folionote_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliouser_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: foliouser_folio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_folio_id_fkey FOREIGN KEY ("folioId") REFERENCES folio(id) ON DELETE CASCADE;


--
-- Name: foliouser_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: foliouser_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_user_id_fkey FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: foliouser_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliouser
    ADD CONSTRAINT foliouser_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: link_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: link_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_parent_id_fkey FOREIGN KEY ("parentId") REFERENCES link(id) ON DELETE SET NULL;


--
-- Name: link_row_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_row_id_fkey FOREIGN KEY ("rowId") REFERENCES "row"(id) ON DELETE CASCADE;


--
-- Name: link_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: link_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: note_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: note_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: note_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: notelink_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: notelink_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_link_id_fkey FOREIGN KEY ("linkId") REFERENCES link(id) ON DELETE CASCADE;


--
-- Name: notelink_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_note_id_fkey FOREIGN KEY ("noteId") REFERENCES note(id) ON DELETE CASCADE;


--
-- Name: notelink_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: notelink_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notelink
    ADD CONSTRAINT notelink_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: noteuser_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY noteuser
    ADD CONSTRAINT noteuser_note_id_fkey FOREIGN KEY ("noteId") REFERENCES note(id) ON DELETE CASCADE;


--
-- Name: noteuser_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY noteuser
    ADD CONSTRAINT noteuser_user_id_fkey FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: row_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "row"
    ADD CONSTRAINT row_chain_id_fkey FOREIGN KEY ("chainId") REFERENCES chain(id) ON DELETE CASCADE;


--
-- Name: row_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "row"
    ADD CONSTRAINT row_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: row_tennant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "row"
    ADD CONSTRAINT row_tennant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: row_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "row"
    ADD CONSTRAINT row_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: session_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: session_login_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_login_id_fkey FOREIGN KEY ("loginId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: session_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: session_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: tenant_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenant
    ADD CONSTRAINT tenant_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: tenant_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenant
    ADD CONSTRAINT tenant_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: tenantuser_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: tenantuser_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE CASCADE;


--
-- Name: tenantuser_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_user_id_fkey FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: tenantuser_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenantuser
    ADD CONSTRAINT tenantuser_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: usercategory_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usercategory
    ADD CONSTRAINT usercategory_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: usercategory_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usercategory
    ADD CONSTRAINT usercategory_tenant_id_fkey FOREIGN KEY ("tenantId") REFERENCES tenant(id) ON DELETE SET NULL;


--
-- Name: usercategory_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usercategory
    ADD CONSTRAINT usercategory_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: userprofile_cuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userprofile
    ADD CONSTRAINT userprofile_cuser_id_fkey FOREIGN KEY ("cuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: userprofile_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userprofile
    ADD CONSTRAINT userprofile_user_id_fkey FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: userprofile_uuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userprofile
    ADD CONSTRAINT userprofile_uuser_id_fkey FOREIGN KEY ("uuserId") REFERENCES "user"(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

-- Jeremy 2015-07-20: Not sure why we have this method part of the export. Not removing for now (will need to investigate why). 
CREATE FUNCTION get_user_lastlogin(p_tenant integer, p_lastdays integer) RETURNS TABLE(username character varying, maxlogindate timestamp without time zone, logincount bigint)
    LANGUAGE sql
    AS $$
select u.username,t.maxLoginDate,t.loginCount
from "user" as u
  inner join tenantuser as tu on tu."userId"=u.id
  left join (
              select  s."loginSource", s."loginId" as userId,max(s."loginDate") as maxLoginDate,count(*) as loginCount
              from session as s
              where (s."tenantId"=p_tenant or p_tenant=0) and date_trunc('day',s."loginDate")+p_lastdays*interval'1 day'>=current_date
              group by s."loginId", s."loginSource"
            ) as t on u.id=t.userId
where (tu."tenantId"=p_tenant or p_tenant=0)
and t."loginSource" ='oc'
order by coalesce(t.maxLoginDate,to_timestamp('1900-01-01','YYYY-MM-DD')) desc;
$$;
