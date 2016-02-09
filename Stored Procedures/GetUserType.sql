delimiter $$

drop procedure if exists GetUserType;

create procedure GetUserType(
Username varchar(20)
)
deterministic

  begin  	
  		
      select Type from Person P where P.Username = Username;

  end $$

delimiter ;