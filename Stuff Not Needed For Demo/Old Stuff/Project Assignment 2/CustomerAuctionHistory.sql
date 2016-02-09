/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  Create a view that returns a history of all current and past auctions a customer has taken part in.
--
-- Parameters:
-- 	  UserID int unsigned:   [Required]	The id of the customer. ? in the following query is the UserID
--
-- Example call:
--    select * from CustomerAuctionHistory;
--
-- Example output:
--    AuctionID       int unsigned           -- The id of the auction the customer took place in
--    SellerUserName  varchar(20)            -- The username of the customer who posted the auction
--    PostDate        datetime               -- The date the auction was posted
--    ExpirationDate  datetime               -- The date the auction ends/ended
--    CopiesSold      int unsiged            -- The number of copies of the item in the auction that have been sold
--    CurrentBid      decimal(5, 2) unsigned -- The current posted bid of the auction
--    ItemName        varchar(255)           -- The name of the item
--    BuyerUserName   varchar(20)            -- The username of the buyer who won the auction
--
-- Example output with demo data, if we search for a history of customer 'phil':
--    AuctionID, SellerUserName, PostDate,             ExpirationDate,      CopiesSold, CurrentBid, ItemName, BuyerUserName
--            1,           phil,"2015-10-26 15:32:53","2015-10-26 15:32:53",         1,      11.00,  Titanic,       shiyong
/**********************************************************************************************************************/

drop table if exists CustomerAuctionHistory;
create table CustomerAuctionHistory (
  AuctionID           int unsigned          not null,

  -- User friendly columns
  SellerUserName      varchar(20)             not null,
  ItemName            varchar(255)           not null,
  Description         blob                    null,
  PostDate            datetime                not null,
  ExpirationDate      datetime                not null,
  CopiesSold           int unsigned           not null,
  CurrentBid           decimal(5, 2) unsigned null,
  BuyerUserName        varchar(20)            null
);

-- Insert the auction and corresponding info where the specified customer has either placed a bid on the auction
-- or was the poster of the auction.
-- We do this by getting a list of the Post and Bid table where the customer is in one of the records (accomplished
-- with a union) and returning only the auctions that are in that list.
insert into CustomerAuctionHistory(AuctionID, PostDate, ExpirationDate, CopiesSold, CurrentBid, ItemName, SellerUserName)
select distinct A.AuctionID, P.PostDate, P.ExpirationDate, A.CopiesSold, A.CurrentBid, I.Name, U.UserName
from Auction A, Post P, Item I, User U, Bid B
where A.AuctionID in (
    select P2.AuctionID
    from Post P2
    where P2.CustomerID = ? -- ? is the UserID
    union
    select B2.AuctionID
    from Bid B2
    where B2.CustomerID = ? -- ? is the UserID
  )
  and A.ItemID     = I.ItemID
  and P.AuctionID = A.AuctionID
  and U.UserID    = P.CustomerID and U.UserType = 'Customer';

-- Insert the buyer usernames into the result set by looking at the auctions in the result set that have sold at least one copy
-- and then looking at the Bid table to get the customer who won the auction. That customer's username will be the BuyerUserName
update CustomerAuctionHistory RS
set RS.BuyerUserName = (select U.UserName
                        from User U, Auction A, Bid B
                        where A.AuctionID = RS.AuctionID
                              and A.CopiesSold > 0
                              and B.AuctionID = A.AuctionID
                              and B.BidAmount = A.ClosingBid
                              and B.CustomerID = U.UserID and U.UserType = 'Customer');

select * from CustomerAuctionHistory;