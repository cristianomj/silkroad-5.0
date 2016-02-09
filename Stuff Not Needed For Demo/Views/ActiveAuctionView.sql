create view ActiveAuctionView as
select A.AuctionID, I.Name, U.UserName, A.OpeningTime, A.CurrentBid, A.TimeLeft
from Auction A, User U, Item I
where ClosingTime is null and A.SellerID=U.UserID
and A.ItemID=I.ItemID;

Select * from ActiveAuctionView;
