/***************************************************************************************************************************/
-- Author: Paul
--
-- Description:
-- 	Produce customer mailing lists
-- 
-- Parameters:
-- 
-- Sample Execution
-- 	select P.Email from Person P, Customer C where P.SSN = C.CustomerID;
--
-- Results
-- 	shiyong@cs.sunysb.edu
-- 	dhaixia@cs.sunysb.edu
-- 	shlu@ic.sunysb.edu
-- 	pml@cs.sunysb.edu
/***************************************************************************************************************************/

# Retrieves all emails in the Person table of all persons found on employee table #
select P.Email
from Person P, Customer C
where P.SSN = C.CustomerID;