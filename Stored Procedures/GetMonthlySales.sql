delimiter $$
drop procedure if exists GetMonthlySales;
create procedure GetMonthlySales(
`Month`  int(2)
)
deterministic
begin

drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
       Buyer		char(20),
 		Seller 		char(20),
 		Price  		decimal(13,2),
 		`Date` 		datetime,
 		ItemName 	char(20),
		 AuctionID 	int(10) 
    );

insert into TempResultSet(Buyer, Seller, Price, `Date`, ItemName, AuctionID)
select P1.Username, P2.Username, S.Price, S.`Date`, I.Name, S.AuctionID
	from Person P1, Person P2, Sales S, Item I, Auction A
	where I.ItemID = S.ItemID and P1.SSN = S.BuyerID and P2.SSN = S.SellerID and (month(S.`Date`) = `Month`)
	group by S.AuctionID;
	

	select sum(Price) from TempResultSet;
	 select * from TempResultSet;
end $$

delimiter ;