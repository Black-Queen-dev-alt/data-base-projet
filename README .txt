================================================================
  UNIVERSITY MANAGEMENT SYSTEM -- CS27 End of Semester Project
  group members:
  CONGO S Anifatou
  NANA Marc
  YAMEOGO Firmin
  ZOUNGRANE Zalissa
  DAKUYO Annette Alexias Prisca
  KANTIONO Diane
  Instructor: Kweyakie Afi Blebo
================================================================

This SQL script sets up a complete university management database.
It creates all tables, inserts sample data, and demonstrates key
SQL operations including SELECT queries, JOINs, and aggregate functions.

----------------------------------------------------------------
REQUIREMENTS
----------------------------------------------------------------
- WAMP Server (includes MySQL + phpMyAdmin)
- The file: university_management.sql

----------------------------------------------------------------
HOW TO IMPORT THE FILE IN WAMP SERVER
----------------------------------------------------------------
1. Start WAMP Server and make sure the icon in the taskbar is GREEN.
2. Open your browser and go to: http://localhost/phpmyadmin
3. Log in (default: username = root, password = empty).
4. Click on "Import" in the top menu.
5. Click "Choose File" and select university_management.sql.
6. Scroll down and click "Go".
7. The database "university_management" will be created automatically
   with all tables and sample data.

----------------------------------------------------------------
DATABASE STRUCTURE — 6 TABLES
----------------------------------------------------------------

TABLE: department
  Stores the university departments.
  Columns:
    department_id   INT (PK)       Auto-increment unique identifier
    department_name VARCHAR(100)   Name of the department (unique)
    building        VARCHAR(50)    Building where the department is located
    office_phone    VARCHAR(20)    Contact phone number

TABLE: student
  Stores student information.
  Columns:
    student_id      INT (PK)       Auto-increment unique identifier
    first_name      VARCHAR(50)    Student's first name
    last_name       VARCHAR(50)    Student's last name
    date_of_birth   DATE           Date of birth
    email           VARCHAR(100)   Email address (unique)
    phone_number    VARCHAR(20)    Phone number
    enrollment_date DATE           Date of enrollment (defaults to today)
    department_id   INT (FK)       Links to department -- SET NULL on delete

TABLE: teacher
  Stores teacher information.
  Columns:
    teacher_id      INT (PK)       Auto-increment unique identifier
    first_name      VARCHAR(50)    Teacher's first name
    last_name       VARCHAR(50)    Teacher's last name
    email           VARCHAR(100)   Email address (unique)
    phone_number    VARCHAR(20)    Phone number
    hire_date       DATE           Date hired
    department_id   INT (FK)       Links to department -- CASCADE on delete

TABLE: course
  Stores course information.
  Columns:
    course_id       INT (PK)       Auto-increment unique identifier
    course_code     VARCHAR(20)    Short code like CS101 (unique)
    course_name     VARCHAR(100)   Full name of the course
    credits         INT            Number of credits (must be between 1 and 6)
    description     TEXT           Course description
    teacher_id      INT (FK)       Links to teacher -- SET NULL on delete
    department_id   INT (FK)       Links to department -- CASCADE on delete

TABLE: enrollment
  Junction table that links students to courses.
  Represents a student registered in a course for a given semester.
  Columns:
    enrollment_id   INT (PK)           Auto-increment unique identifier
    student_id      INT (FK)           Links to student -- CASCADE on delete
    course_id       INT (FK)           Links to course -- CASCADE on delete
    semester        ENUM('S1','S2')    Semester of enrollment
    academic_year   VARCHAR(9)         e.g. 2024-2025
    enrollment_date DATE               Date of enrollment (defaults to today)
  Note: A student cannot be enrolled in the same course twice
        in the same semester and academic year (UNIQUE constraint).

