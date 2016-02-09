/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns items available with a particular keyword or set of keywords in the item name, and corresponding auction info.
--
-- Type of Transaction: Customer-Level
--
-- Parameters:
-- 	  ItemName1 varchar(255): 	[Required if ItemType2 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemName2 varchar(255): 	[Required if ItemType1 and ItemType3 not supplied]	 --	One of the item name keywords
--    ItemName3 varchar(255): 	[Required if ItemType1 and ItemType2 not supplied]	 --	One of the item name keywords
--
-- Return Statuses:
--    0 - Success
--    1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
--    call GetItemsByKeywords('Car', 'DVD', null);
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
--    AuctionID         int unsigned               -- The id of the auction
--    SellerUserName    char(20)                   -- The username of the customer selling the item.
--    ItemName          char(255)                  -- The name of the item
--    ItemType          char(255)                  -- The type of the item
--    Description       varchar(255)               -- The description of the item
--    PostDate          datetime                   -- The date the auction was posted
--    ExpireDate        datetime                   -- The date the auction ends/ended
--
/**********************************************************************************************************************/

delimiter $$

drop procedure if exists GetItemsByKeywords;

create procedure GetItemsByKeywords(
  ItemName1 varchar(255),
  ItemName2 varchar(255),
  ItemName3 varchar(255),
  Username	varchar(20),
  ReturnAllAuctions int
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare SSN varchar(9);
    declare ReturnAllItems int;
    
   

    --
    -- Declare local variables
    --

    set `Status` = 0;
    set ReturnAllItems = 0;

    --
    -- Begin the transaction
    --

    start transaction;

    --
    -- Create the result set table
    --

    drop table if exists ResultSet;
    create table ResultSet (
      AuctionID           int unsigned          not null,
      ItemID              int unsigned          not null,

      -- User friendly columns
      MinimuBid DECIMAL(13,2) unsigned 	NOT NULL,
      SellerUsername        varchar(20)         not null,
      CopiesSold           int unsigned           not null,
      ItemName            varchar(255)           not null,
      ItemType            varchar(255)            not null,
      Description         blob                    null,
      ItemYear					Year							null,
      NumCopies				int unsigned				null,
      PostDate            datetime                not null,
      ExpirationDate      datetime                not null,
      SecondsLeft  varchar(255)							not null,
      CurrentBid	DECIMAL(13,2) unsigned	null,
      Expired varchar(1),
      Reserve decimal(13,2) unsigned null
    );

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

    tryBlock: begin

      --
      -- Check that the required parameters were passed in
      --

      if (coalesce(ItemName1, '') = '' and coalesce(ItemName2, '') = '' and coalesce(ItemName3, '') = '') then
          set ReturnAllItems = 1;
      end if;

      --
      -- At this point, all validation is complete and we can go ahead with getting the information
      --

      -- Get the item and corresponding auction info where the auction selling the item is not
		-- expired (specifying that the item is available), and the type of the item is like at least one of the given
		-- item type keywords
		if (ReturnAllItems != 1) then
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
	        select distinct     P.UserName,
			  							 A.AuctionID,
										 A.Copies_Sold,		
										 I.ItemID,                      
			                      I.Name      as ItemName,
			                      I.Type      as ItemType,
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
				where A.ItemID         = I.ItemID
				      and PO.AuctionID = A.AuctionID
				      and A.Copies_Sold = case when ReturnAllAuctions = 0 then 0 else A.Copies_Sold end
						and PO.ExpireDate >= case when ReturnAllAuctions = 0 then now() else PO.ExpireDate end
				      and (case when coalesce(ItemName1, '') != '' then I.Name like concat('%', ItemName1, '%') end      
				           or case when coalesce(ItemName2, '') != '' then I.Name like concat('%', ItemName2, '%') end   
				           or case when coalesce(ItemName3, '') != ''  then I.Name like concat('%', ItemName3, '%') end) 
				      and PO.CustomerID = P.SSN;
	 else
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
	        select distinct     P.UserName,
			  							 A.AuctionID,
										 A.Copies_Sold,		
										 I.ItemID,                      
			                      I.Name      as ItemName,
			                      I.Type      as ItemType,
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
				where A.ItemID         = I.ItemID
				      and PO.AuctionID = A.AuctionID
				      and A.Copies_Sold = case when ReturnAllAuctions = 0 then 0 else A.Copies_Sold end
						and PO.ExpireDate >= case when ReturnAllAuctions = 0 then now() else PO.ExpireDate end						
				      and PO.CustomerID = P.SSN;
	end if; -- if (ReturnAllItems != 1)
		  					 
		-- If the username is supplied then we remove all auctions from the RS where the user was not involved
			if (coalesce(Username, '') != '' ) then
				-- Check that a user with the given username exists
	        set SSN = GetSSN(Username, 'Customer');
	        if (SSN is null) then
	          set ReturnMsg = concat('No user with username: [', UserName, '] exists.');
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