/**********************************************************************************************************************/
-- Author: Paul Mannarino
-- 
-- Description:
--    Inserts a sale into the Sale table
-- 	When an Auction is completed, this transaction is called and the AuctionID
-- 	of the completed Auction is passed to the transaction
-- 
-- Parameters:
-- 	  AuctionID int: 	[Required]	 --	ID of completed Auction
-- 
-- Example call:
--    RecordSale   A.AuctionID
-- 
/**********************************************************************************************************************/
# Recording a sale #
# Assume we are given the AuctionID of a successfully completed Auction #
start transaction;

insert into Sales(BuyerID, SellerID, Price, Date, ItemID, AuctionID)
select B.CustomerID, P.CustomerID, B.BidPrice, P.ExpireDate, A.ItemID, A.AuctionID 
from Bid B, Post P, Auction A
where B.AuctionID = ? -- ID of Auction int
and A.AuctionID = ?
and B.BidPrice = (select max(B2.BidPrice) from Bid B2 where B2.AuctionID = 1 )
and P.AuctionID = ?;

select * from Sales;

commit;