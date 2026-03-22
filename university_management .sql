-- ============================================================
--   UNIVERSITY MANAGEMENT SYSTEM — CS27 End of Semester Project
  --group members:
 -- CONGO S Anifatou
 -- NANA Marc
 -- YAMEOGO Firmin
 -- ZOUNGRANE Zalissa
 -- DAKUYO Annette Alexias Prisca
 --KANTIONO Diane

--   Instructor: Kweyakie Afi Blebo 
-- ============================================================


-- ============================================================
-- PART 1 : DATABASE AND TABLE CREATION
-- ============================================================

CREATE DATABASE IF NOT EXISTS university_management;
USE university_management;

-- ────────────────────────────────────────────
-- Table : department
-- ────────────────────────────────────────────
CREATE TABLE department (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    building        VARCHAR(50),
    office_phone    VARCHAR(20)
);

-- ────────────────────────────────────────────
-- Table : student
-- ────────────────────────────────────────────
CREATE TABLE student (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone_number    VARCHAR(20),
    enrollment_date DATE         NOT NULL DEFAULT (CURRENT_DATE),
    department_id   INT,
    FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE SET NULL
);

-- ────────────────────────────────────────────
-- Table : teacher
-- ────────────────────────────────────────────
CREATE TABLE teacher (
    teacher_id    INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone_number  VARCHAR(20),
    hire_date     DATE         NOT NULL,
    department_id INT          NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE CASCADE
);

-- ────────────────────────────────────────────
-- Table : course
-- ────────────────────────────────────────────
CREATE TABLE course (
    course_id     INT AUTO_INCREMENT PRIMARY KEY,
    course_code   VARCHAR(20)  NOT NULL UNIQUE,
    course_name   VARCHAR(100) NOT NULL,
    credits       INT          NOT NULL CHECK (credits BETWEEN 1 AND 6),
    description   TEXT,
    teacher_id    INT,
    department_id INT          NOT NULL,
    FOREIGN KEY (teacher_id)    REFERENCES teacher(teacher_id)       ON DELETE SET NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE CASCADE
);

-- ────────────────────────────────────────────
-- Table : enrollment
-- ────────────────────────────────────────────
CREATE TABLE enrollment (
    enrollment_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT          NOT NULL,
    course_id       INT          NOT NULL,
    semester        ENUM('S1','S2') NOT NULL,
    academic_year   VARCHAR(9)   NOT NULL,
    enrollment_date DATE         NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES course(course_id)   ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id, semester, academic_year)
);

-- ────────────────────────────────────────────
-- Table : grade
-- ────────────────────────────────────────────
CREATE TABLE grade (
    grade_id      INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT          NOT NULL UNIQUE,
    grade_value   DECIMAL(4,2) CHECK (grade_value BETWEEN 0 AND 20),
    grade_date    DATE         NOT NULL DEFAULT (CURRENT_DATE),
    comments      TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE
);


-- ============================================================
-- PART 2.2 : DATA INSERTION
-- ============================================================

-- 4 Departments
INSERT INTO department (department_name, building, office_phone) VALUES
('Computer Science', 'Building A', '12-34-56-78'),
('Mathematics',      'Building B', '23-45-67-89'),
('Physics',          'Building C', '34-56-78-90'),
('Chemistry',        'Building D', '45-67-89-01');

-- 10 Teachers
INSERT INTO teacher (first_name, last_name, email, phone_number, hire_date, department_id) VALUES
('Moussa',     'Diallo',    'm.diallo@univ.edu',     '70-11-22-33', '2020-09-01', 1),
('Aminata',    'Traore',    'a.traore@univ.edu',     '71-22-33-44', '2019-10-15', 2),
('Thomas',     'Kone',      't.kone@univ.edu',       '72-33-44-55', '2021-01-10', 3),
('Fatou',      'Sy',        'f.sy@univ.edu',         '73-44-55-66', '2018-03-20', 4),
('Ibrahim',    'Ouedraogo', 'i.ouedraogo@univ.edu',  '74-55-66-77', '2022-02-01', 1),
('Claire',     'Zongo',     'c.zongo@univ.edu',      '75-66-77-88', '2020-11-12', 2),
('Mamadou',    'Sanou',     'm.sanou@univ.edu',      '76-77-88-99', '2017-08-25', 3),
('Josephine',  'Boni',      'j.boni@univ.edu',       '77-88-99-00', '2019-04-30', 4),
('Adama',      'Compaore',  'a.compaore@univ.edu',   '78-99-00-11', '2021-07-19', 1),
('Rokia',      'Dembele',   'r.dembele@univ.edu',    '79-00-11-22', '2022-09-05', 2);

