/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	This procedure takes a UserName and returns the SSN if it exists for the given UserType.
--  Else this returns null.
--
-- Parameters:
-- 	UserName varchar(20): [Required]	The username of the customer or employee.
--  UserType varchar(10): [Required]  The type of the user. Is either Employee or Customer.
--
-- Example call:
-- 	set SSN = select GetSSN('phil', 'Customer');
--
/***************************************************************************************************************************/
delimiter $$

drop function if exists GetSSN;

create function GetSSN(
  UserName char(20),
  UserType char(10)
)
returns int unsigned
deterministic

  begin

    declare SSN varchar(9);

    set SSN = (select P.SSN
               from Person P
               where P.UserName = UserName
                     and P.Type = UserType);

    return SSN;

  end $$

delimiter ;

