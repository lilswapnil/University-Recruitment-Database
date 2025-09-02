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