-- 15 Students
INSERT INTO student (first_name, last_name, date_of_birth, email, phone_number, enrollment_date, department_id) VALUES
('John',       'Kone',      '2003-05-12', 'john.kone@student.univ.edu',       '60-11-22-33', '2024-10-01', 1),
('Mary',       'Traore',    '2004-02-18', 'mary.traore@student.univ.edu',      '61-22-33-44', '2024-10-01', 2),
('Paul',       'Ouedraogo', '2003-11-07', 'paul.ouedraogo@student.univ.edu',   '62-33-44-55', '2024-10-01', 3),
('Sophie',     'Diallo',    '2004-07-22', 'sophie.diallo@student.univ.edu',    '63-44-55-66', '2024-10-01', 4),
('Ahmed',      'Sanou',     '2003-09-30', 'ahmed.sanou@student.univ.edu',      '64-55-66-77', '2024-10-01', 1),
('Alice',      'Zongo',     '2004-01-15', 'alice.zongo@student.univ.edu',      '65-66-77-88', '2024-10-01', 2),
('David',      'Boni',      '2003-03-10', 'david.boni@student.univ.edu',       '66-77-88-99', '2024-10-01', 3),
('Emma',       'Compaore',  '2004-06-25', 'emma.compaore@student.univ.edu',    '67-88-99-00', '2024-10-01', 4),
('Lucas',      'Dembele',   '2003-12-05', 'lucas.dembele@student.univ.edu',    '68-99-00-11', '2024-10-01', 1),
('Chloe',      'Kabore',    '2004-08-14', 'chloe.kabore@student.univ.edu',     '69-00-11-22', '2024-10-01', 2),
('Mohamed',    'Sawadogo',  '2003-04-19', 'mohamed.sawadogo@student.univ.edu', '70-11-22-44', '2024-10-01', 3),
('Fatoumata',  'Barry',     '2004-10-09', 'fatoumata.barry@student.univ.edu',  '71-22-44-55', '2024-10-01', 4),
('Oumar',      'Sissoko',   '2003-01-28', 'oumar.sissoko@student.univ.edu',    '72-33-55-66', '2024-10-01', 1),
('Awa',        'Cisse',     '2004-09-17', 'awa.cisse@student.univ.edu',        '73-44-66-77', '2024-10-01', 2),
('Ibrahim',    'Toure',     '2003-07-03', 'ibrahim.toure@student.univ.edu',    '74-55-77-88', '2024-10-01', 3);

-- 12 Courses
INSERT INTO course (course_code, course_name, credits, description, teacher_id, department_id) VALUES
('CS101',   'Introduction to Programming', 4, 'Python basics and algorithms',      1, 1),
('CS201',   'Databases',                   4, 'SQL and relational design',          5, 1),
('MATH101', 'Mathematical Analysis',       5, 'Functions, limits, derivatives',     2, 2),
('MATH201', 'Linear Algebra',              4, 'Matrices and vectors',               6, 2),
('PHY101',  'Classical Mechanics',         4, 'Newton\'s laws',                     3, 3),
('PHY201',  'Electromagnetism',            5, 'Electric and magnetic fields',        7, 3),
('CHM101',  'General Chemistry',           4, 'Atoms and molecules',                4, 4),
('CHM201',  'Organic Chemistry',           5, 'Organic reactions',                  8, 4),
('CS301',   'Web Programming',             4, 'HTML, CSS, JavaScript',              9, 1),
('MATH301', 'Probability',                 3, 'Statistics and probability',         10, 2),
('PHY301',  'Thermodynamics',              4, 'Heat and energy',                    7, 3),
('CHM301',  'Analytical Chemistry',        4, 'Analysis methods',                   8, 4);

