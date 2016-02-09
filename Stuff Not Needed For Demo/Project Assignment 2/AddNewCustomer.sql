/**********************************************************************************************************************/
-- Author: Paul Mannarino
--
-- Description:
--    Adds a new customer to the customer table
-- 
-- Parameters:
-- 			SSN			int  [Required]
-- 	 	  	UserName		varchar(20) [Required]
-- 			FirstName	varchar(20) [Required]
-- 			LastName		varchar(20) [Required]
-- 			Address		varchar(50) [Required]
-- 			ZipCode		int  [Required]
-- 			Telephone   varchar(10) [Required]
-- 			Email			varchar(50) [Required]
-- 
-- Example call:
--    AddNewCustomer   	SSN
-- 							UserName
-- 							FirstName
-- 							LastName
-- 							Address
-- 							ZipCode
-- 							Telephone
-- 							Email
--   
-- 
--   
/**********************************************************************************************************************/

-- Allows Customer to create new account and insert data into the customer table
start transaction;

insert into Person(SSN, UserName, FirstName, LastName, Address, ZipCode, Telephone, Email)
values(?, -- User SSN used for identification
		 ?, -- Username to be pulicly displayed
		 ?, -- User first name
		 ?, -- User last name
		 ?, -- User address
		 ?, -- User zip code
		 ?, -- User phone number
		 ?, -- User Email
		 );

insert into Customer(CustomerID, CreditCardNum, Rating)

values(?, -- Custmomer's unique ID
		 ?, -- Customer's credit card number
		 ?, -- Customer rating 
		 );
		 
commit;