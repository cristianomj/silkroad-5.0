/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  Returns a history of all current and past auctions a customer has taken part in.
--
-- Parameters:
-- 	  SSN int unsigned:   [Required]	The SSN of the customer. ? in the following query is the SSN
--
-- Example call:
--    select distinct A.AuctionID, PO.PostDate, PO.ExpireDate, A.Copies_Sold, I.Name, P.UserName as SellerUserName
--   from Auction A, Post PO, Item I, Person P, Bid B
--   where A.AuctionID in (
--      select PO2.AuctionID
--      from Post PO2
--      where PO2.CustomerID = 1 -- 1 is the SSN of customer 'phil'
--        union
--      select B2.AuctionID
--      from Bid B2
--      where B2.CustomerID = 1 -- 1 is the SSN of customer 'phil'
--   )
--    and A.ItemID      = I.ItemID
--    and PO.AuctionID = A.AuctionID
--    and P.SSN = PO.CustomerID;
--
-- Example output:
--    AuctionID       int unsigned        -- The id of the auction the customer took place in
--    SellerUserName  char(20)            -- The username of the customer who posted the auction
--    PostDate        datetime            -- The date the auction was posted
--    ExpireDate      datetime            -- The date the auction ends/ended
--    CopiesSold      int unsigned        -- The number of copies of the item in the auction that have been sold
--    ItemName        char(255)           -- The name of the item
--
-- Example output with demo data, if we search for a history of customer 'phil' who in our database has SSN = 1:
--    AuctionID,       PostDate,             ExpireDate,      CopiesSold,  ItemName, SellerUserName,
--            1,       "2015-10-27 21:14:20","2015-10-27 21:14:20",         1,  Titanic,           phil
/**********************************************************************************************************************/

-- Get the auction and corresponding info where the specified customer has either placed a bid on the auction
-- or was the poster of the auction.
-- We do this by getting a list of the Post and Bid table where the customer is in one of the records (accomplished
-- with a union) and returning only the auctions that are in that list.
select distinct A.AuctionID, PO.PostDate, PO.ExpireDate, A.Copies_Sold, I.Name, P.UserName as SellerUserName
from Auction A, Post PO, Item I, Person P, Bid B
where A.AuctionID in (
    select PO2.AuctionID
    from Post PO2
    where PO2.CustomerID = ? -- ? is the SSN of the customer
      union
    select B2.AuctionID
    from Bid B2
    where B2.CustomerID = ? -- ? is the SSN of the customer
  )
  and A.ItemID      = I.ItemID
  and PO.AuctionID = A.AuctionID
  and P.SSN = PO.CustomerID;