delimiter $$

drop procedure if exists GetAuctionWinner;

create procedure GetAuctionWinner(
AuctionID int unsigned
)
deterministic

  begin
  
		select P.Username
		from Bid B, Post PO, Auction A, Person P
		where B.AuctionID = AuctionID
		and A.AuctionID = AuctionID
		and B.BidPrice = (select max(B2.BidPrice) from Bid B2 where B2.AuctionID = AuctionID)
		and A.Reserve > 0
		and PO.AuctionID = AuctionID
		and P.SSN = B.CustomerID;

  end $$

delimiter ;