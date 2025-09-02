#!/usr/bin/env bash
# setup_oracle_admissions.sh
# Run once from repo root: bash setup_oracle_admissions.sh
# This scaffolds the Oracle Admissions (banner-like) + SQL Server integration.

set -e

BASE_DIR="integrations"

echo "Creating folder structure..."
mkdir -p $BASE_DIR/{oracle/init,sqlserver/init}

echo "Creating docker-compose.yml..."
cat > $BASE_DIR/docker-compose.yml <<'EOF'
version: "3.9"
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: uni-mssql
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=SqlServerP@ssw0rd!
    ports: ["1433:1433"]
    healthcheck:
      test: ["CMD", "/opt/mssql-tools18/bin/sqlcmd", "-C", "-S", "localhost", "-U", "sa", "-P", "SqlServerP@ssw0rd!", "-Q", "SELECT 1"]
      interval: 10s
      timeout: 5s
      retries: 10
    volumes:
      - ./sqlserver/init:/docker-entrypoint-initdb.d

  oracle:
    image: gvenzl/oracle-xe:21.3.0
    container_name: uni-oracle
    environment:
      - ORACLE_PASSWORD=OracleP@ssw0rd
      - APP_USER=admissions
      - APP_USER_PASSWORD=AdmissionsP@ssw0rd
    ports: ["1521:1521"]
    healthcheck:
      test: ["CMD-SHELL", "echo 'SELECT 1 FROM dual;' | sqlplus -s system/OracleP@ssw0rd@localhost/XEPDB1 || exit 1"]
      interval: 15s
      timeout: 10s
      retries: 20
    volumes:
      - ./oracle/init:/container-entrypoint-initdb.d

  adminer:
    image: adminer
    restart: always
    ports: ["8080:8080"]
EOF

echo "Creating Oracle schema script..."
cat > $BASE_DIR/oracle/init/01_schema.sql <<'EOF'
-- Oracle "Admissions" schema (banner-like, not real Banner)
ALTER SESSION SET CONTAINER = XEPDB1;

CREATE TABLE admissions_student (
  pidm          NUMBER PRIMARY KEY,
  univ_id       VARCHAR2(9) UNIQUE,
  last_name     VARCHAR2(60),
  first_name    VARCHAR2(60),
  middle_name   VARCHAR2(60),
  active_ind    CHAR(1),
  activity_date DATE DEFAULT SYSDATE
);

CREATE TABLE admissions_application (
  pidm            NUMBER,
  term_code       VARCHAR2(6),
  appl_no         NUMBER,
  status_code     VARCHAR2(2),
  major_code      VARCHAR2(10),
  appl_date       DATE,
  activity_date   DATE DEFAULT SYSDATE,
  CONSTRAINT pk_admissions_application PRIMARY KEY (pidm, term_code, appl_no)
);

CREATE TABLE admissions_app_staging (
  pidm        NUMBER,
  term_code   VARCHAR2(6),
  appl_no     NUMBER,
  status_code VARCHAR2(2),
  major_code  VARCHAR2(10),
  appl_date   DATE,
  published_at DATE DEFAULT SYSDATE
);

INSERT INTO admissions_student (pidm, univ_id, last_name, first_name, active_ind)
VALUES (2001, 'U00000001', 'Nguyen', 'Linh', 'Y');
INSERT INTO admissions_student (pidm, univ_id, last_name, first_name, active_ind)
VALUES (2002, 'U00000002', 'Patel', 'Asha', 'Y');

INSERT INTO admissions_application (pidm, term_code, appl_no, status_code, major_code, appl_date)
VALUES (2001, '202530', 1, 'AP', 'CS', SYSDATE-10);
INSERT INTO admissions_application (pidm, term_code, appl_no, status_code, major_code, appl_date)
VALUES (2002, '202520', 1, 'AC', 'DS', SYSDATE-20);

COMMIT;
EOF

echo "Creating Oracle PL/SQL package..."
cat > $BASE_DIR/oracle/init/02_pkg_admissions_api.sql <<'EOF'
CREATE OR REPLACE PACKAGE admissions_api AS
  PROCEDURE publish_application_delta(p_term_code IN VARCHAR2, p_days_back IN NUMBER DEFAULT 7);
END admissions_api;
/

CREATE OR REPLACE PACKAGE BODY admissions_api AS
  PROCEDURE publish_application_delta(p_term_code IN VARCHAR2, p_days_back IN NUMBER DEFAULT 7) IS
  BEGIN
    INSERT INTO admissions_app_staging (pidm, term_code, appl_no, status_code, major_code, appl_date)
    SELECT a.pidm, a.term_code, a.appl_no, a.status_code, a.major_code, a.appl_date
    FROM   admissions_application a
    WHERE  a.term_code = p_term_code
    AND    a.activity_date >= SYSDATE - NVL(p_days_back, 7);

    COMMIT;
  END;
END admissions_api;
/
EOF

echo "Creating Oracle demo publish script..."
cat > $BASE_DIR/oracle/init/03_publish_demo.sql <<'EOF'
BEGIN
  admissions_api.publish_application_delta('202530', 30);
END;
/
EOF

