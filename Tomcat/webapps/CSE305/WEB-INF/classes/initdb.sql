CREATE TABLE Professor (Id VARCHAR(20), Pswd VARCHAR(20), Name VARCHAR(20), Status VARCHAR(20));

INSERT INTO Professor VALUES ('alice', 'alice', 'Alice', 'CSE');
INSERT INTO Professor VALUES ('bob', 'bob', 'Bob', 'CSE');
INSERT INTO Professor VALUES ('cindy', 'cindy', 'Cindy', 'CSE');
INSERT INTO Professor VALUES ('david', 'david', 'David', 'CSE');
INSERT INTO Professor VALUES ('eric', 'eric', 'Eric', 'CSE');

CREATE TABLE Course (CrsCode VARCHAR(20), DeptID VARCHAR(20), CrsName VARCHAR(20), InsNo VARCHAR(20));

INSERT INTO Course VALUES ('101', 'CSE', 'Algorithms', 'alice');
INSERT INTO Course VALUES ('102', 'CSE', 'Basics', 'bob');
INSERT INTO Course VALUES ('103', 'CSE', 'Cryptography', 'cindy');
INSERT INTO Course VALUES ('104', 'CSE', 'Databases', 'david');
INSERT INTO Course VALUES ('105', 'CSE', 'Engineering', 'eric');


CREATE TABLE Student (Id VARCHAR(20), Pswd VARCHAR(20), Name VARCHAR(20), Status VARCHAR(20));

INSERT INTO Student VALUES ('stud1', 'stud1', 'Stud1', 'FRESHMAN');
INSERT INTO Student VALUES ('stud2', 'stud2', 'Stud2', 'FRESHMAN');
INSERT INTO Student VALUES ('stud3', 'stud3', 'Stud3', 'FRESHMAN');
INSERT INTO Student VALUES ('stud4', 'stud4', 'Stud4', 'FRESHMAN');
INSERT INTO Student VALUES ('stud5', 'stud5', 'Stud5', 'FRESHMAN');

CREATE TABLE Transcript (StudId VARCHAR(20), CrsCode VARCHAR(20), Semester VARCHAR(20), Grade VARCHAR(2));