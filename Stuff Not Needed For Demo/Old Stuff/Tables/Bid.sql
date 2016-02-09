-- Create the table to hold a bid that a Customer will make.
-- This table will be useful for getting the history of an auction
-- because it will keep track of every single bid made to an auction
create table Bid(
	AuctionID 			int unsigned 	not null,
	TimeOfBid 			datetime			not null,
	BidAmount 			decimal(5,2) 	unsigned not null,
	CustomerID 		int unsigned 	not null,
	
	primary key(CustomerID, AuctionID, TimeOfBid),
	foreign key(AuctionID) references Auction(AuctionID)
		on delete no action
		on update cascade,
	foreign key(CustomerID) references Customer(CustomerID)
		on delete no action
		on update cascade
);