/**********************************************************************************************************************/

--- Author: Kevin Young

--- 

--- Description:

---    Validates if the user with the given username exists, and the given password matches.

--- 	Returns a result set of all the 

--- 

/**********************************************************************************************************************/



delimiter $$



drop procedure if exists ValidateUser;



create procedure ValidateUser(

  Username char(20),

  Password char(20)

)

deterministic




begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare UserType    char(20);
    declare SSN			varchar(9);
    declare EmployeeLevel int;

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
    	
    	-- Validate the user exists and the passwords match
    	if not exists (select Username from Person P where P.Username = Username) then
    		set ReturnMsg = concat('User ''', UserName, ''' does not exist.');
        	set `Status` = 1;
       	leave tryBlock;
      else
      	if (select P.Password from Person P where P.Username = Username) != Password then
      		set ReturnMsg = concat('Invalid password. Please try again.');
        		set `Status` = 1;
       		leave tryBlock;
       	end if;
      end if;
      
      set UserType = (select Type from Person P where P.Username = Username);
      set SSN = GetSSN(Username, UserType);
      
      if (UserType = "Employee") then
      	set EmployeeLevel = (select Level from Employee E where E.EmployeeID = SSN);
      else
      		set EmployeeLevel = -1;
      end if;
      

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
      select UserType, EmployeeLevel;
    end if;

  end