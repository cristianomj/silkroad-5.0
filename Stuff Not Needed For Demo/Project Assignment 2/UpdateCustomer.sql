/**********************************************************************************************************************/
-- Author: Paul Mannarino
--
-- Description:
--    Edit information for a customer
--
-- Parameters:
-- 	   FirstName		char(20)
--		 LastName		char(20)
--		 Address		char(255)
--		 ZipCode		integer unsigned
--		 Telephone	char(13)
--		 Email			char(25)
--	   SSN				integer unsigned
--		 Rating 		integer unsigned
--		 CreditCardNum 	char(19)
--		 UserName char(20)
--
-- Example call:
#
# start transaction;
#
# update Person
# set FirstName 	= 'NewFirst', -- FirstName
# 	LastName 	= 'NewLast', -- LastName
# 	Address 	= 'NewAddress', -- Address
# 	ZipCode 	= 00000, -- ZipCode
# 	Telephone 	= '1111111111', -- Telephone
# 	Email 		=   'new@mail.com',-- Email
# 	UserName = 'NewUser'
# where SSN = 1;  -- SSN
#
# update Customer
# set Rating 	= 2, -- Rating	 integer unsigned
# 	CreditCardNum = '1234-1234-1234-1234' -- CreditCardNum char(19)
# where CustomerID = 1;  -- SSN		int unsigned
#
# -- commit changes
# commit;
--
-- Example output:
--
-- The updated Person table:
-- 		SSN, LastName, FirstName, Address, ZipCode, Telephone, Email, 				UserName
-- 		1,  NewLast,		NewFirst,	NewAddress,0,				1111111111,new@mail.com,NewUser
--
-- The updated Customer table:
-- 		Rating, CreditCardNum, 		CustomerID
--		2,		1234-1234-1234-1234,		1
/**********************************************************************************************************************/
start transaction;

update Person
set FirstName 	= ?, -- FirstName
	LastName 	= ?, -- LastName
	Address 	= ?, -- Address
	ZipCode 	= ?, -- ZipCode
	Telephone 	= ?, -- Telephone
	Email 		= ?,  -- Email
  UserName = ? -- UserName
where SSN = ?;  -- SSN

update Customer
set Rating 	= ?, -- Rating	 integer unsigned
	CreditCardNum = ? -- CreditCardNum char(19)
where CustomerID = ?;  -- SSN		int unsigned
 
-- commit changes    
commit;