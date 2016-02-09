delimiter $$

drop procedure if exists GetAllSellers;

create procedure GetAllSellers(
)

deterministic

  begin  
  		
	select distinct Username 
	from Customer C, Post PO, Person P 
	where C.CustomerID = PO.CustomerID 
	and P.SSN = C.CustomerID;	    
	
	end $$

delimiter ;

