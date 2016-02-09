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
--    UserID int unsigned:   [Required]	The id of the customer. ? in the following query is the UserID
--
-- Example call:
--    select * from ItemSuggestionList;
--
-- Example output:
--    ItemName         varchar(255)  -- The name of the item.
--    Description      blob          -- The description of the item.
--    ItemType         varchar(255)  -- The type of the item.
--
-- Example output with demo data, if we want an item suggestion list for customer 'shiyong'
--    ItemName, ItemType, Description
--     Titanic     'DVD'        null
--
--    This is because shiyong made more bids on the Titanic auction (that item type is DVD) than any other type of item
/**********************************************************************************************************************/
drop table if exists AmountOfBidsMadeOnType;
create table AmountOfBidsMadeOnType (
  ItemType           varchar(255)    not null,
  AuctionsBiddedOn  int unsigned
);

create view AmountOfBidsMadeOnType


-- We look at the Bid table to see how many auctions a customer has bidded on and group it with the item
-- type. So if a user bid on 3 auctions, all of which were for items with item type 'DVD', then
-- the table will look like ItemType = 'DVD', AuctionsBiddedOn = 3
insert into AmountOfBidsMadeOnType(ItemType, AuctionsBiddedOn)
  select I.ItemType, count(distinct B.AuctionID) as AuctionsBiddedOn
  from Bid B, Item I, Auction A
  where B.CustomerID = ? -- ? is the UserID
        and B.AuctionID = A.AuctionID
        and A.ItemID = I.ItemID
  group by I.ItemType;

-- Return all the item details of items that have the same type as the type of item where the customer
-- has bidded on the most. So if a user has placed bids on more auctions where those auctions were selling
-- an item of type 'DVD', then we'll return all 'DVD' items that are still in stock
drop view if exists ItemSuggestionList;
create view ItemSuggestionList
  as
select Name as ItemName, I.ItemType, Description from Item I
where I.NumCopies > 0
      and I.ItemType = (select ItemType
                         from AmountOfBidsMadeOnType
                         order by AuctionsBiddedOn desc
                         limit 1);
