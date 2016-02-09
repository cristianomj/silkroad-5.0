/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
-- 	  This procedure gets all the bids made on the given auction.
--
-- Parameters:
-- 	  AuctionID int unsigned:   [Required]	 	The id of the auction.
--
-- Return Statuses:
--    0 - Success
--    1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
--    call GetAuctionBidHistory(1);
--
-- Example output:
--    If there are no errors then ResultSet 1 and 2 are returned.
--    Else only ResultSet 1 is returned.
--
--  ResultSet 1:
--    Status    int         not null, -- Indicates if there was an error or not
--    ReturnMsg varchar(255) null     -- If there was en error, this will contain the error message
--
--  ResultSet 2:
--    BidTime     datetime                -- The time the bid was made
--    BidPrice    decimal(13,2)           -- The amount of the bid
--    UserName    char(20)                -- The username of the customer who made the bid
--
/***************************************************************************************************************************/

delimiter $$

drop procedure if exists GetAuctionBidHistory;

create procedure GetAuctionBidHistory(
  AuctionID int unsigned
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare `ProxyBid`  decimal(13,2);

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
    -- Create the temporary result set table
    --

    drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
      BidTime     datetime                  not null,
      BidPrice     decimal(13, 2) unsigned   not null,
      BuyerUsername char(20)              not null
    );

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

      tryBlock: begin

      --
       -- Check that the required parameters were passed in
     --

      if (AuctionID is null)
      then
        set ReturnMsg = 'Must provide the auction identifier.';
        set `Status` = 1;
        leave tryBlock;
      end if;

      --
      -- Check that the passed in parameters contain valid data
      --

      if not exists(select AuctionID
                    from Auction A
                    where A.AuctionID = AuctionID)
      then
        set ReturnMsg = 'This auction does not exist.';
        set `Status` = 1;
        leave tryBlock;
      end if;

      --
      -- At this point, all validation is complete and we can go ahead with getting the information
      --
      select A.CurrentHighBid
      into ProxyBid
      from Auction A
      where A.AuctionID = AuctionID;
      
      if isnull(ProxyBid) then
      	-- Insert the Time of the bid, the amount of the bid, and the username of the customer who made the bid
      	insert into TempResultSet (BidTime, BidPrice, BuyerUsername)
        	select B.BidTime, B.BidPrice, P.Username
        	from Bid B, Person P
        	where B.AuctionID = AuctionID
              	and P.SSN = B.CustomerID;
      else
      	insert into TempResultSet (BidTime, BidPrice, BuyerUsername)
        	select B.BidTime, B.BidPrice, P.Username
        	from Bid B, Person P
        	where B.AuctionID = AuctionID
              	and P.SSN = B.CustomerID
              	and B.BidPrice != ProxyBid;
      end if;

      

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
      select BidTime, BidPrice, BuyerUsername from TempResultSet order by BidPrice desc;
    end if;

  end $$

delimiter ;
