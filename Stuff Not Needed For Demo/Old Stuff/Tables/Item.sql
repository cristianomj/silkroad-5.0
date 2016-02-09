-- Create the table to hold the items to be sold
create table Item (
		ItemID 			int unsigned 	auto_increment primary key,
		Description		blob 				null,
		ItemYear 		year 				null,
		Name 				varchar(255) 	not null unique,
		ItemType 		enum('DVD', 'Car', 'Clothing', 'Video Game', 'Electronic', 'Miscellaneous', 'Book', 'Laptop') not null,
		NumCopies 		int unsigned 	default 0,
		
		index ByType(ItemType),
		index ByNumCopies(NumCopies),
		index ByName(Name)
);
