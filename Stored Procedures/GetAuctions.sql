delimiter $$

drop procedure if exists GetAuctions;

create procedure GetAuctions(
)
deterministic

  begin
  
  drop table if exists ResultSet;
    create table ResultSet (
      ItemName varchar(255),
      SellerUserName varchar(20),
      CurrentBid decimal(13,2) unsigned,
      HoursLeft  varchar(255),
      AuctionID	int unsigned,
      Expired		varchar(1)
    );
	
	 insert into ResultSet(ItemName, SellerUserName, CurrentBid, HoursLeft, AuctionID, Expired)
    select I.Name, P.UserName, 50, timediff(PO.ExpireDate,PO.PostDate), A. AuctionID, 'N'
    from Auction A, Item I, Person P, Post PO
    where A.AuctionID = PO.AuctionID
	 and (A.Copies_Sold = 0 and PO.ExpireDate > now()) 
	 and A.ItemID = I.ItemID
    and P.SSN = PO.CustomerID;    
    
    select ItemName, SellerUserName, CurrentBid, HoursLeft, AuctionID, Expired from ResultSet;

  end $$

delimiter ;