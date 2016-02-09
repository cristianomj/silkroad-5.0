/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	  Creates a comprehensive listings of all items
-- 
-- Parameters:
-- 
-- Sample Execution
-- 	select * from ItemListings;
--
-- Result
-- 	Titanic				DVD	2005	4	$5			$1		$10
-- 	Nissan Sentra		Car	2007	1	$1000		$10	$2000
/***************************************************************************************************************************/
-- Produce a comprehensive listing of all items
start transaction;

create or replace view ItemListings as

select I.Name,
		 I.Type,
		 I.Year,
		 I.NumCopies,
		 A.MinimuBid,
		 A.BidIncrement,
		 A.Reserve
		 
from Item I left join Auction A on I.ItemID = A.ItemID;