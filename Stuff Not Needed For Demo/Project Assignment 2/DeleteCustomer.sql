/***************************************************************************************************************************/
-- Author: Paul
--
-- Description:
-- 	Deletes a Customer
-- 
-- Parameters:
-- 	CustomerID  INT(10) UNSIGNED
-- 
-- Sample Execution
-- 	delete from Customer where CustomerID = 1 limit 1;
--
-- Results
-- 	Deletes Customer with customerID 1
/***************************************************************************************************************************/

start transaction;

delete from Customer
where CustomerID = 1 -- Value of the CustomerID to be deleted
limit 1;

commit;