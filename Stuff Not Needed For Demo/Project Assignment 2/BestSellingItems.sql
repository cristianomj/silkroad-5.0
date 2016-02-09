/***************************************************************************************************************************/
-- Author: Paul
--
-- Description:
-- 	 Produce a Best-Sellers list of items
-- 
-- Parameters:
--		none
-- 
-- Sample Execution
-- 	select * from BestSellingItems;
--
-- Result
-- 	Titanic			1
--		Nissan Sentra	0
/***************************************************************************************************************************/

# Creates a view of all items sold in auctions #
# orders them by number of copies sold #
# then selects the top 10 from the view #
# creates a top 10 list #

start transaction;

drop view if exists BestSellingItems;

create view BestSellingItems as

select I.Name, 
		 sum(A.Copies_Sold) as Total_Copies_Sold

from item I, Auction A

where I.ItemID = A.ItemId

group by Copies_Sold
order by Copies_Sold desc;

commit;