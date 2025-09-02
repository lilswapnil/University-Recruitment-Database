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
