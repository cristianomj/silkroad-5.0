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