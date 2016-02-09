CREATE TABLE `auction` 
(
	`AuctionID` 		int unsigned,
	`BidIncrement` 	DECIMAL(13,2) unsigned	NULL DEFAULT NULL,
	`MinimuBid` 		DECIMAL(13,2) unsigned 	NOT NULL,
	`CurrentBid` 		DECIMAL(13,2) unsigned	NULL DEFAULT NULL,
	`CurrentHighBid` 	DECIMAL(13,2) unsigned	NULL DEFAULT NULL,
	`ClosingBid`		DECIMAL(13,2) unsigned 	NULL DEFAULT NULL,
	`Copies_Sold` 		int unsigned 				NOT NULL DEFAULT 0,
	`Monitor` 			varchar(11) 				NOT NULL,
	`ItemID` 			int unsigned 				NOT NULL,
	`Reserve` 			decimal(13,2) unsigned 	NULL DEFAULT NULL,
	PRIMARY KEY (`AuctionID`),
	INDEX `Monitor` (`Monitor`),
	INDEX `ItemID` (`ItemID`),
	CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`Monitor`) REFERENCES `employee` (`EmployeeID`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `auction_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON UPDATE CASCADE ON DELETE NO ACTION
);
