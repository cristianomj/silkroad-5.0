/**********************************************************************************************************************/
-- Author: Paul Mannarino
-- 
-- Description:
--    Returns List of items for a customer based on their past purchases
--
-- Parameters:
-- 	  CustomerID int: 	[Required]	 --	ID of customer
--
-- Example call:

--
-- Example output:
--    ItemName          char(255)                  -- The name of the item
--    ItemType          char(255)                  -- The type of the item
--    Description       varchar(255)               -- The description of the item
--
--
/**********************************************************************************************************************/
# Given a PersonID, produce a type list of items with the same type of items
# based on their past purchases

start transaction;


drop view if exists PurchasedItemsHistory;
create view PurchasedItemsHistory as
  select I.Type
  from Sales S, Item I, Auction A
  where S.BuyerID = ? -- is the UserID
        and S.AuctionID = A.AuctionID
        and A.ItemID = I.ItemID
  group by I.Type;


drop view if exists SuggestionsForCustomer;
create view SuggestionsForCustomer as
select I.Name as ItemName, I.Type as ItemType, I.Description
from Item I, PurchasedItemsHistory P
where I.Type = P.Type
group by P.Type;

select * from SuggestionsForCustomer;

commit;