TABLE: grade
  Stores the final grade for each enrollment.
  One enrollment has at most one grade (1:1 relationship).
  Columns:
    grade_id        INT (PK)       Auto-increment unique identifier
    enrollment_id   INT (FK)       Links to enrollment -- CASCADE on delete (unique)
    grade_value     DECIMAL(4,2)   Grade between 0.00 and 20.00
    grade_date      DATE           Date the grade was recorded (defaults to today)
    comments        TEXT           Teacher's comment on the grade

----------------------------------------------------------------
RELATIONSHIPS BETWEEN TABLES
----------------------------------------------------------------

  department ──1:N──> student
  department ──1:N──> teacher
  department ──1:N──> course
  teacher    ──1:N──> course
  student   ──M:N──> course    (via enrollment junction table)
  enrollment ──1:1──> grade

----------------------------------------------------------------
SAMPLE DATA INCLUDED
----------------------------------------------------------------

  Table        Records
  ----------   -------
  department       4
  teacher         10
  student         15
  course          12
  enrollment      30
  grade           25

----------------------------------------------------------------
SCRIPT SECTIONS EXPLAINED
----------------------------------------------------------------

PART 1 -- TABLE CREATION
  Creates the database and all 6 tables with their constraints:
    PRIMARY KEY  -- uniquely identifies each row
    FOREIGN KEY  -- links tables together and enforces referential integrity
    NOT NULL     -- ensures required fields are always filled
    UNIQUE       -- prevents duplicate values (e.g. two students with the same email)
    CHECK        -- validates data (credits between 1-6, grades between 0-20)
    DEFAULT      -- automatically sets a value if none is provided
                    (e.g. enrollment_date = today)

PART 2.2 -- DATA INSERTION
  Populates all tables using INSERT INTO statements with realistic sample data.

PART 2.3 -- UPDATE & DELETE
  Demonstrates how to modify and remove data:
    UPDATE 1 -- changes a student's email address
    UPDATE 2 -- increases the credits of a course
    UPDATE 3 -- corrects a grade value with a comment
    DELETE 1 -- removes an enrollment; the associated grade is automatically
                deleted thanks to ON DELETE CASCADE
    DELETE 2 -- removes a student who left the university

  A referential integrity violation example is included in comments:
  trying to insert a student with a department_id that does not exist
  will produce an error.

PART 2.4 -- SELECT QUERIES
  A series of queries showing different ways to retrieve data:

    SELECT *         Retrieves all columns from a table
    WHERE            Filters rows based on a condition
    ORDER BY         Sorts results (ascending or descending)
    LIMIT            Restricts the number of rows returned
    LIKE             Filters using a text pattern
                     (e.g. emails ending in @student.univ.edu)
    BETWEEN          Filters values within a range
                     (e.g. grades between 14 and 18)
    IN               Filters rows matching a list of values
    INNER JOIN       Returns only rows that have a match in both tables
    LEFT JOIN        Returns all rows from the left table,
                     even if there is no match on the right
    Multi-table JOIN Connects 5 tables to show student, course,
                     teacher, and grade together
    IS NULL          Finds students enrolled in courses but not yet graded

PART 3 -- AGGREGATE FUNCTIONS & REPORTING

    COUNT(*)         Counts the total number of rows
    MAX / MIN        Finds the highest and lowest grade
    AVG              Calculates the average grade across all records
    GROUP BY         Groups results by department and calculates
                     the average per group
    HAVING           Filters groups -- shows only courses where
                     the average grade is below 12
    Summary report   Combines JOIN, GROUP BY, and HAVING to show
                     each teacher's number of courses, number of
                     students, and grade statistics

----------------------------------------------------------------
CONSTRAINTS SUMMARY
----------------------------------------------------------------

  ON DELETE CASCADE  -- teacher -> department
                     -- course -> department
                     -- enrollment -> student / course
                     -- grade -> enrollment

  ON DELETE SET NULL -- student -> department
                     -- course -> teacher

================================================================
END OF README
================================================================
