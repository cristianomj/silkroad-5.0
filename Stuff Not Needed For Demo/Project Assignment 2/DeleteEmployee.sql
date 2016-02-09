/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	Deletes an Employee
-- 
-- Parameters:
-- 	EmployeeID
-- 
-- Sample Execution
-- 	delete from Employee where EmployeeID = 123456789
-- 	delete form Person where SSN = 123456789
--
-- Results
-- 	Employee with EmployeeID 123456789 is removed from employee table
-- 	Person with SSN 123456789 is removed form person table
/***************************************************************************************************************************/
start transaction;

delete from Employee
where EmployeeID = ? -- EmployeeID 	INT(10) UNSIGNED

delete from Person
where SSN = ? -- EmployeeID INT(10) UNSIGNED

commit;