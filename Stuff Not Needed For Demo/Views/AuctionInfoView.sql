create view AuctionInfoView as
select AuctionID, ItemID,SellerID,
		BuyerID, EmployeeID, InvoiceID, OpenningTime,
		ClosingTime, OpeningBid, ClosingBid, CurrentBid
from Auction