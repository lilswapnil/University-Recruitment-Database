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
