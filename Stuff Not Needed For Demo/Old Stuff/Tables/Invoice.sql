-- Create the table to hold the invoices for an auction
-- When an auction is finished and a payment is made, a row
-- is added to this table that will serve as a way
-- to get the history of payments
create table Invoice (
	InvoiceID 			int unsigned 	auto_increment primary key,
	AuctionID 			int unsigned 	not null,
	SellerID 			int unsigned 	not null,
	BuyerID 				int unsigned 	not null,
	EmployeeID 			int unsigned 	not null,
	ItemID 				int unsigned 	not null,
	OrderTime 			datetime 		not null,	
	OrderAmount 		int unsigned 	not null,	
	Revenue 				decimal(11,2)	unsigned not null, -- How much money the Auction House gets from the order
	
	foreign key(ItemID) -- Note: this database is run on the InnoDB engine so there are automatic indices on foreign keys
		references Item(ItemID)
		on update cascade,
	foreign key(SellerID)
		references Customer(CustomerID)
		on update cascade,
	foreign key(BuyerID)
		references Customer(CustomerID)
		on update cascade,
	foreign key(EmployeeID)
		references Employee(SSN)
		on update cascade,		
	foreign key(AuctionID)
		references Auction(AuctionID)
		on update cascade
);
	