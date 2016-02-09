/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns a best-seller list.
--
-- Return Statuses:
--    0 - Success
--    1 - Business logic error
--    2 - sqlexception error
--
-- Example call:
--    call GetBestSellerList();
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
--    UserName          char(20)   not null        -- The username of the seller.
--    ItemsSold         int unsigned  not null        -- The number of items sold by the seller
--
/***************************************************************************************************************************/

delimiter $$

drop procedure if exists GetBestSellerList;

create procedure GetBestSellerList(
)
deterministic

  begin

    --
    -- Initialize local variables
    --

    declare ReturnMsg   varchar(255);
    declare `Status`    int;

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

    drop temporary table if exists TempResultSet;
    create temporary table TempResultSet (
      Username        char(20)     not null,
      ItemsSold       int unsigned   not null
    );

    --
    -- Begin the block where we will do business logic.
    -- The block wll be used as a way to exit the business logic if we encounter an error.
    --

    tryBlock: begin

      --
      -- Check that the required parameters were passed in
      --

      -- Get the username of the sellers and the number of items they've sold in auctions they've posted,
      -- when we select from the table later, we will then order the number of items from highest to lowest
      insert into TempResultSet(UserName,
                              ItemsSold)
      select P.UserName, sum(Copies_Sold) as ItemsSold
        from Auction A, Post PO, Person P
        where A.AuctionID = PO.AuctionID
              and P.SSN = PO.CustomerID
        group by PO.CustomerID
        order by ItemsSold desc;

    end tryBlock;

    if (`Status` != 0)
    then
      rollback;
      select Status, ReturnMsg;
    else
      commit;
      select Status, ReturnMsg;
      select Username, ItemsSold from TempResultSet
      order by ItemsSold desc;
    end if;

  end $$

delimiter ;