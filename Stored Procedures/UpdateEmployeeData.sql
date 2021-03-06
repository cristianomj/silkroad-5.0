delimiter $$ 

drop procedure if exists UpdateEmployeeData;

create procedure UpdateEmployeeData(
	u_EmployeeID int unsigned,
	u_LastName		char(20),
	u_FirstName		char(20),
	u_Address		char(255),
	u_ZipCode		varchar(11),
	u_Telephone	char(13),
 	u_Email			char(25),
 	`u_Password`		char(20),
 	u_HourlyRate	decimal(5,2) unsigned
)
deterministic

begin
	
	update Person
	set LastName = u_LastName,
		 FirstName = u_FirstName,
		 Address = u_Address,
		 ZipCode = u_ZipCode,
		 Telephone = u_Telephone,
		 Email = u_Email,
		 `Password` = `u_Password`
		 where SSN = u_EmployeeID;
	
	update Employee
		set HourlyRate = u_HourlyRate
		where EmployeeID = u_EmployeeID;
	
	end $$
	
	delimiter ;
	