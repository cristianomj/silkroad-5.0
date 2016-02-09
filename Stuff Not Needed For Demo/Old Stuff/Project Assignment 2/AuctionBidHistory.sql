/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  Creates a view that gets all the bids made on the given auction.
--
-- Parameters:
-- 	  AuctionID int unsigned:   [Required]	 	The id of the auction. ? in the following query is the AuctionID
--
-- Example call:
--    select * from AuctionBidHistory;
--
-- Example output:
--    TimeOfBid     datetime              -- The time the bid was made
--    BidAmount     decimal(5,2) unsigned -- The amount of the bid
--    BuyerUserName varchar(20)           -- The username of the customer who made the bid
--
-- Example output with demo data, if we search for a bid history of AuctionID 1 (the auction selling Titanic):
--    TimeOfBid,            BidAmount,   UserName
--    "2015-10-26 19:28:01",    10.00,    shiyong
--    "2015-10-26 19:28:34",    10.00,    shiyong
--    "2015-10-26 19:29:35",    15.00,    shiyong
--    "2015-10-26 19:27:30",    10.00,    haixia
/***************************************************************************************************************************/

-- Get the Time of the bid, the amount of the bid, and the username of the customer who made the bid
create view AuctionBidHistory
  as
  select
          B.TimeOfBid,
          B.BidAmount,
          U.UserName
from Bid B, User U
where B.AuctionID = ? -- ? is the auction id of the auction we want
      and U.UserID = B.CustomerID and U.UserType = 'Customer';