-- 30 Enrollments
INSERT INTO enrollment (student_id, course_id, semester, academic_year, enrollment_date) VALUES
(1,  1,  'S1', '2024-2025', '2024-10-02'),
(1,  3,  'S1', '2024-2025', '2024-10-02'),
(1,  5,  'S1', '2024-2025', '2024-10-02'),
(2,  2,  'S1', '2024-2025', '2024-10-02'),
(2,  4,  'S1', '2024-2025', '2024-10-02'),
(3,  7,  'S1', '2024-2025', '2024-10-02'),
(3,  9,  'S1', '2024-2025', '2024-10-02'),
(4,  8,  'S1', '2024-2025', '2024-10-02'),
(4,  12, 'S1', '2024-2025', '2024-10-02'),
(5,  1,  'S1', '2024-2025', '2024-10-03'),
(5,  2,  'S1', '2024-2025', '2024-10-03'),
(6,  3,  'S1', '2024-2025', '2024-10-03'),
(6,  4,  'S1', '2024-2025', '2024-10-03'),
(7,  5,  'S1', '2024-2025', '2024-10-03'),
(7,  6,  'S1', '2024-2025', '2024-10-03'),
(8,  7,  'S1', '2024-2025', '2024-10-03'),
(8,  8,  'S1', '2024-2025', '2024-10-03'),
(9,  1,  'S1', '2024-2025', '2024-10-04'),
(9,  9,  'S1', '2024-2025', '2024-10-04'),
(10, 2,  'S1', '2024-2025', '2024-10-04'),
(10, 10, 'S1', '2024-2025', '2024-10-04'),
(11, 3,  'S1', '2024-2025', '2024-10-04'),
(11, 11, 'S1', '2024-2025', '2024-10-04'),
(12, 4,  'S1', '2024-2025', '2024-10-04'),
(12, 12, 'S1', '2024-2025', '2024-10-04'),
(13, 5,  'S1', '2024-2025', '2024-10-05'),
(13, 9,  'S1', '2024-2025', '2024-10-05'),
(14, 6,  'S1', '2024-2025', '2024-10-05'),
(14, 10, 'S1', '2024-2025', '2024-10-05'),
(15, 7,  'S1', '2024-2025', '2024-10-05');

-- 25 Grades
INSERT INTO grade (enrollment_id, grade_value, grade_date, comments) VALUES
(1,  16.5, '2025-01-15', 'Excellent work'),
(2,  14.0, '2025-01-16', 'Good work'),
(3,  12.5, '2025-01-17', 'Can improve'),
(4,  15.0, '2025-01-15', 'Very good'),
(5,  17.0, '2025-01-16', 'Excellent'),
(6,  10.5, '2025-01-17', 'Passable'),
(7,  13.0, '2025-01-15', 'Good'),
(8,  18.0, '2025-01-16', 'Congratulations'),
(9,  11.0, '2025-01-17', 'Needs improvement'),
(10, 14.5, '2025-01-18', 'Good work'),
(11, 16.0, '2025-01-18', 'Very good'),
(12, 12.0, '2025-01-19', 'Passable'),
(13, 15.5, '2025-01-19', 'Good'),
(14,  9.5, '2025-01-20', 'Insufficient'),
(15, 13.5, '2025-01-20', 'Correct'),
(16, 14.0, '2025-01-21', 'Good'),
(17, 16.5, '2025-01-21', 'Excellent'),
(18, 12.5, '2025-01-22', 'Can improve'),
(19, 17.5, '2025-01-22', 'Very good'),
(20, 15.0, '2025-01-23', 'Good'),
(21, 11.5, '2025-01-23', 'Passable'),
(22, 13.0, '2025-01-24', 'Good'),
(23, 14.5, '2025-01-24', 'Good work'),
(24, 16.0, '2025-01-25', 'Excellent'),
(25, 10.0, '2025-01-25', 'Insufficient');


-- ============================================================
-- PART 2.3 : UPDATE & DELETE
-- ============================================================

-- UPDATE 1 : Change a student's email
UPDATE student
SET email = 'john.kone@new.univ.edu'
WHERE student_id = 1;

-- UPDATE 2 : Increase a course's credits
UPDATE course
SET credits = 5
WHERE course_code = 'CS101';

-- UPDATE 3 : Correct a grade
UPDATE grade
SET grade_value = 15.0,
    comments    = 'Grade corrected after review'
WHERE grade_id = 5;

-- DELETE 1 : Remove an enrollment (the associated grade is deleted by CASCADE)
DELETE FROM enrollment
WHERE student_id = 15 AND course_id = 7;

-- DELETE 2 : Remove a student who left the university
DELETE FROM student
WHERE student_id = 14;

-- Referential integrity violation example:
-- The query below will fail because department_id = 999 does not exist
-- INSERT INTO student (first_name, last_name, date_of_birth, email, department_id)
-- VALUES ('Test', 'User', '2000-01-01', 'test@univ.edu', 999);
-- Error: Cannot add or update a child row: a foreign key constraint fails


