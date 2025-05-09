DROP TABLE IF EXISTS STUDENT_ASSESSMENT_GRADE;
DROP TABLE IF EXISTS STUDENT_UNIT_GRADE;
DROP TABLE IF EXISTS STUDENT_COURSE_PROGRESS;
DROP TABLE IF EXISTS ASSESSMENT;
DROP TABLE IF EXISTS UNIT;
DROP TABLE IF EXISTS COURSE;
DROP TABLE IF EXISTS STUDENT;

CREATE TABLE STUDENT(
    stud_id     INT NOT NULL,
    stud_wam    DECIMAL(6, 3),
    stud_weighted_creddone    INT DEFAULT 0,
    PRIMARY KEY (stud_id)
)
;

CREATE TABLE COURSE(
    course_code     VARCHAR(5)      NOT NULL,
    course_name     VARCHAR(50)     NOT NULL,
    course_reqcred  INT             NOT NULL,
    PRIMARY KEY (course_code)
)
;

CREATE TABLE UNIT(
    course_code     VARCHAR(5)      NOT NULL,
    unit_code       VARCHAR(7)      NOT NULL,
    unit_credits    INT             NOT NULL,
    unit_wam_weight DECIMAL(2,1)    NOT NULL,
    PRIMARY KEY (unit_code),
    FOREIGN KEY (course_code) REFERENCES COURSE(course_code)
)
;

CREATE TABLE ASSESSMENT(
    ass_id          INT             AUTO_INCREMENT PRIMARY KEY,
    unit_code       VARCHAR(7)      NOT NULL,
    ass_name        VARCHAR(50)     NOT NULL,
    ass_weight      DECIMAL(6,3)    NOT NULL,
    ass_deadline    DATE,
    FOREIGN KEY (unit_code) REFERENCES UNIT(unit_code)
)
;

CREATE TABLE STUDENT_COURSE_PROGRESS(
    stud_id     INT                 NOT NULL,
    course_code VARCHAR(5)          NOT NULL,
    course_creddone INT             DEFAULT 0,
    PRIMARY KEY (stud_id, course_code), 
    FOREIGN KEY (stud_id) REFERENCES STUDENT(stud_id),
    FOREIGN KEY (course_code) REFERENCES COURSE(course_code)
)
;

CREATE TABLE STUDENT_UNIT_GRADE(
    stud_id     INT                 NOT NULL,
    unit_code   VARCHAR(7)          NOT NULL,
    unit_grade  DECIMAL(6,3),
    unit_completed_weight   DECIMAL(6,3) DEFAULT 0,
    PRIMARY KEY (stud_id, unit_code),
    FOREIGN KEY (stud_id) REFERENCES STUDENT(stud_id),
    FOREIGN KEY (unit_code) REFERENCES UNIT(unit_code)
)
;

CREATE TABLE STUDENT_ASSESSMENT_GRADE(
    stud_id     INT                 NOT NULL,
    ass_id      INT                 NOT NULL,
    ass_grade   DECIMAL(6,3),
    PRIMARY KEY (stud_id, ass_id),
    FOREIGN KEY (stud_id) REFERENCES STUDENT(stud_id),
    FOREIGN KEY (ass_id) REFERENCES ASSESSMENT(ass_id)
)
;

