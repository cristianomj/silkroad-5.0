delimiter $$
drop procedure if exists ProduceMailingList;
create procedure ProduceMailingList()
deterministic
begin

  	declare ReturnMsg   char(255);
   declare `Status`    int;
   declare FirstName     char(25);
   declare LastName      char(25);
   declare Email      char(25);

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
    -- Create the result set table
    -- 
   /* drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
      FirstName       char(255),
      LastName   char(255),
      EMail			char(255) not null
    ); */
    
      -- 
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    -- 

    tryBlock: begin

      -- 
      -- Check that the required parameters were passed in
      -- 
     /* insert into TempResultSet(FirstName, LastName, Email)
        select P.FirstName, P.LastName, P.Email
        from Person P, Customer C
        where P.SSN = C.CustomerID;
*/
    end tryBlock;
    
      if (`Status` != 0) then
      	rollback;
      	-- set ReturnMsg = "Uh Oh"
      	select Status, ReturnMsg;
    	else
      	commit;
      	select Status, ReturnMsg;
      	select P.FirstName, P.LastName, P.Email
				from Person P, Customer C
				where P.SSN = C.CustomerID;
      end if;

end $$
delimiter ; 