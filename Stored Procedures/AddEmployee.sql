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

delimiter $$

drop procedure if exists AddEmployee;

create procedure AddEmployee(
  SSN varchar(11),
  FirstName varchar(20),
  LastName varchar(20),
  Address varchar(255),
  ZipCode varchar(11),
  Telephone varchar(13),
  Email varchar(50),
  UserName varchar(20),
  Password varchar(20),
  HourlyRate decimal(5,2) unsigned,
  Level INTEGER unsigned
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
		values('Employee', Username, Password, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email);
		
		insert into Employee(StartDate, HourlyRate, Level, EmployeeID)
		values(now(), HourlyRate, Level, SSN);      

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