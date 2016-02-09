/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Return items available of a particular type and corresponding auction info.
--
-- Parameters:
-- 	  ItemType char(255): 	[Required]	 --	The type of the item.
--
-- Example call:
--    select distinct   A.AuctionID,
--                      P.UserName as SellerUserName,
--                      I.Name as ItemName,
--                      I.Type,
--                      I.Description,
--                      PO.PostDate,
--                      PO.ExpireDate
--    from Auction A, Post PO, Item I, Person P
--    where A.ItemID    = I.ItemID
--        and PO.AuctionID = A.AuctionID
--        and now() < PO.ExpireDate
--        and I.Type = 'DVD' -- 'DVD' is ItemType
--        and PO.CustomerID = P.SSN
--
-- Example output:
--    AuctionID         int unsigned               -- The id of the auction
--    SellerUserName    char(20)                   -- The username of the customer selling the item.
--    ItemName          char(255)                  -- The name of the item
--    ItemType          char(255)                  -- The type of the item
--    Description       varchar(255)               -- The description of the item
--    PostDate          datetime                   -- The date the auction was posted
--    ExpireDate        datetime                   -- The date the auction ends
--
-- Example output with demo data, if ItemType = 'Car':
--    AuctionID,    SellerUserName,   ItemName,          Type,   Description,    PostDate,              ExpireDate
--            2,              john,   "Nissan Sentra",    Car,          NULL,    "2015-10-27 21:14:20", "2015-10-30 21:14:20"
--
--    AuctionID 2 is the auction selling the Nissan Sentra. This item is of type 'Car' so that is why we get this output.
/**********************************************************************************************************************/

-- Get the item and corresponding auction info where the auction selling the item is not
-- expired (specifying that the item is available), and the type of the item is equal to the specified item type
select distinct     A.AuctionID,
                      P.UserName as SellerUserName,
                      I.Name as ItemName,
                      I.Type,
                      I.Description,
                      PO.PostDate,
                      PO.ExpireDate
from Auction A, Post PO, Item I, Person P
where A.ItemID    = I.ItemID
    and PO.AuctionID = A.AuctionID
    and now() < PO.ExpireDate
    and I.Type = ? -- ? is the ItemType we are searching for
    and PO.CustomerID = P.SSN
