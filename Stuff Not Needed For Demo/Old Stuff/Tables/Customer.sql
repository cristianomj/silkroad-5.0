-- Create table to hold the data for a customer. 
-- A customer can be a Buyer or a Seller. In one auction 
-- a customer can be the buyer, in another auction the same customer
-- can be the seller.
create table Customer (
	CustomerID 			  int unsigned 	auto_increment primary key,
	CreditCardNumber 	varchar(25) 		not null,
	Rating 						  int 						default 1
);