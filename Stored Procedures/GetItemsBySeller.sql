/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns items sold by a given seller and corresponding auction info.
--
-- Parameters:
-- 	  UserName varchar(20): 	[Required]	 --	The username of the seller.
--
-- Return Statuses:
--    0 - Success
--    1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
--    call GetItemsSoldBySeller('phil');
--
-- Example output:
--    If there are no errors then ResultSet 1 and the specified columns from ResultSet 2 are returned.
--    Else only ResultSet 1 is returned.
--
--  ResultSet 1:
--    Status            int          not null        -- Indicates if there was an error or not
--    ReturnMsg         varchar(255) null            -- If there was en error, this will contain the error message
--
--  ResultSet 2:
--    AuctionID         int unsigned  not null       -- The id of the auction
--    SellerUserName    varchar(20)   not null       -- The username of the seller.
--    ItemName          varchar(255)  not null       -- The name of the item
--    ItemType          varchar(255)  not null       -- The type of the item
--    Description       blob          null           -- The description of the item
--    PostDate          datetime      not null       -- The date the auction was posted
--    ExpirationDate    datetime      not null       -- The date the auction ends
--    CopiesSold        int unsigned  not null       -- The number of copies of the item sold
--    CurrentBid        decimal(5, 2) unsigned null  -- The current bid of the auction
--    BuyerUserName     varchar(20)   not null       -- The username of the customer who bought the item (won the auction)
--
/***************************************************************************************************************************/

delimiter $$

drop procedure if exists GetItemsBySeller;

create procedure GetItemsBySeller(
  Seller varchar(20), -- Seller username
  BuyerUsername varchar(20),
  ReturnAllAuctions int
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare SSN      varchar(9);

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
    -- Create the status table and temporary result set table
    --

    drop table if exists ResultSet;
    create table ResultSet (
      AuctionID             int unsigned        not null,
      ItemID                int unsigned         not null,

      -- User friendly columns
      SellerUsername       varchar(20)          not null,
      CopiesSold           int unsigned           not null,
      ItemName              varchar(255)         not null,
      ItemType              varchar(255)         not null,
      Description           blob                 null,
      ItemYear					Year							null,
      NumCopies				int unsigned				null,
      PostDate              datetime             not null,
      ExpirationDate       datetime             not null,
      SecondsLeft  varchar(255)							not null,
      CurrentBid DECIMAL(13,2) unsigned	null,
      Expired	varchar(1),
      Reserve decimal(13,2) unsigned null,
      MinimuBid DECIMAL(13,2) unsigned 	NOT NULL
    );

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

    tryBlock: begin

      --
      -- Check that the passed in parameters contain valid data
      --

      -- Check that a user with the given username exists if provided
      if (coalesce(Seller, '') != '') then
	      set SSN = GetSSN(Seller, 'Customer');
	      if (SSN is null) then
	        set ReturnMsg = concat('No user with username: [', Seller, '] exists.');
	        set `Status` = 1;
	        leave tryBlock;
	      end if;
      end if;

      -- 
      -- At this point, all validation is complete and we can go ahead with adding the new record
      -- 

      -- Insert the item and corresponding auction info sold by this seller where atleast one item has been sold
       insert into ResultSet(SellerUsername,
      								AuctionID,
      								CopiesSold,
                              ItemID,
                              ItemName,
                              ItemType,
                              Description,
                              ItemYear,
                              NumCopies,
                              PostDate,
                              ExpirationDate,
										SecondsLeft,
										CurrentBid,
										Reserve,
										MinimuBid)		                      
       select distinct      P.Username,
		 							 A.AuctionID,
		 							 A.Copies_Sold,
		 							 I.ItemID,
		                      I.Name,
		                      I.Type,
		                      I.Description,
		                      I.Year,
									 I.NumCopies,
		                      PO.PostDate,
		                      PO.ExpireDate,
		                      case when timediff(PO.ExpireDate, now()) > time('00:00:00') then time_to_sec(timediff(PO.ExpireDate, now())) else 0 end,
		                      -- case when (select max(B.BidPrice) from Bid B where B.AuctionID = A.AuctionID) > 0 then (select max(B.BidPrice) from Bid B where B.AuctionID = A.AuctionID) else A.MinimuBid end,
		                      A.CurrentBid,
		                      A.Reserve,
		                      A.MinimuBid
		from Auction A, Post PO, Item I, Person P
		where A.ItemID    = I.ItemID
		    and PO.AuctionID = A.AuctionID
		    and A.Copies_Sold = case when ReturnAllAuctions = 0 then 0 else A.Copies_Sold end
			 and PO.ExpireDate >= case when ReturnAllAuctions = 0 then now() else PO.ExpireDate end
		    and PO.CustomerID = P.SSN;
		    
		-- If the username is supplied then we remove all auctions from the RS where the user was not involved
			if (coalesce(BuyerUsername, '') != '' ) then
				-- Check that a user with the given username exists
	        set SSN = GetSSN(BuyerUsername, 'Customer');
	        if (SSN is null) then
	          set ReturnMsg = concat('No user with username: [', BuyerUsername, '] exists.');
	          set `Status` = 1;
	          leave tryBlock;
	        end if;
		        
		  		delete from ResultSet	 
				where AuctionID not in (
				   select PO.AuctionID
				    from Post PO
				    where PO.CustomerID = SSN
				      union
				    select B.AuctionID
				    from Bid B
				    where B.CustomerID = SSN
			  );
			end if;
			
			-- Determine which auctions are expired. If it is, then set Expired to 'Y', else 'N'
		  update ResultSet RS
		  set Expired = (case when RS.CopiesSold = 0 and RS.ExpirationDate > now() then 'N'
		  					 else 'Y' end);
		  					 
		  -- Delete all auctions with a seller not matching the specified seller, if one was given.
		  if (coalesce(Seller, '') != '' ) then
			  delete from ResultSet
			  where SellerUsername != Seller;
		  end if;
		  

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
      select ItemName, ItemType, Description, ItemYear, NumCopies, SellerUsername, CurrentBid, SecondsLeft, AuctionID, Expired, Reserve, MinimuBid from ResultSet order by SecondsLeft;
    end if;

  end $$

delimiter ;