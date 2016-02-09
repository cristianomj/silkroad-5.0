/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  Returns all the bids made on the given auction.
--
-- Parameters:
-- 	  AuctionID int unsigned:   [Required]	 	The id of the auction. ? in the following query is the AuctionID
--
-- Example call:
--    select
--          B.BidTime,
--          B.BidPrice,
--          P.UserName
--    from Bid B, Person P
--    where B.AuctionID = 1 -- 1 is the auction id of Titanic auction
--      and P.SSN = B.CustomerID;
--
-- Example output:
--    BidTime     datetime                -- The time the bid was made
--    BidPrice    decimal(13,2)           -- The amount of the bid
--    UserName    char(20)                -- The username of the customer who made the bid
--
-- Example output with demo data, if we search for a bid history of AuctionID 1 (the auction selling Titanic):
--    BidTime,               BidPrice,    UserName
--    "2015-10-26 19:28:01",    10.00,    shiyong
--    "2015-10-26 19:28:34",    10.00,    shiyong
--    "2015-10-26 19:29:35",    15.00,    shiyong
--    "2015-10-26 19:27:30",    10.00,    haixia
/***************************************************************************************************************************/

-- Get the Time of the bid, the amount of the bid, and the username of the customer who made the bid
select
          B.BidTime,
          B.BidPrice,
          P.UserName
from Bid B, Person P
where B.AuctionID = ? -- ? is the auction id of the auction we want
      and P.SSN = B.CustomerID;