/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns items sold by a given seller and corresponding auction info.
--
-- Parameters:
-- 	  UserID int unsigned:   [Required]	The id of the customer. ? in the following query is the UserID
--
-- Example call:
--    select * from ItemsSoldBySeller;
--
--  Example output:
--    AuctionID         int unsigned  -- The id of the auction
--    SellerUserName    varchar(20)   -- The username of the seller.
--    ItemName          varchar(255)  -- The name of the item
--    ItemType          varchar(255)  -- The type of the item
--    Description       blob          -- The description of the item
--    PostDate          datetime      -- The date the auction was posted
--    ExpirationDate    datetime      -- The date the auction ends
--    CopiesSold        int unsigned  -- The number of copies of the item sold
--    CurrentBid        decimal(5, 2) -- The current bid of the auction
--    BuyerUserName     varchar(20)   -- The username of the customer who bought the item (won the auction)
--
-- Example output with demo data, if we search for items sold by customer 'phil':
--    AuctionID, SellerUserName, ItemName, ItemType,  Description, PostDate,                 ExpirationDate,      CopiesSold, CurrentBid,  BuyerUserName
--            1,           phil,  Titanic,      DVD,        null,  "2015-10-26 15:32:53",    "2015-10-26 15:32:53",         1,      11.00,      shiyong
/***************************************************************************************************************************/

drop table if exists ItemsSoldBySeller;
create table ItemsSoldBySeller (
  AuctionID           int unsigned          not null,

  -- User friendly columns
  SellerUserName      varchar(20)             not null,
  ItemName            varchar(255)           not null,
  ItemType            varchar(255)            not null,
  Description         blob                    null,
  PostDate            datetime                not null,
  ExpirationDate      datetime                not null,
  CopiesSold           int unsigned           not null,
  CurrentBid           decimal(5, 2) unsigned null,
  BuyerUserName        varchar(20)            null
);

-- Insert the item and corresponding auction info sold by this seller where atleast one item has been sold
insert into ItemsSoldBySeller(AuctionID,
                              SellerUserName,
                              ItemName,
                              ItemType,
                              PostDate,
                              ExpirationDate,
                              Description,
                              CopiesSold,
                              CurrentBid)
select distinct           A.AuctionID,
                            U.UserName,
                            I.Name,
                            I.ItemType,
                            P.PostDate,
                            P.ExpirationDate,
                            I.Description,
                            A.CopiesSold,
                            A.CurrentBid
from Auction A, Post P, Item I, User U
where A.ItemID    = I.ItemID
      and P.AuctionID = A.AuctionID
      and P.CustomerID = ? -- ? is the id of the seller we are searching for
      and U.UserID = P.CustomerID and U.UserType = 'Customer'
      and A.CopiesSold > 0;

-- Insert the buyer usernames into the result set by looking at the auctions in the result set that have sold at least one copy
-- and then looking at the Bid table to get the customer who won the auction. That customer's username will be the BuyerUserName
update ItemsSoldBySeller RS
set RS.BuyerUserName = (select U.UserName
                          from User U, Auction A, Bid B
                          where A.AuctionID = RS.AuctionID
                                and A.CopiesSold > 0
                                and B.AuctionID = A.AuctionID
                                and B.BidAmount = A.ClosingBid
                                and B.CustomerID = U.UserID and U.UserType = 'Customer');

