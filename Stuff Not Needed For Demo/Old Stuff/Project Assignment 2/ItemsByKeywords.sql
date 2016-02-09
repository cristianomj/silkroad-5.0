/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Create a view that returns items available with a particular keyword or set of keywords in the item name,
--    and corresponding auction info.
--
--    This can be called with 3 item types, acting as the set of keywords. Atleast one must be supplied. Our query will
--    will search for all items that match at least one of the keywords.
--    So if we call this procedure with ItemType1 = DVD and ItemType2 = Car and ItemType3 is null then we will return all available items
--    with type DVD , and all items with item type Car.
--
-- Note:
--    coalesce(?1, '') != '' is shorthand for checking if ?1 is null or an empty string
--
-- Parameters:
-- 	  ItemType1 varchar(255): 	[Required if ItemType2 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemType2 varchar(255): 	[Required if ItemType1 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemType3 varchar(255): 	[Required if ItemType1 and ItemType2 not supplied]	 --	One of the item name keywords
--
-- Example call:
--    select * from ItemsByKeywords;
--
-- Example output:
--    AuctionID         int unsigned                  -- The id of the auction
--    SellerUserName    varchar(20)                   -- The username of the customer selling the item.
--    ItemName          varchar(255)                  -- The name of the item
--    ItemType          varchar(255)                  -- The type of the item
--    Description       blob                          -- The description of the item
--    PostDate          datetime                      -- The date the auction was posted
--    ExpirationDate    datetime                      -- The date the auction ends
--    CopiesSold        int unsigned                  -- The number of copies of the item sold
--    CurrentBid        decimal(5, 2) unsigned null   -- The current bid of the auction
--
-- Example output with demo data, if ItemType1 = 'DVD' and ItemType2 = 'Car' and ItemType3 is null:
--    The output will return a result set with the above attributes, but will be empty because
--    the auction selling 'Titanic' closed so there are no more items available.
/**********************************************************************************************************************/

-- Get the item and corresponding auction info where the auction selling the item is not
-- expired (specifying that the item is available), and the type of the item is like at least one of the given
-- item type keywords
drop view if exists ItemsByKeywords;
create view ItemsByKeywords
as
select distinct     A.AuctionID,
                      U.UserName as SellerUserName,
                      I.Name      as ItemName,
                      I.ItemType,
                      P.PostDate,
                      P.ExpirationDate,
                      I.Description,
                      A.CopiesSold,
                      A.CurrentBid
from Auction A, Post P, Item I, User U
where A.ItemID        = I.ItemID
      and P.AuctionID = A.AuctionID
      and now() < P.ExpirationDate
      and (case when coalesce(?1, '') != '' then I.ItemType like concat('%', ?1, '%') end      -- ?1 is ItemType1
           or case when coalesce(?2, '') != '' then I.ItemType like concat('%', ?2, '%') end   -- ?2 is ItemType2
           or case when coalesce(?3, '') != ''  then I.ItemType like concat('%', ?3, '%') end) -- ?3 is ItemType3
      and P.CustomerID = U.UserID and U.UserType = 'Customer';