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

drop procedure if exists GetItemsSoldBySeller;

create procedure GetItemsSoldBySeller(
  UserName varchar(20)
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare SSN      varchar(11);

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
      AuctionID           int unsigned          not null,
      ItemID              int unsigned          not null,

      -- User friendly columns
      ItemName            varchar(255)           not null,
      ItemType            varchar(255)            not null,
      Description         blob                    null,
      PostDate            datetime                not null,
      ExpirationDate      datetime                not null,
      SellerUserName      varchar(20)             not null
    );

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

    tryBlock: begin

      --
      -- Check that the required parameters were passed in
      --

      if (coalesce(UserName, '') = '') then
        set ReturnMsg = 'Must provide the username of the seller.';
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
      -- At this point, all validation is complete and we can go ahead with adding the new record
      -- 

      -- Insert the item and corresponding auction info sold by this seller where atleast one item has been sold
      insert into ResultSet(AuctionID,
      								SellerUserName,
                              ItemID,
                              ItemName,
                              ItemType,
                              PostDate,
                              ExpirationDate,
                              Description)
       -- Get the item and corresponding auction info sold by this seller where atleast one item has been sold
		select distinct           A.AuctionID,
		                            P.UserName,
		                            I.ItemID,
		                            I.Name,
		                            I.Type,
		                            PO.PostDate,
		                            PO.ExpireDate,
		                            I.Description
		from Auction A, Post PO, Item I, Person P
		where  PO.AuctionID = A.AuctionID
		      and PO.CustomerID = SSN
		      and A.Copies_Sold > 0
		      and A.ItemID    = I.ItemID
		      and P.SSN = PO.CustomerID;

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
      select * from ResultSet;
    end if;

  end $$

delimiter ;