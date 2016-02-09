/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	  Updates an Employee
-- 
-- Parameters:
-- 	  StartDate, HourlyRate, Level, EmployeeID, SSN, FirstName, LastName
--      AddressZipCode, Telephone, Email
-- 
-- Sample Execution
-- update Person
-- set FirstName 	= 'John',
-- 	 LastName 	= 'Oliver',
-- 	 Address  	= '123 Main',
-- 	 ZipCode  	= 10604,
-- 	 Telephone 	= 914999999,
-- 	 Email 		= 'info@icloud.com
-- where SSN =  123456789

-- update Employee
-- set StartDate 	= '1998-11-01',
--     HourlyRate = 60.00,
-- 	 Level 		= 0,
-- where EmployeeID = 123456789
-- 
/***************************************************************************************************************************/
-- start a new transaction
start transaction;

update Person
set FirstName 	= ?, -- FirstName		char(20)
	 LastName 	= ?, -- LastName		char(20)
	 Address 	= ?, -- Address		char(255) 
	 ZipCode 	= ?, -- ZipCode		int(10) unsigned 
	 Telephone 	= ?, -- Telephone		int(10) unsigned
	 Email 		= ?  -- Email			char(20)
where SSN = ? -- SSN		int(20) unsigned

update Employee
set StartDate 	= ?, -- StartDate		dadetime
    HourlyRate = ?, -- HourlyRate	decimal(5,2) unsigned 
	 Level 		= ?, -- Level			int(10) unsigned
where EmployeeID = ?  -- EmployeeID		int(10) unsigned)
 
-- commit changes    
commit;