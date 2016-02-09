delimiter $$
drop procedure if exists GetEmployeeRevenues;
create procedure GetEmployeeRevenues()
deterministic
begin

drop table if exists TempResultSet;
    create table TempResultSet (
       EmployeeID		int(9),
 		Username 		char(20),
 		Revenue  		decimal(13,2)
    );

insert into TempResultSet(EmployeeID, Username, Revenue)
select E.EmployeeID, P.Username, S.Price
	from Person P, Sales S, Employee E, Auction A
	where E.EmployeeID = P.SSN and S.AuctionID = A.AuctionID and E.EmployeeID = A.Monitor;
	

SELECT EmployeeID, Username, Revenue
FROM   TempResultSet
WHERE  Revenue=(SELECT MAX(Revenue) FROM TempResultSet)
group by EmployeeID;

end $$

delimiter ;