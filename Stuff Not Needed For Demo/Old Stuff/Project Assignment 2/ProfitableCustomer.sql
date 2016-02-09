# Selects most profitable customers #
# which customer spent the most #
# must use the buyerid from invoice table #
drop view if exists ProfitableCustomer;
create view ProfitableCustomer (CustomerName, Revenue) as
Select U.Name, C.