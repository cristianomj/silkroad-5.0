/***************************************************************************************************************************/
-- Author: Kevin Young
-- 
-- Description:
-- 		This procedure adds a new Auction by adding a record to the Auction and Post tables.
-- 		Every time an auction is posted, the NumCopies column in Item for the item being sold is decremented by one.
--       If an auction is attempted to be posted where the selected item has no more copies to be sold, an error is returned.
-- 
-- Parameters:
-- 		ItemName 				char(255): 		[Required]	The name of the item that the auction is selling.
-- 		SellerUserName 	char(20): 		[Required] 	The username of the seller who is posting this auction.
-- 		OpeningTime 		datetime: 	 		[Optional] 	The time this auction starts. Defaulted to now() if not provided.
-- 		Duration 				int unsigned: 	[Required] 	The amount of days this auction will last. Must be 3, 5, or 7.
-- 		Increment 			decimal(13,2) unsigned: 	[Optional]	The increment of the auction. Defaulted to 25% of the opening bid if not provided.
-- 		OpeningBid 			decimal(13,2) unsigned: 	[Required] 	The bid to start off the auction.
-- 		Reserve 				decimal(13,2) unsigned: 	[Optional]	The minimum amount the seller will allow the item to be sold at.
-- 
-- Return Statuses:
-- 		0 - Success
-- 		1 - Business logic error
-- 		2 - sqlexception error
-- 
-- Example call:
-- 		call PostAuction('Titanic', 'phil', now(), 3, 1, 5, 10);
-- 
-- Example output:
--  	ResultSet 1 is returned.
-- 
--  	ResultSet 1:
--  			Status 		int 				 not null	 -- Indicates if there was an error or not
--  			ReturnMsg varchar(255) null 		 -- If there was en error, this will contain the error message
-- 
/***************************************************************************************************************************/

delimiter $$

drop procedure if exists PostAuction;

create procedure PostAuction (
	ItemName 				char(255),
	SellerUserName 	   char(20),
	OpeningTime 		   datetime,
	Duration 				int unsigned,
	OpeningBid 			   decimal(13, 2) unsigned,
	Reserve 				   decimal(13, 2) unsigned
)
deterministic

begin

   -- 
   -- Initialize local variables
   -- 

   	declare ReturnMsg					varchar(255);
		declare `Status`					int;
		declare AuctionID 				int unsigned;
		declare Monitor				   varchar(11); -- The employee that will be overseeing this auction
   	declare ItemID 					int unsigned; -- The item this auction is selling
   	declare SellerSSN 				varchar(11); -- The customer posting this auction
   	declare ExpirationDate			datetime;
   	declare Increment				decimal(13,2)  unsigned;
	
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
		-- Begin the block where we will do business logic.
		-- The block wll be used as a way to exit the business logic if we encounter an error.
		-- 

		tryBlock:begin
		
			-- 
			 -- Check that the required parameters were passed in
			 -- 

			if (Duration is null) then
				set ReturnMsg = 'Must provide the duration.';
				set `Status` = 1;
				leave tryBlock;
			 end if;

			if (coalesce(ItemName, '') = '') then
				set ReturnMsg = 'Must provide the name of the item to be sold.';
				set `Status` = 1;
				leave tryBlock;
			 end if;

			 if (coalesce(SellerUserName, '') = '') then
				set ReturnMsg = 'Must provide the user name of the seller posting this auction.';
				set `Status` = 1;
				leave tryBlock;
			 end if;

			 -- 
			 -- Check that the passed in parameters contain valid data
			 -- 
			 
			 -- Check that a user with the given username exists
	      set SellerSSN = GetSSN(SellerUserName, 'Customer');
	      if (SellerSSN is null) then
	        set ReturnMsg = concat('No user with username: [', UserName, '] exists.');
	        set `Status` = 1;
	        leave tryBlock;
	      end if;

			 -- Check that the duration is 3, 5, or 7 days
			if (Duration not in (3, 5, 7)) then
				set ReturnMsg = 'The duration of an auction must be 3, 5, or 7 days.';
				set `Status` = 1;
				leave tryBlock;
			end if;

			-- Check the opening bid is greater or equal to 0
			if (OpeningBid < 0) then
				set ReturnMsg = 'The opening bid must be greater or equal to 0.';
				set `Status` = 1;
				leave tryBlock;
			end if;

			set Increment = OpeningBid * .20;

			-- Check that the reserve is not less than the opening bid
			if (Reserve != 0) then
				if (Reserve < OpeningBid) then
					set ReturnMsg = 'The reserve must be greater than or equal to the opening bid.';
					set `Status` = 1;
					leave tryBlock;
				end if;
			end if;

			-- Grab the item id from the Item table using the passed in ItemName.
			-- If it does not exist, return with an error.
			set ItemID = (select I.ItemID from Item I where I.Name = ItemName);
			if (ItemID is null) then
				set ReturnMsg = concat('No item with ItemName: [', ItemName, '] exists.');
				set `Status` = 1;
				leave tryBlock;
			end if;

			-- Check that there are copies of this item left
			if ((select NumCopies from Item I where I.ItemID = ItemID) = 0) then
				set ReturnMsg = concat('There are no more copies of: [', ItemName, '] to be sold.');
				set `Status` = 1;
				leave tryBlock;
			end if;

			-- Random select a customer representative employee to oversee this auction.
			-- If there are no existing customer representatives then return with an error
			set Monitor = (select EmployeeID from Employee where Level = 0 order by rand() limit 1);
			if (Monitor is null) then
				set ReturnMsg = concat('There is no customer representative available to monitor this auction.');
				set `Status` = 1;
				leave tryBlock;
			end if;

			-- 
			-- At this point, all validation is complete and we can go ahead with adding the new record
			-- 

			-- If the Auction table is not empty, grab the next number in the sequence of AuctionIDs
			-- So if the last added auction had AuctionID 1 then this one will have AuctionID 2
			if exists (select A.AuctionID from Auction A) then
				set AuctionID = (select A.AuctionID from Auction A order by A.AuctionID desc limit 1) + 1;
			else -- The table is empty so start the sequence at 1
				set AuctionID = 1;
			end if;

			-- Add the new auction record TODO. Current/HighBid?
			insert into Auction(AuctionID, Monitor, ItemID, BidIncrement, Reserve, MinimuBid)
			values(AuctionID, Monitor, ItemID, Increment, Reserve, OpeningBid);

			-- Default the opening time to now if it is not provided
			if (OpeningTime is null) then
				set OpeningTime = now();
			end if;

			-- The expiration date is the opening time + (duration number of days)
			set ExpirationDate =  (select date_add(OpeningTime, interval Duration day));

			-- Add the new post record
			insert into Post(ExpireDate, PostDate, CustomerID, AuctionID)
			values(ExpirationDate, OpeningTime, SellerSSN, AuctionID);

			-- Decrement the number of copies available for the item being sold
			update Item I
			set NumCopies = NumCopies - 1
			where I.ItemID = ItemID;

		end tryBlock;

	if (`Status` != 0) then
		rollback;
	else
		commit;
	end if;  
	
	select Status, ReturnMsg;

end $$

delimiter ;