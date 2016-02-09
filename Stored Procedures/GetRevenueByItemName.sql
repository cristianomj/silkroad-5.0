delimiter $$
drop procedure if exists GetRevenueByItemName;
create procedure GetRevenueByItemName(
	ItemName		char(20)
	)
deterministic
begin

drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
       ItemName		char(20),
 		  CopiesSold		int (15),
 		Revenue  		decimal(13,2)
    );
SET @cnt := 0;
insert into TempResultSet(ItemName, Revenue, CopiesSold)
select I.Name, S.Price, @cnt := @cnt + 1
	from Item I, Sales S
	where I.Name = ItemName and I.ItemID = S.ItemID
	group by I.Name;
	

select * from TempResultSet
group by ItemName;

end $$

delimiter ;