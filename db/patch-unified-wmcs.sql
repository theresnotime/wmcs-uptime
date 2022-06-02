-- Unified selection of database patches

BEGIN TRANSACTION;
CREATE TABLE setting_dg_tmp
(
    id INTEGER
        primary key autoincrement,
    key VARCHAR(200) not null
        unique,
    value TEXT,
    type VARCHAR(20)
);

INSERT INTO setting_dg_tmp(id, key, value, type) SELECT id, key, value, type FROM setting;
DROP TABLE setting;
ALTER TABLE setting_dg_tmp RENAME TO setting;
COMMIT;


BEGIN TRANSACTION;
-- For sendHeartbeatList
CREATE INDEX monitor_time_index ON heartbeat (monitor_id, time);
-- For sendImportantHeartbeatList
CREATE INDEX monitor_important_time_index ON heartbeat (monitor_id, important,time);
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE user
    ADD twofa_secret VARCHAR(64);
ALTER TABLE user
    ADD twofa_status BOOLEAN default 0 NOT NULL;
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD retry_interval INTEGER default 0 not null;
COMMIT;


BEGIN TRANSACTION;
CREATE TABLE incident
(
    id                INTEGER      not null
        constraint incident_pk
            primary key autoincrement,
    title             VARCHAR(255) not null,
    content           TEXT         not null,
    style             VARCHAR(30)            default 'warning' not null,
    created_date      DATETIME               default (DATETIME('now')) not null,
    last_updated_date DATETIME,
    pin               BOOLEAN                default 1 not null,
    active            BOOLEAN                default 1 not null
);
COMMIT;


BEGIN TRANSACTION;
CREATE TABLE `group`
(
    id           INTEGER      not null
        constraint group_pk
            primary key autoincrement,
    name         VARCHAR(255) not null,
    created_date DATETIME              default (DATETIME('now')) not null,
    public       BOOLEAN               default 0 not null,
    active       BOOLEAN               default 1 not null,
    weight       BOOLEAN      NOT NULL DEFAULT 1000
);
CREATE TABLE [monitor_group]
(
    [id]         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [monitor_id] INTEGER                           NOT NULL REFERENCES [monitor] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    [group_id]   INTEGER                           NOT NULL REFERENCES [group] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    weight BOOLEAN NOT NULL DEFAULT 1000
);
CREATE INDEX [fk]
    ON [monitor_group] (
                        [monitor_id],
                        [group_id]);
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD push_token VARCHAR(20) DEFAULT NULL;
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD method TEXT default 'GET' not null;
ALTER TABLE monitor
    ADD body TEXT default null;
ALTER TABLE monitor
    ADD headers TEXT default null;
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE user
    ADD twofa_last_token VARCHAR(6);
COMMIT;


BEGIN TRANSACTION;
CREATE TABLE [notification_sent_history] (
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [monitor_id] INTEGER NOT NULL,
    [days] INTEGER NOT NULL,
    UNIQUE([type], [monitor_id], [days])
);
CREATE INDEX [good_index] ON [notification_sent_history] (
    [type],
    [monitor_id],
    [days]
);
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD basic_auth_user TEXT default null;
ALTER TABLE monitor
    ADD basic_auth_pass TEXT default null;
COMMIT;


BEGIN TRANSACTION;
CREATE TABLE [status_page](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [slug] VARCHAR(255) NOT NULL UNIQUE,
    [title] VARCHAR(255) NOT NULL,
    [description] TEXT,
    [icon] VARCHAR(255) NOT NULL,
    [theme] VARCHAR(30) NOT NULL,
    [published] BOOLEAN NOT NULL DEFAULT 1,
    [search_engine_index] BOOLEAN NOT NULL DEFAULT 1,
    [show_tags] BOOLEAN NOT NULL DEFAULT 0,
    [password] VARCHAR,
    [created_date] DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    [modified_date] DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX [slug] ON [status_page]([slug]);
CREATE TABLE [status_page_cname](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [status_page_id] INTEGER NOT NULL REFERENCES [status_page]([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    [domain] VARCHAR NOT NULL UNIQUE
);
ALTER TABLE incident ADD status_page_id INTEGER;
ALTER TABLE [group] ADD status_page_id INTEGER;
COMMIT;


BEGIN TRANSACTION;
CREATE TABLE proxy (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id INT NOT NULL,
    protocol VARCHAR(10) NOT NULL,
    host VARCHAR(255) NOT NULL,
    port SMALLINT NOT NULL,
    auth BOOLEAN NOT NULL,
    username VARCHAR(255) NULL,
    password VARCHAR(255) NULL,
    active BOOLEAN NOT NULL DEFAULT 1,
    'default' BOOLEAN NOT NULL DEFAULT 0,
    created_date DATETIME DEFAULT (DATETIME('now')) NOT NULL
);
ALTER TABLE monitor ADD COLUMN proxy_id INTEGER REFERENCES proxy(id);
CREATE INDEX proxy_id ON monitor (proxy_id);
CREATE INDEX proxy_user_id ON proxy (user_id);
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD expiry_notification BOOLEAN default 1;
COMMIT;

BEGIN TRANSACTION;
ALTER TABLE status_page
    ADD footer_text TEXT;
ALTER TABLE status_page
    ADD custom_css TEXT;
ALTER TABLE status_page
    ADD show_powered_by BOOLEAN NOT NULL DEFAULT 1;
COMMIT;


BEGIN TRANSACTION;
ALTER TABLE monitor
    ADD mqtt_topic TEXT;
ALTER TABLE monitor
    ADD mqtt_success_message VARCHAR(255);
ALTER TABLE monitor
    ADD mqtt_username VARCHAR(255);
ALTER TABLE monitor
    ADD mqtt_password VARCHAR(255);
COMMIT;