CREATE TABLE Customer (
  Rating  INTEGER unsigned default 1,
  CreditCardNum varchar(19) not null,
  CustomerID varchar(9),
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES Person (SSN)
  ON DELETE NO ACTION
  ON UPDATE CASCADE
);