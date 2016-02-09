/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	Produce a summary listing of revenue generated by a particular item, itemType, or customer
-- 
-- Parameters:
-- 	ItemName -- Name of item to produce summary for
--    ItemType -- Type of item to produce summary for
--    Customer -- Custumer to produce summary for
-- 
-- Sample Execution
--  	ItemName == 'Titanic'
-- 	ItemType == 'DVD'
--    CustomerName == 'Shiyong'
--
--
-- Results
-- 	$15  		1
/***************************************************************************************************************************/
start transaction;

create or replace view ItemRevenueSummary as

select P1.Username as 'Buyer',
		 P2.Username as 'Seller',
		 S.Date 		 as 'Date',
		 S.Price     as 'Revenue',
		 I.Name      as 'Item',
		 I.Type		 as 'Item Type'

from Person P1, Person P2, Item I, Sales S

where P1.SSN = S.BuyerID and P2.SSN = S.SellerID
      and I.Name = ? -- ItemName char(20)
      and (P1.FirstName = ? or P1.LastName = ?) or (P2.FirstName = ? or P2.LastName = ?) -- ? Customername char(20)
      and I.Type = ?; -- ItemType char(20)
      
select sum(Revenue) as 'TOTAL REVENUE',
	    count(*) as 'NUMBER SOLD'
from ItemRevenueSummary;