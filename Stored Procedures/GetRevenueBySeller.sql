delimiter $$
drop procedure if exists GetRevenueBySeller;
create procedure GetRevenueBySeller(
	Username1		char(20)
	)
deterministic
begin

drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
 		Username 		char(20),
 		ItemsSold		int(15),
 		Revenue  		decimal(13,2)
    );
SET @cnt := 0;
insert into TempResultSet(Username, ItemsSold, Revenue)
select P.Username, @cnt := @cnt + 1, S.Price
	from Person P, Sales S, Customer C, Auction A
	where C.CustomerID = P.SSN and S.AuctionID = A.AuctionID and C.CustomerID = S.SellerID and Username1 = P.Username;
	

select * from TempResultSet
group by Username;

end $$

delimiter ;