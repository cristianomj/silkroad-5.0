drop table if exists sales ;
drop table if exists employee;
drop table if exists auction;
drop table if exists post;
drop table if exists bid;
drop table if exists sales;
drop table if exists person;
drop table if exists existsitem;

CREATE TABLE Person (
  SSN int unsigned,
  LastName CHAR(20) NOT NULL,
  FirstName CHAR(20) NOT NULL,
  Address CHAR(255),
  ZipCode INTEGER unsigned,
  Telephone char(13),
  Email CHAR(25),
  UserName char(20) unique null,
  PRIMARY KEY (SSN)
);

CREATE TABLE Employee (
  StartDate DATETIME,
  HourlyRate decimal(5,2) unsigned,
  Level INTEGER unsigned default 0,
  EmployeeID integer unsigned,
  PRIMARY KEY (EmployeeID),
  FOREIGN KEY (EmployeeID) REFERENCES Person (SSN)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

drop table if exists customer;
CREATE TABLE Customer (
  Rating  INTEGER unsigned default 1,
  CreditCardNum char(19),
  CustomerID INTEGER UNSIGNED,
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES Person (SSN)
  ON DELETE NO ACTION
  ON UPDATE CASCADE
);

CREATE TABLE `item` (
	`ItemID` int unsigned NOT NULL DEFAULT '0',
	`Description` VARCHAR(255) NULL DEFAULT NULL,
	`Year` year null default null,
	`Name` CHAR(255) NULL DEFAULT NULL,
	`Type` enum('DVD', 'Car', 'Clothing', 'Video Game', 'Electronic', 'Miscellaneous', 'Book', 'Laptop') not NULL,
	`NumCopies` int unsigned NULL DEFAULT NULL,
	PRIMARY KEY (`ItemID`)
);

CREATE TABLE `auction` (
	`AuctionID` int unsigned NOT NULL DEFAULT '0',
	`BidIncrement` DECIMAL(13,2) NULL DEFAULT NULL,
	`MinimuBid` DECIMAL(13,2) NULL DEFAULT NULL,
	`Copies_Sold` int unsigned NULL DEFAULT NULL,
	`Monitor` int unsigned NOT NULL,
	`ItemID` int unsigned NOT NULL,
	`Reserve` decimal(13,2) null default null,
	PRIMARY KEY (`AuctionID`),
	INDEX `Monitor` (`Monitor`),
	INDEX `ItemID` (`ItemID`),
	CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`Monitor`) REFERENCES `employee` (`EmployeeID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `auction_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE `bid` (
	`CustomerID` int unsigned NOT NULL DEFAULT '0',
	`AuctionID` int unsigned NULL DEFAULT NULL,
	`ItemID` int unsigned NOT NULL DEFAULT '0',
	`BidTime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	`BidPrice` DECIMAL(13,2) NULL DEFAULT NULL,
	PRIMARY KEY (`CustomerID`, `ItemID`, `BidTime`),
	INDEX `ItemID` (`ItemID`),
	INDEX `AuctionID` (`AuctionID`),
	CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `bid_ibfk_3` FOREIGN KEY (`AuctionID`) REFERENCES `auction` (`AuctionID`) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Post (
ExpireDate 	DATETIME,
PostDate 	DATETIME,
CustomerID 	int unsigned not null,
AuctionID 	int unsigned not null,
PRIMARY KEY (CustomerID, AuctionID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,
FOREIGN KEY (AuctionID) REFERENCES Auction(AuctionID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);

CREATE TABLE `sales` (
	`BuyerID` INTEGER UNSIGNED NOT NULL,
	`SellerID` INTEGER UNSIGNED NOT NULL,
	`Price` DECIMAL(13,2) NOT NULL,
	`Date` DATETIME NOT NULL,
	`ItemID` INTEGER UNSIGNED NOT NULL,
	`AuctionID` INTEGER UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`AuctionID`),
	INDEX `BuyerID` (`BuyerID`),
	INDEX `SellerID` (`SellerID`),
	INDEX `ItemID` (`ItemID`),
	CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`BuyerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`SellerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`AuctionID`) REFERENCES `auction` (`AuctionID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_4` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION
);
