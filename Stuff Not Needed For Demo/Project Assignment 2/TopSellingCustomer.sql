/**********************************************************************************************************************/
-- Author: Paul Mannarino
--
-- Description:
--    Produce a Best-Sellers list of items. The list contains item information where the first item has sold the most
--    and the last item has sold the least.
--
--
-- Example call:

# drop view if exists BestSellersList;
# create view BestSellersList
# as
#   select I.ItemID, sum(Copies_Sold) as ItemsSold
#   from Auction A, Post PO, Item I
#   where A.AuctionID = PO.AuctionID
#         and A.ItemID = I.ItemID
#   group by PO.CustomerID
#   order by ItemsSold desc;
#
# -- Return a list of items where the first item in the list is the best seller
# -- and the last item in the list is the item that sold the least
# select I.Name, I.Type, I.Description
# from Item I, BestSellersList BSL
# where I.ItemID = BSL.ItemID
# order by BSL.ItemsSold
# desc;

-- Output:
-- Name  char(255) -- Name of the item
--  Type char(255) -- Type of the item
--  Description varchar(256) -- Description of the item
--   CopiesSold int unsigned -- Number of copies of the item sold
--
-- Example output:
--
-- Name,        Type,     Description, CopiesSold
-- Titanic,       DVD,          NULL,         1
-- Nissan Sentra, Car,          NULL,         0
/**********************************************************************************************************************/

drop view if exists BestSellersList;
create view BestSellersList
  as
  select I.ItemID, sum(Copies_Sold) as CopiesSold
  from Auction A, Post PO, Item I
  where A.AuctionID = PO.AuctionID
    and A.ItemID = I.ItemID
  group by PO.CustomerID
  order by CopiesSold desc;

-- Return a list of items where the first item in the list is the best seller
-- and the last item in the list is the item that sold the least
select I.Name, I.Type, I.Description, CopiesSold
from Item I, BestSellersList BSL
  where I.ItemID = BSL.ItemID
  order by BSL.CopiesSold
  desc;

