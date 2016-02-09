/**********************************************************************************************************************/
-- Author: Paul Mannarino
--
-- Description:
--    Determine which customer generated most total revenue
--
--
-- Example call:

# drop view if exists TopBuyingCustomer;
# create view TopBuyingCustomer as
#   select S.BuyerID, P.UserName, sum(S.Price) as Revenue
#   from Sales S, Person P
#   where S.BuyerID = P.SSN
#   group by SellerId;
#
# Select BuyerID, UserName, Revenue
# from TopBuyingCustomer
# where Revenue = (select max(revenue) from TopBuyingCustomer);

--
-- Example output:
--
-- BuyerID, UserName,   Revenue
--       3,    shiyong, 15
--
--    Because shiyong won the Titanic auction and the price of her bid which won the auction is 15.
/**********************************************************************************************************************/

drop view if exists TopBuyingCustomer;
create view TopBuyingCustomer as
select S.BuyerID, P.UserName, sum(S.Price) as Revenue
from Sales S, Person P
where S.BuyerID = P.SSN
group by SellerId;

Select BuyerID, UserName, Revenue
from TopBuyingCustomer
where Revenue = (select max(revenue) from TopBuyingCustomer);