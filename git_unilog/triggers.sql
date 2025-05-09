CREATE TRIGGER after_assessment_graded
AFTER INSERT ON STUDENT_ASSESSMENT_GRADE
FOR EACH ROW
BEGIN
    DECLARE completed_ass_weight DECIMAL(5,2);
    
    SELECT ass_weight INTO completed_ass_weight
    FROM ASSESSMENT
    WHERE ass_id = NEW.ass_id;

    UPDATE STUDENT_UNIT_GRADE
    SET unit_grade = (NEW.ass_grade*completed_ass_weight)+(unit_grade*unit_completed_weight)/(unit_completed_weight+completed_ass_weight),
        unit_completed_weight = unit_completed_weight + completed_ass_weight
    WHERE unit_code = (SELECT unit_code FROM ASSESSMENT WHERE ass_id = NEW.ass_id);
END;

CREATE TRIGGER after_unit_grade_added
AFTER INSERT ON STUDENT_UNIT_GRADE
FOR EACH ROW
BEGIN
    DECLARE completed_unit_credits DECIMAL(5,2);
    DECLARE completed_unit_wamweight    INT;
    DECLARE completed_unit_coursecode   VARCHAR(5);

    SELECT unit_credits INTO completed_unit_credits
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    SELECT unit_wam_weight*unit_credits INTO completed_unit_wamweight
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    SELECT course_code INTO completed_unit_coursecode
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    IF NEW.unit_completed_weight = 100 THEN

        UPDATE STUDENT
        SET stud_wam = COALESCE(((NEW.unit_grade*completed_unit_wamweight)+(stud_wam*stud_weighted_creddone))/(stud_weighted_creddone+completed_unit_wamweight), NEW.unit_grade),
            stud_weighted_creddone = stud_weighted_creddone + completed_unit_wamweight
        WHERE stud_id = NEW.stud_id;

        INSERT INTO DEBUG (msg1, msg2)
        VALUES (NEW.unit_code, completed_unit_credits);

        UPDATE STUDENT_COURSE_PROGRESS
        SET course_creddone = course_creddone + completed_unit_credits
        WHERE stud_id = NEW.stud_id AND course_code = completed_unit_coursecode;

    END IF;
END;

CREATE TRIGGER after_unit_graded
AFTER UPDATE ON STUDENT_UNIT_GRADE
FOR EACH ROW
BEGIN
    DECLARE completed_unit_credits DECIMAL(5,2);
    DECLARE completed_unit_wamweight    INT;
    DECLARE completed_unit_coursecode   VARCHAR(5);

    SELECT unit_credits INTO completed_unit_credits
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    SELECT unit_wam_weight*unit_credits INTO completed_unit_wamweight
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    SELECT course_code INTO completed_unit_coursecode
    FROM UNIT
    WHERE unit_code = NEW.unit_code;

    IF NEW.unit_completed_weight = 100 AND OLD.unit_completed_weight != NEW.unit_completed_weight THEN

        UPDATE STUDENT
        SET stud_wam = COALESCE(((NEW.unit_grade*completed_unit_wamweight)+(stud_wam*stud_weighted_creddone))/(stud_weighted_creddone+completed_unit_wamweight), NEW.unit_grade),
            stud_weighted_creddone = stud_weighted_creddone + completed_unit_wamweight
        WHERE stud_id = NEW.stud_id;

        UPDATE STUDENT_COURSE_PROGRESS
        SET course_creddone = course_creddone + completed_unit_credits
        WHERE stud_id = NEW.stud_id AND course_code = completed_unit_coursecode;

    END IF;
END;






    