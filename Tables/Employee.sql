CREATE TABLE Employee (
  StartDate DATETIME,
  HourlyRate decimal(5,2) unsigned,
  Level INTEGER unsigned default 0,
  EmployeeID varchar(9),
  PRIMARY KEY (EmployeeID),
  FOREIGN KEY (EmployeeID) REFERENCES Person (SSN)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);