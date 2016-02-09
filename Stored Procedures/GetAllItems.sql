delimiter $$
drop procedure if exists GetAllItems;
create procedure GetAllItems()
deterministic
begin

	 select Name, `Type`, `Year`, Description, NumCopies from Item;

end $$ 
delimiter ;