echo "Creating SQL Server scripts..."
cat > $BASE_DIR/sqlserver/init/01_create_db.sql <<'EOF'
IF DB_ID('university_recruitment') IS NULL
  CREATE DATABASE university_recruitment;
GO
USE university_recruitment;
GO

CREATE SCHEMA wrk AUTHORIZATION dbo;
CREATE SCHEMA dwh AUTHORIZATION dbo;

CREATE TABLE dwh.dim_student (
  student_key INT IDENTITY PRIMARY KEY,
  pidm        INT UNIQUE,
  univ_id     VARCHAR(9),
  first_name  NVARCHAR(60),
  last_name   NVARCHAR(60),
  inserted_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  updated_at  DATETIME2 NULL
);

CREATE TABLE dwh.fact_application (
  application_key BIGINT IDENTITY PRIMARY KEY,
  pidm        INT,
  term_code   VARCHAR(6),
  appl_no     INT,
  status_code VARCHAR(2),
  major_code  VARCHAR(10),
  appl_date   DATE,
  inserted_at DATETIME2 DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dwh.audit_changes (
  audit_id    BIGINT IDENTITY PRIMARY KEY,
  table_name  SYSNAME,
  pk          NVARCHAR(200),
  change_type NVARCHAR(10),
  changed_at  DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

CREATE OR ALTER TRIGGER dwh.trg_fact_application_update
ON dwh.fact_application
AFTER UPDATE
AS
  INSERT INTO dwh.audit_changes(table_name, pk, change_type)
  SELECT 'dwh.fact_application', CAST(inserted.application_key AS NVARCHAR(200)), 'UPDATE'
  FROM inserted;
GO

CREATE OR ALTER PROCEDURE dwh.rank_candidates
AS
BEGIN
  SELECT
    s.pidm,
    s.first_name,
    s.last_name,
    MAX(CASE f.status_code WHEN 'AC' THEN 100 WHEN 'AP' THEN 50 ELSE 0 END)
      + DATEDIFF(DAY, MAX(f.appl_date), GETDATE()) * -1 AS score
  FROM dwh.dim_student s
  JOIN dwh.fact_application f ON f.pidm = s.pidm
  GROUP BY s.pidm, s.first_name, s.last_name
  ORDER BY score DESC;
END;
GO
EOF

cat > $BASE_DIR/sqlserver/init/02_link_oracle.sql <<'EOF'
-- Reference: linking SQL Server to Oracle (requires provider)
EXEC master.dbo.sp_addlinkedserver
  @server = N'ORCL_XE',
  @srvproduct=N'Oracle',
  @provider=N'OraOLEDB.Oracle',
  @datasrc=N'//oracle:1521/XEPDB1';

EXEC master.dbo.sp_addlinkedsrvlogin
  @rmtsrvname = N'ORCL_XE',
  @useself = 'False',
  @rmtuser = N'ADMISSIONS',
  @rmtpassword = 'AdmissionsP@ssw0rd';
GO
EOF

cat > $BASE_DIR/sqlserver/init/03_etl_from_oracle.sql <<'EOF'
USE university_recruitment;
GO

CREATE OR ALTER PROCEDURE wrk.load_oracle_deltas @term_code VARCHAR(6)
AS
BEGIN
  SET NOCOUNT ON;

  IF OBJECT_ID('wrk.app_staging') IS NULL
    CREATE TABLE wrk.app_staging (
      pidm INT, term_code VARCHAR(6), appl_no INT,
      status_code VARCHAR(2), major_code VARCHAR(10), appl_date DATE
    );

  TRUNCATE TABLE wrk.app_staging;

  INSERT INTO wrk.app_staging (pidm, term_code, appl_no, status_code, major_code, appl_date)
  SELECT pidm, term_code, appl_no, status_code, major_code, appl_date
  FROM OPENQUERY(ORCL_XE, '
    SELECT pidm, term_code, appl_no, status_code, major_code, appl_date
    FROM admissions_app_staging
    WHERE term_code = ''''' + @term_code + '''''
  ');

  MERGE dwh.dim_student AS tgt
  USING (
    SELECT s.pidm, s.univ_id, s.first_name, s.last_name
    FROM OPENQUERY(ORCL_XE, '
      SELECT pidm, univ_id, first_name, last_name
      FROM admissions_student
    ') s
    JOIN (SELECT DISTINCT pidm FROM wrk.app_staging) a ON a.pidm = s.pidm
  ) AS src
  ON tgt.pidm = src.pidm
  WHEN MATCHED THEN UPDATE SET
    univ_id = src.univ_id,
    first_name = src.first_name,
    last_name = src.last_name,
    updated_at = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (pidm, univ_id, first_name, last_name)
    VALUES (src.pidm, src.univ_id, src.first_name, src.last_name);

  INSERT INTO dwh.fact_application (pidm, term_code, appl_no, status_code, major_code, appl_date)
  SELECT s.pidm, s.term_code, s.appl_no, s.status_code, s.major_code, s.appl_date
  FROM wrk.app_staging s
  LEFT JOIN dwh.fact_application f
    ON f.pidm = s.pidm AND f.term_code = s.term_code AND f.appl_no = s.appl_no
  WHERE f.application_key IS NULL;
END;
GO
EOF

echo "✅ All files created under $BASE_DIR"
g