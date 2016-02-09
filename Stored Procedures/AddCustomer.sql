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
-- 			Address		varchar(50)
-- 			ZipCode		varchar  [Required]
-- 			Telephone   varchar(10) [Required]
-- 			Email			varchar(50) [Required]
-- 			Password		varchar(20) [Required]
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
-- 							Password
--   
-- 
--   
/**********************************************************************************************************************/

-- Allows Customer to create new account and insert data into the customer table
delimiter $$

drop procedure if exists AddCustomer;

create procedure AddCustomer(
  SSN varchar(11),
  FirstName varchar(20),
  LastName varchar(20),
  Address varchar(255),
  ZipCode varchar(11),
  Telephone varchar(13),
  Email varchar(50),
  UserName varchar(20),
  Password varchar(20),
  CreditCardNum varchar(19)
  
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;

    declare exit handler for sqlexception
      begin
        rollback;
        set `Status` = 2;
        set ReturnMsg = 'There was an unexpected server error.';

        select Status, ReturnMsg;
      end;

    --
    -- Declare local variables
    --

    set `Status` = 0;

    --
    -- Begin the transaction
    --

    start transaction;

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

    tryBlock: begin
    
    	if exists (select Username from Person P where P.Username = Username) then
    		set ReturnMsg = concat('Username ''', UserName, ''' is taken. Please choose another one.');
        	set `Status` = 1;
       	leave tryBlock;
      end if;
      
      if exists (select SSN from Person P where P.SSN = SSN) then
    		set ReturnMsg = concat('Please choose another SSN.');
        	set `Status` = 1;
       	leave tryBlock;
      end if;

      insert into Person(Type, Username, Password, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email)
		values('Customer', Username, Password, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email);
		
		insert into Customer(CustomerID, CreditCardNum)
		values(SSN, CreditCardNum);   

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
    end if;

  end $$

delimiter ;