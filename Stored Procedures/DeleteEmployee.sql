delimiter $$
drop procedure if exists DeleteEmployee;
create procedure DeleteEmployee(
EmployeeID2  int(9)
)
deterministic
begin

delete from Employee
where EmployeeID = EmployeeID2; -- EmployeeID 	INT(10) UNSIGNED

delete from Person
where SSN = EmployeeID2; -- EmployeeID INT(10) UNSIGNED



end $$

delimiter ;