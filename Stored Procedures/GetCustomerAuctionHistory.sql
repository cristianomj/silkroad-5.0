/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  This procedure gets a history of all current and past auctions a customer has taken part in.
--
-- Parameters:
-- 	  Username char(20):   [Required]	The username of the customer.
--
-- Return Statuses:
--    0 - Success
-- 	1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
-- 	  call GetCustomerAuctionHistory(123);
--
-- Example output:
--    If there are no errors then ResultSet 1 and the specified columns of ResultSet 2 below are returned.
--    Else only ResultSet 1 is returned.
--
--  ResultSet 1:
--    Status  int not null,     -- Indicates if there was an error or not
--    ReturnMsg varchar(255) null -- If there was en error, this will contain the error message
--
--  ResultSet 2:
--    AuctionID       int unsigned        -- The id of the auction the customer took place in
--    SellerUserName  char(20)            -- The username of the customer who posted the auction
--    PostDate        datetime            -- The date the auction was posted
--    ExpireDate      datetime            -- The date the auction ends/ended
--    CopiesSold      int unsigned        -- The number of copies of the item in the auction that have been sold
--    ItemName        char(255)           -- The name of the item
--
--  Example call and output against demo data:
--    Call:
--      call GetCustomerAuctionHistory('phil');
--
--    Output:
--      ResultSet 1: Status, ReturnMsg
--                        0,      NULL
--
--      ResultSet 2: AuctionID, SellerUserName, PostDate,              ExpirationDate,      CopiesSold, CurrentBid, ItemName, BuyerUserName
--                            1,           phil,"2015-10-26 15:32:53","2015-10-26 15:32:53",         1,      11.00,  Titanic,       shiyong
/**********************************************************************************************************************/

delimiter $$

drop procedure if exists GetCustomerAuctionHistory;

create procedure GetCustomerAuctionHistory (
  UserName char(20),
  ReturnAllAuctions int
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg					varchar(255);
    declare `Status`					int;
    declare SSN          varchar(11);

    declare exit handler for sqlexception
      begin
        rollback;
        set `Status` = 2;
        set ReturnMsg = 'There was an unexpected server error.';

        select Status, ReturnMsg;
      end;

    --
  	-- Declare local variables
	  --
    set `Status` = 0;

    --
    -- Begin the transaction
    --

    start transaction;

      --
      -- Create the result set table
      --

      drop table if exists ResultSet;
      create table ResultSet (
        AuctionID             int unsigned          not null,

        -- User friendly columns
        SellerUserName        varchar(20)           not null,
        PostDate             datetime                not null,
        ExpirationDate      datetime                not null,
        CopiesSold           int unsigned           not null,
        ItemName             varchar(255)            not null,
        SecondsLeft  varchar(255)							not null,
        CurrentBid	int	null,
        Expired	varchar(1),
        Reserve decimal(13,2) unsigned null
      );

      --
  	  -- Begin the block where we will do business logic.
	    -- The block wll be used as a way to exit the business logic if we encounter an error.
	    --

      tryBlock:begin

        --
        -- Check that the required parameters were passed in
        --

        if (coalesce(UserName, '') = '') then
          set ReturnMsg = 'Must provide the username of the user.';
          set `Status` = 1;
          leave tryBlock;
        end if;

        --
        -- Check that the passed in parameters contain valid data
        --

        -- Check that a user with the given username exists
        set SSN = GetSSN(UserName, 'Customer');
        if (SSN is null) then
          set ReturnMsg = concat('No user with username: [', UserName, '] exists.');
          set `Status` = 1;
          leave tryBlock;
        end if;

        --
        -- At this point, all validation is complete and we can go ahead with getting the information
        --

        -- Insert the auction and corresponding info where the specified customer has either placed a bid on the auction
        -- or was the poster of the auction.
        -- We do this by getting a list of the Post and Bid table where the customer is in one of the records (accomplished
        -- with a union) and returning only the auctions that are in that list.
        insert into ResultSet(AuctionID, PostDate, ExpirationDate, CopiesSold, ItemName, SellerUserName, SecondsLeft, CurrentBid, Reserve)
        select distinct A.AuctionID, 
		  PO.PostDate,
		   PO.ExpireDate, 
			A.Copies_Sold, 
			I.Name, 
			P.UserName,
			case when timediff(PO.ExpireDate, now()) > time('00:00:00') then time_to_sec(timediff(PO.ExpireDate, now())) else 0 end, 
		  case when (select max(B.BidPrice) from Bid B where B.AuctionID = A.AuctionID) > 0 then (select max(B.BidPrice) from Bid B where B.AuctionID = A.AuctionID) else A.MinimuBid end,
		  A.Reserve
			from Auction A, Post PO, Item I, Person P, Bid B
			where A.AuctionID in (
			    select PO2.AuctionID
			    from Post PO2
			    where PO2.CustomerID = SSN
			      union
			    select B2.AuctionID
			    from Bid B2
			    where B2.CustomerID = SSN
			  )
			  and A.ItemID      = I.ItemID
			  and PO.AuctionID = A.AuctionID
			  and A.Copies_Sold = case when ReturnAllAuctions = 0 then 0 else A.Copies_Sold end
			  and PO.ExpireDate >= case when ReturnAllAuctions = 0 then now() else PO.ExpireDate end
			  and P.SSN = PO.CustomerID;

			-- Determine which auctions are expired. If it is, then set Expired to 'Y', else 'N'
		  update ResultSet RS
		  set Expired = (case when RS.CopiesSold = 0 and RS.ExpirationDate > now() then 'N'
		  					 else 'Y' end);
    end tryBlock;

    if (`Status` != 0) then
      rollback;

      select Status, ReturnMsg;
    else
      commit;

      select Status, ReturnMsg;
      select ItemName, SellerUserName, CurrentBid, SecondsLeft, AuctionID, Expired, Reserve from ResultSet order by SecondsLeft;
    end if;

  end;
