USE School;
CREATE TABLE Student(
id INT PRIMARY KEY,
Name VARCHAR (20),
Age INT NOT NULL
);

INSERT INTO Student VALUES (1, "Jazzy", 26);
INSERT INTO Student VALUES (2, "Frnzy", 28);

SELECT * FROM Student;

INSERT INTO Student 
(id,Name, Age)
VALUES 
(102,"karan",22),
(103,"arjun",234);

SELECT * FROM Student;