

delimiter $$

drop procedure if exists droptables;
create procedure droptables() deterministic

  begin

    SET FOREIGN_KEY_CHECKS = 0;

	 drop table if exists customer;
    drop table if exists sales;
    drop table if exists employee;
    drop table if exists auction;
    drop table if exists post;
    drop table if exists bid;
    drop table if exists sales;
    drop table if exists person;
    drop table if exists item;

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

CREATE TABLE Customer (
  Rating  INTEGER unsigned default 1,
  CreditCardNum varchar(19) not null,
  CustomerID varchar(9),
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES Person (SSN)
  ON DELETE NO ACTION
  ON UPDATE CASCADE
);

CREATE TABLE `item` (
	`ItemID` int unsigned NOT NULL DEFAULT '0',
	`Description` VARCHAR(255) NULL DEFAULT NULL,
	`Year` year null default null,
	`Name` varchar(255) NULL DEFAULT NULL,
	`Type` enum('DVD', 'Car', 'Clothing', 'Video Game', 'Electronic', 'Miscellaneous', 'Book', 'Laptop') not NULL,
	`NumCopies` int unsigned NULL DEFAULT NULL,
	PRIMARY KEY (`ItemID`)
);


CREATE TABLE `auction` 
(
	`AuctionID` 		int unsigned,
	`BidIncrement` 	DECIMAL(13,2) unsigned	not null,
	`MinimuBid` 		DECIMAL(13,2) unsigned 	NOT NULL,
	`CurrentBid` 		DECIMAL(13,2) unsigned	NULL DEFAULT NULL,
	`CurrentHighBid` 	DECIMAL(13,2) unsigned	NULL DEFAULT NULL,
	`ClosingBid`		DECIMAL(13,2) unsigned 	NULL DEFAULT NULL,
	`Copies_Sold` 		int unsigned 				NOT NULL DEFAULT 0,
	`Monitor` 			varchar(11) 				NULL,
	`ItemID` 			int unsigned 				NOT NULL,
	`Reserve` 			decimal(13,2) unsigned 	NULL DEFAULT NULL,
	PRIMARY KEY (`AuctionID`),
	INDEX `Monitor` (`Monitor`),
	INDEX `ItemID` (`ItemID`),
	CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`Monitor`) REFERENCES `employee` (`EmployeeID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `auction_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION
);




CREATE TABLE `bid` (
	`BidID` MEDIUMINT NOT NULL AUTO_INCREMENT,
	`CustomerID` varchar(9) NULL,
	`AuctionID` int unsigned NULL DEFAULT NULL,
	`ItemID` int unsigned NOT NULL DEFAULT '0',
	`BidTime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	`BidPrice` DECIMAL(13,2) NULL DEFAULT NULL,
	`IsProxy` BIT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`BidID`, `CustomerID`, `ItemID`),
	INDEX `ItemID` (`ItemID`),
	INDEX `AuctionID` (`AuctionID`),
	CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `bid_ibfk_3` FOREIGN KEY (`AuctionID`) REFERENCES `auction` (`AuctionID`) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Post (
ExpireDate 	DATETIME,
PostDate 	DATETIME,
CustomerID 	varchar(11) null,
AuctionID 	int unsigned not null,
PRIMARY KEY (CustomerID, AuctionID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,
FOREIGN KEY (AuctionID) REFERENCES Auction(AuctionID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE         
);

CREATE TABLE `Sales` (
	`BuyerID` varchar(11) NULL,
	`SellerID` varchar(11) NULL,
	`Price` DECIMAL(13,2) NOT NULL,
	`Date` DATETIME NOT NULL,
	`ItemID` INT(10) UNSIGNED NOT NULL,
	`AuctionID` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`AuctionID`),
	INDEX `BuyerID` (`BuyerID`),
	INDEX `SellerID` (`SellerID`),
	INDEX `ItemID` (`ItemID`),
	CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`BuyerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`SellerID`) REFERENCES `customer` (`CustomerID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`AuctionID`) REFERENCES `auction` (`AuctionID`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `sales_ibfk_4` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION
);


    SET FOREIGN_KEY_CHECKS = 1;




end $$

delimiter ;
