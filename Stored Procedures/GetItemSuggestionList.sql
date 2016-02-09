/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns a personalized item suggestion list.
--    We'll return all the item details of items that have the same type as the type of item where the customer
--    has bidded on the most. So if a user has placed bids on more auctions where those auctions were selling
--    an item of type 'DVD', then we'll return details of all 'DVD' items that are still in stock.
--
-- Parameters:
--    UserName [Required] -- The username of the customer who we will be getting a personalized item suggestion list for.

-- Return Statuses:
--    0 - Success
--    1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
--    call GetItemSuggestionList('phil');
--
-- Example output:
--    If there are no errors then ResultSet 1 and the specified columns from ResultSet 2 are returned.
--    Else only ResultSet 1 is returned.
--
--  ResultSet 1:
--    Status            int          not null         -- Indicates if there was an error or not
--    ReturnMsg         varchar(255) null             -- If there was en error, this will contain the error message
--
--  ResultSet 2:
--    ItemName         varchar(255)   not null       -- The name of the item.
--    Description      blob           null           -- The description of the item.
--    ItemType         varchar(255)   not null       -- The type of the item.
--
/***************************************************************************************************************************/

delimiter $$

drop procedure if exists GetItemSuggestionList;

create procedure GetItemSuggestionList(
  Username varchar(20)
)
deterministic

  begin

    -- 
    -- Initialize local variables
    -- 

    declare ReturnMsg   varchar(255);
    declare `Status`    int;
    declare SSN      varchar(11);

    
      
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

    drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
      ItemType        varchar(255)    not null,
      AuctionsBiddedOn   int unsigned,
      NumCopies			int unsigned
    );
    
    

    -- 
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    -- 

    tryBlock: begin

      -- 
      -- Check that the required parameters were passed in
      -- 

      if (coalesce(Username, '') = '') then
        set ReturnMsg = 'Must provide the username of the customer.';
        set `Status` = 1;
        leave tryBlock;
      end if;

      -- 
      -- Check that the passed in parameters contain valid data
      -- 

      -- Check that a user with the given username exists
      set SSN = GetSSN(Username, 'Customer');
      if (SSN is null) then
        set ReturnMsg = concat('No user with username: [', Username, '] exists.');
        set `Status` = 1;
        leave tryBlock;
      end if;

      -- 
      -- At this point, all validation is complete and we can go ahead with getting the information
      -- 

      -- We look at the Bid table to see how many auctions a customer has bidded on and group it with the item
		-- type. So if a user bid on 3 auctions, all of which were for items with item type 'DVD', then
		-- the table will look like ItemType = 'DVD', AuctionsBiddedOn = 3
      insert into TempResultSet(ItemType, AuctionsBiddedOn, NumCopies)
        select I.Type, count(distinct B.AuctionID) as AuctionsBiddedOn, I.NumCopies
        from Bid B, Item I, Auction A
        where B.CustomerID = SSN
              and B.AuctionID = A.AuctionID
              and A.ItemID = I.ItemID
        group by I.Type;

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;

      -- Return all the item details of items that have the same type as the type of item where the customer
		-- has bidded on the most, and that item is in stock. So if a user has placed bids on more auctions where those
		-- auctions were selling an item of type 'DVD', then we'll return all 'DVD' items.

		-- If a customer has bidded on DVDs and Cars, and bidding on DVDs the most, but at this time there are no DVDs in stock
		-- then we return all Cars available. If there are no DVDs and no Cars available, then we return nothing.
		drop temporary table if exists TempResultSet2;
	    create temporary table TempResultSet2 (
	      ItemType        varchar(255)    not null,
	      NumCopies			int unsigned,
	      `Year` year, 
	      Description varchar(255), 
	      Name		varchar(255)
	    );
    	
		insert into TempResultSet2(Name, ItemType, `Year`, Description, NumCopies)
	      select Name, I.`Type`, `Year`, Description, NumCopies
	      from Item I
	      where I.`Type` in (select RS.ItemType
	                     from TempResultSet RS
	                     order by AuctionsBiddedOn desc); 
	   
	   -- Do not suggest items that the customer has already bought
	   delete from TempResultSet2 
		where Name in (select I.Name 
							from Sales S, Item I
							where S.BuyerID = SSN
							and S.ItemID = I.ItemID);               
	   
								
		select Name, ItemType, `Year`, Description, NumCopies from TempResultSet2;   
    end if;

  end $$

delimiter ;
