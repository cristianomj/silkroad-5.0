/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns a personalized item suggestion list.
--    We'll return all the item details of items that have the same type as the type of item where the customer
--    has bidded on the most. So if a user has placed bids on more auctions where those auctions were selling
--    an item of type 'DVD', then we'll return details of all 'DVD' items that are still in stock.
--
-- Parameters:
--    SSN int unsigned:   [Required]	The SSN of the customer. ? in the following query is the SSN
--
-- Example call:
--    drop view if exists AmountOfBidsMadeOnType;
--    create view AmountOfBidsMadeOnType
--    as
--    select I.Type, count(distinct B.AuctionID) as AuctionsBiddedOn, I.NumCopies
--    from Bid B, Item I, Auction A
--    where B.CustomerID = 3 -- 3 is the SSN of the customer 'shiyong'
--          and B.AuctionID = A.AuctionID
--          and A.ItemID = I.ItemID
--    group by I.Type;
--
--  drop view if exists ItemSuggestionList;
--  create view ItemSuggestionList
--  as
--  select Name as ItemName, I.Type as ItemType, Description
--  from Item I
--  where I.Type = (select Type
--                  from AmountOfBidsMadeOnType
--                  where NumCopies > 0
--                  order by AuctionsBiddedOn desc
--                  limit 1);
--
--  select * from ItemSuggestionList;
--
-- Example output:
--    ItemName         char(255)    -- The name of the item.
--    Description      varchar(255) -- The description of the item.
--    ItemType         char(255)    -- The type of the item.
--
-- Example output with demo data, if we want an item suggestion list for customer 'shiyong' who is our database has SSN = 3
--    ItemName, ItemType, Description
--     Titanic     'DVD'        null
--
--    This is because shiyong made more bids on the Titanic auction (that item type is DVD) than any other type of item.
--    And there are so Titanic items available in the Item table.
/**********************************************************************************************************************/

-- We look at the Bid table to see how many auctions a customer has bidded on and group it with the item
-- type. So if a user bid on 3 auctions, all of which were for items with item type 'DVD', then
-- the table will look like ItemType = 'DVD', AuctionsBiddedOn = 3
drop view if exists AmountOfBidsMadeOnType;
create view AmountOfBidsMadeOnType
as
  select I.Type, count(distinct B.AuctionID) as AuctionsBiddedOn, I.NumCopies
  from Bid B, Item I, Auction A
  where B.CustomerID = 3 -- ? is the SSN of the customer
        and B.AuctionID = A.AuctionID
        and A.ItemID = I.ItemID
  group by I.Type;

-- Return all the item details of items that have the same type as the type of item where the customer
-- has bidded on the most, and that item is in stock. So if a user has placed bids on more auctions where those
-- auctions were selling an item of type 'DVD', then we'll return all 'DVD' items that are still in stock.

-- If a customer has bidded on DVDs and Cars, and bidding on DVDs the most, but at this time there are no DVDs in stock
-- then we return all Cars available. If there are no DVDs and no Cars available, then we return nothing.
drop view if exists ItemSuggestionList;
create view ItemSuggestionList
  as
select Name as ItemName, I.Type as ItemType, Description
      from Item I
      where I.Type = (select Type
                     from AmountOfBidsMadeOnType
                     where NumCopies > 0
                     order by AuctionsBiddedOn desc
                     limit 1);
select * from person;
select * from itemsuggestionlist;
