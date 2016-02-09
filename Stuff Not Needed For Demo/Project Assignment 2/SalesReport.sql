/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	Obtain a sales report for a particular month
-- 
-- Parameters:
-- 	Date INT(2) UNSIGNED -- the number of the month which you want the sales report of 
-- 
-- Sample Execution
-- 	Date == 2
--
-- Results
-- 	No data to display
/***************************************************************************************************************************/
start transaction;

create or replace view SalesByMonth as

select P1.Username as 'Buyer',
		 P2.Username as 'Seller',
		 S.Date 		 as 'Date',
		 S.Price     as 'Revenue',
		 I.Name      as 'Item',
		 I.Type		 as 'Item Type'

from Person P1, Person P2, Item I, Sales S

where P1.SSN = S.BuyerID and P2.SSN = S.SellerID
		and Month(S.Date) = ?; -- Date INT(2) UNSIGNED