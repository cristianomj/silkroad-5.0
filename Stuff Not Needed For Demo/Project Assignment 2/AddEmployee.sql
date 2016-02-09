/***************************************************************************************************************************/
-- Author: Cristiano Miranda
--
-- Description:
-- 	  Adds an Employee
-- 
-- Parameters:
-- 	  StartDate, HourlyRate, Level, EmployeeID, Username, SSN, FirstName, LastName
--      AddressZipCode, Telephone, Email
-- 
-- Sample Execution
-- 	insert into Person(UserName, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email)
--    values('phil', 1, 'Lewis', 'Phil', '135 Knowledge Lane, Stony Brook, NY', '11794', '(516)666-8888', 'pml@cs.sunysb.edu');

--    insert into Customer(CustomerID, CreditCardNum, Rating)
--    values(1, '6789-2345-6789-2345', 1);
-- 
/***************************************************************************************************************************/
-- start a new transaction
start transaction;

insert into Person(UserName, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email)
values(?, -- UserName 		char(20)
		 ?, -- SSN				int(20) unsigned
		 ?, -- FirstName		char(20)
		 ?, -- LastName		char(20)
		 ?, -- Address			char(255)
		 ?, -- ZipCode			int(10) unsigned
		 ?, -- Telephone		int(10) unsigned
		 ?  -- Email			char(20)
		)

insert into Employee(StartDate, HourlyRate, Level, EmployeeID)
values(?, -- StartDate		dadetime
		 ?, -- HourlyRate		decimal(5,2) unsigned
		 ?, -- Level			int(10) unsigned
		 ?  -- EmployeeID		int(10) unsigned
		)
 
-- commit changes    
commit;