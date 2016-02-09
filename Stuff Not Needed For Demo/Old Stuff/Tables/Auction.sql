create table Auction (
	AuctionID 		int unsigned 				auto_increment primary key,
	Monitor 		int unsigned 				not null,
	ItemID 			int unsigned 				not null,
	Increment 		decimal(5,2) unsigned 	not null,
	Reserve 			decimal(5,2) unsigned 	not null,
	CopiesSold 		int unsigned 				default 0,	
	OpeningBid 		decimal(5,2) unsigned 	not null,
	ClosingBid 		decimal(5,2) unsigned 	null,
	CurrentBid 		decimal(5,2) unsigned 	null,
	CurrentHighBid decimal(5,2) unsigned 	null,
	
	foreign key (ItemID) 
      references Item(ItemID)
				on delete no action
				on update cascade,
	foreign key (Monitor)
     	references Employee(SSN)
				on delete no action
		  	on update cascade
);