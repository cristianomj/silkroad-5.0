/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	Produce a list of sales by item name or by customer name
-- 
-- Parameters:
-- 	ItemName -- Name of item to look for in sale
--    CustomerName -- Name of the customer selling or buying 
-- 
-- Sample Execution
--  	ItemName == 'Titanic'
--    CustomerName == 'Shiyong'
--
-- Results
-- 	shiyong	phil	null	$15	Titanic	DVD
/***************************************************************************************************************************/
start transaction;

create or replace view SalesByItemOrCustomer as

select P1.Username as 'Buyer',
		 P2.Username as 'Seller',
		 S.Date 		 as 'Date',
		 S.Price     as 'Revenue',
		 I.Name      as 'Item',
		 I.Type		 as 'Item Type'

from Person P1, Person P2, Item I, Sales S

where P1.SSN = S.BuyerID and P2.SSN = S.SellerID
      and I.Name = 'Titanic' -- ItemName char(20)
      and (P1.FirstName = ? or P1.LastName = ?) or (P2.FirstName = ? or P2.LastName = ?); -- ? Customername char(20)