create table Employee (
	SSN 					int unsigned 				primary key,
	HourlyRate 			decimal(5,2) unsigned 	not null,
	StartDate 			date 							not null,
	EmployeeType 		enum('Manager', 'Customer Representative') not null
);