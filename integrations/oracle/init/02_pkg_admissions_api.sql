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