-- ============================================================
-- PART 2.4 : SELECT QUERIES
-- ============================================================

-- Retrieve all records from a table
SELECT * FROM student;

-- Specific columns with a WHERE condition
SELECT first_name, last_name, email
FROM student
WHERE department_id = 1;

-- Sorted results using ORDER BY
SELECT first_name, last_name, grade_value
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN grade g      ON e.enrollment_id = g.enrollment_id
ORDER BY grade_value DESC;

-- Limited results using LIMIT
SELECT course_name, credits
FROM course
ORDER BY credits DESC
LIMIT 5;

-- Filter using LIKE
SELECT first_name, last_name, email
FROM student
WHERE email LIKE '%@student.univ.edu';

-- Filter using BETWEEN
SELECT *
FROM grade
WHERE grade_value BETWEEN 14 AND 18;

-- Filter using IN
SELECT course_name, credits
FROM course
WHERE department_id IN (1, 2, 3);

-- INNER JOIN across two tables
SELECT s.first_name, s.last_name, c.course_name
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN course c     ON e.course_id  = c.course_id
WHERE s.student_id = 1;

-- LEFT JOIN — returns all courses even without a grade
--   Difference: INNER JOIN would only return courses that have a grade.
SELECT c.course_name, g.grade_value
FROM course c
LEFT JOIN enrollment e ON c.course_id       = e.course_id
LEFT JOIN grade g      ON e.enrollment_id   = g.enrollment_id;

-- JOIN across 5 tables
SELECT
    s.first_name  AS student_first,
    s.last_name   AS student_last,
    c.course_name,
    t.first_name  AS teacher_first,
    t.last_name   AS teacher_last,
    g.grade_value
FROM student s
JOIN enrollment e ON s.student_id    = e.student_id
JOIN course c     ON e.course_id     = c.course_id
JOIN teacher t    ON c.teacher_id    = t.teacher_id
LEFT JOIN grade g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_value IS NOT NULL
ORDER BY g.grade_value DESC;

-- Using IS NULL — students with no grade in some courses
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM student s
JOIN enrollment e ON s.student_id    = e.student_id
JOIN course c     ON e.course_id     = c.course_id
LEFT JOIN grade g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;


-- ============================================================
-- PART 3 : AGGREGATE FUNCTIONS & REPORTING
-- ============================================================

-- COUNT — total number of students
SELECT COUNT(*) AS total_students FROM student;

-- MAX and MIN of grade values
SELECT
    MAX(grade_value) AS maximum_grade,
    MIN(grade_value) AS minimum_grade
FROM grade;

-- AVG — overall average of all grades
SELECT AVG(grade_value) AS overall_average FROM grade;

-- GROUP BY — average grade per department
SELECT
    d.department_name,
    AVG(g.grade_value) AS department_average
FROM department d
JOIN course c     ON d.department_id = c.department_id
JOIN enrollment e ON c.course_id     = e.course_id
JOIN grade g      ON e.enrollment_id = g.enrollment_id
GROUP BY d.department_name;

-- HAVING — courses with an average grade below 12
SELECT
    c.course_name,
    AVG(g.grade_value) AS course_average,
    COUNT(g.grade_id)  AS student_count
FROM course c
JOIN enrollment e ON c.course_id     = e.course_id
JOIN grade g      ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_name
HAVING AVG(g.grade_value) < 12;

-- Summary report: teacher performance
--         (JOIN + GROUP BY + HAVING)
SELECT
    CONCAT(t.first_name, ' ', t.last_name) AS professor,
    d.department_name                       AS department,
    COUNT(DISTINCT c.course_id)             AS number_of_courses,
    COUNT(DISTINCT e.student_id)            AS number_of_students,
    ROUND(AVG(g.grade_value), 2)            AS average_grade,
    ROUND(MAX(g.grade_value), 2)            AS best_grade,
    ROUND(MIN(g.grade_value), 2)            AS worst_grade
FROM teacher t
JOIN department d  ON t.department_id = d.department_id
LEFT JOIN course c ON t.teacher_id    = c.teacher_id
LEFT JOIN enrollment e ON c.course_id = e.course_id
LEFT JOIN grade g  ON e.enrollment_id = g.enrollment_id
GROUP BY t.teacher_id, d.department_name
HAVING COUNT(DISTINCT e.student_id) > 0
ORDER BY average_grade DESC;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
