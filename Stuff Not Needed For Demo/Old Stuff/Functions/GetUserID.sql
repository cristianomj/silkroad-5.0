/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	This procedure takes a UserName and returns the UserID if it exists for the given UserType.
--  Else this returns null.
--
-- Parameters:
-- 	UserName varchar(20): [Required]	The username of the customer or employee.
--  UserType varchar(10): [Required]  The type of the user. Is either Employee or Customer.
--
-- Example call:
-- 	set UserID = select CheckForValidUser('phil', 'Customer');
--
/***************************************************************************************************************************/
delimiter $$

drop function if exists GetUserID;

create function GetUserID(
  UserName varchar(20),
  UserType varchar(10)
)
returns int unsigned
deterministic

  begin

    declare UserID int unsigned;

    set UserID = (select U.UserID
                  from User U
                  where U.UserName = UserName
                         and U.UserType = UserType);

    return UserID;

  end $$

delimiter ;

