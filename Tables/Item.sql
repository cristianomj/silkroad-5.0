CREATE TABLE `item` (
	`ItemID` int unsigned NOT NULL DEFAULT '0',
	`Description` VARCHAR(255) NULL DEFAULT NULL,
	`Year` year null default null,
	`Name` varchar(255) NULL DEFAULT NULL,
	`Type` enum('DVD', 'Car', 'Clothing', 'Video Game', 'Electronic', 'Miscellaneous', 'Book', 'Laptop') not NULL,
	`NumCopies` int unsigned NULL DEFAULT NULL,
	PRIMARY KEY (`ItemID`)
);
