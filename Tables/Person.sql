CREATE TABLE Person (
  SSN varchar(9),
  LastName varchar(20) NOT NULL,
  FirstName varchar(20) NOT NULL,
  Address varchar(255) not null,
  ZipCode varchar(11) not null,
  Telephone varchar(13),
  Email varchar(50) not null,
  Username varchar(20) unique not null,
  Password varchar(20) not null,
  Type enum ('Employee', 'Customer') not null,
  PRIMARY KEY (SSN)
);