/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Create a view that returns items available of a particular type and corresponding auction info
--
-- Parameters:
-- 	  ItemType varchar(255): 	[Required]	 --	The type of the item.
--
-- Example call:
--    select * from ItemsByType;
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
-- Example output with demo data, if ItemType = 'DVD':
--    The output will return a result set with the above attributes, but will be empty because
--    the auction selling 'Titanic' closed so there are no more items available.
/**********************************************************************************************************************/

-- Get the item and corresponding auction info where the auction selling the item is not
-- expired (specifying that the item is available), and the type of the item is equal to the specified item type
drop view if exists ItemsByType;
create view ItemsByType
as
select distinct     A.AuctionID,
                      U.UserName as SellerUserName,
                      I.Name as ItemName,
                      I.ItemType,
                      I.Description,
                      P.PostDate,
                      P.ExpirationDate,
                      A.CopiesSold,
                      A.CurrentBid
from Auction A, Post P, Item I, User U
where P.CustomerID = U.UserID
    and A.ItemID    = I.ItemID
    and P.AuctionID = A.AuctionID
    and now() < P.ExpirationDate
    and I.ItemType = ? -- ? is the ItemType we are searching for
    and P.CustomerID = U.UserID and U.UserType = 'Customer';