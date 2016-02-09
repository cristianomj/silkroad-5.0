delimiter $$
drop procedure if exists GetRevenueByItemType;
create procedure GetRevenueByItemType(
	ItemType		char(20)
	)
deterministic
begin

drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
       ItemType		char(20),
       CopiesSold		int (15),
 		Revenue  		decimal(13,2)
    );

SET @cnt := 0;
insert into TempResultSet(ItemType,  CopiesSold, Revenue)
select I.`Type`, @cnt := @cnt + 1, S.Price
	from Item I, Sales S
	where I.`Type` =  ItemType and I.ItemID = S.ItemID
	group by I.`Type`;
	

select * from TempResultSet
group by ItemType;

end $$

delimiter ;