/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Return items available with a particular keyword or set of keywords in the item name,
--    and corresponding auction info.
--
--    This can be called with 3 item types, acting as the set of keywords. Atleast one needs to be supplied. Our query
--    will search for all items that match at least one of the keywords.
--    So if we call this procedure with ItemType1 = DVD and ItemType2 = Car and ItemType3 is null then we will return all available items
--    with type DVD, and all available items with item type Car.
--
-- Note:
--    coalesce(?1, '') != '' is shorthand for checking if ?1 is null or an empty string
--
-- Parameters:
-- 	  ItemType1 char(255): 	[Required if ItemType2 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemType2 char(255): 	[Required if ItemType1 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemType3 char(255): 	[Required if ItemType1 and ItemType2 not supplied]	 --	One of the item name keywords
--
-- Example call:
--    select distinct     A.AuctionID,
--                        P.UserName as SellerUserName,
--                        I.Name      as ItemName,
--                       I.Type      as ItemType,
--                        PO.PostDate,
--                        PO.ExpireDate,
--                        I.Description
--  from Auction A, Post PO, Item I, Person P
--  where A.ItemID         = I.ItemID
--          and PO.AuctionID = A.AuctionID
--         and now() < PO.ExpireDate
--          and (case when coalesce('DVD', '') != '' then I.Type like concat('%', 'DVD', '%') end      -- 'DVD' is ItemType1
--              or case when coalesce('Car', '') != '' then I.Type like concat('%', 'Car', '%') end   -- 'Car' is ItemType2
--              or case when coalesce(null, '') != ''  then I.Type like concat('%', null, '%') end) -- ItemType3 is null
--          and PO.CustomerID = P.SSN;
--
-- Example output:
--    AuctionID         int unsigned               -- The id of the auction
--    SellerUserName    char(20)                   -- The username of the customer selling the item.
--    ItemName          char(255)                  -- The name of the item
--    ItemType          char(255)                  -- The type of the item
--    Description       varchar(255)               -- The description of the item
--    PostDate          datetime                   -- The date the auction was posted
--    ExpireDate        datetime                   -- The date the auction ends/ended
--
-- Example output with demo data, if ItemType1 = 'DVD' and ItemType2 = 'Car' and ItemType3 is null:
--    AuctionID,  SellerUserName,  ItemName,      ItemType,   PostDate,              ExpireDate,       Description
--            2,            john, "Nissan Sentra",     Car,   "2015-10-27 21:14:20","2015-10-30 21:14:20",    NULL
--
--    AuctionID 2 is the auction selling the Nissan Sentra.
--    This is returned because the type matches ItemType2, and the auction is still active so it is still available.
/**********************************************************************************************************************/

-- Get the item and corresponding auction info where the auction selling the item is not
-- expired (specifying that the item is available), and the type of the item is like at least one of the given
-- item type keywords
select distinct     A.AuctionID,
                      P.UserName as SellerUserName,
                      I.Name      as ItemName,
                      I.Type      as ItemType,
                      PO.PostDate,
                      PO.ExpireDate,
                      I.Description
from Auction A, Post PO, Item I, Person P
where A.ItemID         = I.ItemID
      and PO.AuctionID = A.AuctionID
      and now() < PO.ExpireDate
      and (case when coalesce(?1, '') != '' then I.Type like concat('%', ?1, '%') end      -- ?1 is ItemType1
           or case when coalesce(?2, '') != '' then I.Type like concat('%', ?2, '%') end   -- ?2 is ItemType2
           or case when coalesce(?3, '') != ''  then I.Type like concat('%', ?3, '%') end) -- ?3 is ItemType3
      and PO.CustomerID = P.SSN;