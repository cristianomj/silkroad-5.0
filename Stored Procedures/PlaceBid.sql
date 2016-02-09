/**********************************************************************************************************************/
-- PLACEHOLDER. Just a simple proc for testing
/**********************************************************************************************************************/

delimiter $$

drop procedure if exists PlaceBid;

create procedure PlaceBid
(
	AuctionID 	int unsigned,
  	BidPrice 	decimal(13,2) unsigned,
  	ItemID 		int unsigned,
  	Username 	varchar(20)
)

begin
  		-- Declare local variables
  		declare SSN					varchar(9);
  		declare BidIncrement		decimal(13,2);
  		declare MinimumBid		decimal(13,2);
  		declare CurrentBid		decimal(13,2);
  		declare CurrentHighBid	decimal(13,2);
  		declare ProxyBid			decimal(13,2);
  		declare ReturnMsg			varchar(256) default '';
  		declare `Status`			int default 0;
  		declare ProxySSN			varchar(9);
  		declare diff				decimal(13,2);
  		
  		/*declare exit handler for sqlexception
	      begin
	        rollback;
	        set `Status` = 2;
	        set ReturnMsg = 'There was an unexpected server error.';
	        select Status, ReturnMsg;
	        select 
	      end;*/
	      
	   DECLARE EXIT HANDLER FOR SQLEXCEPTION    
		BEGIN

		 GET DIAGNOSTICS CONDITION 1
		    @p2 = MESSAGE_TEXT; 
		    SELECT @p2;
		END;
	      
	   set `Status` = 0;
	      
	   -- Transaction starts here
	   start transaction;
	   
	   tryBlock: begin
  
	  		-- Get necessary info to place bid
	  		set SSN = GetSSN(Username, 'Customer');
			-- select SSN;
			
			-- Auction info
			select A.MinimuBid, A.BidIncrement, A.CurrentBid, A.CurrentHighBid
			into MinimumBid, BidIncrement, CurrentBid, CurrentHighBid
			from Auction A 
			where A.AuctionId = AuctionID;
			
			/*select MinimumBid			as 'MinimumBid',
					 BidIncrement 		as 'Increment',
					 CurrentBid 		as 'CurrentBid',
					 CurrentHighBid 	as 'CurrentHighBid';*/
					 
			-- IS IT FIRST BID?
			if isnull(CurrentBid) then
				-- select CurrentBid as 'CurrentBid';
			
				if BidPrice < MinimumBid then
					set ReturnMsg = concat('Bid has to be $', MinimumBid + BidIncrement, ' or higher.');
        			set `Status` = 1;
       			leave tryBlock;
				end if;
				
				set CurrentBid = MinimumBid;
				
				if BidPrice <=> MinimumBid then
					-- FIRST BID MATCHES MINIMUM BID
					insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
					values (AuctionID, now(), MinimumBid, SSN, ItemID, b'0');
				end if;
				
				-- IS IT GREATER THAN MINIMUM BID?
				if BidPrice > MinimumBid then
					-- Current high bid becomes bid price
					set CurrentHighBid = BidPrice;
					
					insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
					values (AuctionID, now(), CurrentBid, SSN, ItemID, b'1'),
							 (AuctionID, now(), CurrentHighBid,   SSN, ItemID, b'0');
				end if;
			
			else -- NOT FIRST BID
				-- BID IS LOWER THAN REQUIRED
				if BidPrice < CurrentBid + BidIncrement then
					set ReturnMsg = concat('Bid has to be $', CurrentBid + BidIncrement, ' or higher.');
        			set `Status` = 1;
       			leave tryBlock;
				end if;
				
				-- AT THIS POINT WE SHOULD CHECK IF THERE IS A PROXY BID IN PLACE
				if isnull(CurrentHighBid) then
					-- CHECK IF BID IS GREATER THAN CURRENTBID + INCREMENT
					if BidPrice > CurrentBid + BidIncrement then
						-- BID BECOMES A PROXY BID
						set CurrentBid = CurrentBid + BidIncrement;
						set CurrentHighBid = BidPrice;
						
						insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
						values (AuctionID, now(), CurrentBid, SSN, ItemID, b'1'),
							 	 (AuctionID, now(), CurrentHighBid,   SSN, ItemID, b'0');
					
					-- BID MATCHES REQUIRED BID AMMOUNT
					else
						set CurrentBid = CurrentBid + BidIncrement;
						
						insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
						values (AuctionID, now(), CurrentBid, SSN, ItemID, b'0');		 	 
					
					end if;
				-- THERE IS A PROXY BID
				else
					-- START BY GETTING PROXY BID INFO
					select B.CustomerID 
					into ProxySSN
					from Bid B 
					where B.AuctionId = AuctionID 
					order by B.BidPrice desc
					limit 1;
				
					-- CHECK IF BID IS GREATER THAN CURRENTBID + INCREMENT
					if BidPrice > CurrentBid + BidIncrement then
						-- IS IT HIGHER THAN CURRENT HIGH?
						if BidPrice > CurrentHighBid then
							-- select 'NEW CURRENT HIGH';
							
							set CurrentBid = CurrentHighBid + BidIncrement;
							set CurrentHighBid = BidPrice;
							
							insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
							values (AuctionID, now(), CurrentBid, SSN, ItemID, b'1'),
							 	 	 (AuctionID, now(), CurrentHighBid, SSN, ItemID, b'0');
						
						-- PROXY BID WILL OUTBID INCOMING BID
						else
							-- select 'PROXY WILL OUTBID';
							
							if SSN <=> ProxySSN then
								set ReturnMsg = concat('Bid has to be $', CurrentHighBid + BidIncrement, ' or higher.');
        						set `Status` = 1;
       						leave tryBlock;
							end if;
							
							-- CHECK IF PROXY BID WILL OUTBID CURRENT HIGH
							if BidPrice + BidIncrement >= CurrentHighBid then
								-- select 'PROXY HIGHER THAN CURRENT HIGH';
								
								set CurrentBid = CurrentHighBid;
								set CurrentHighBid = NULL;
								
								insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
								values (AuctionID, now(), BidPrice, SSN, ItemID, b'0');
								
							
							else
								-- select 'PROXY WILL OUTBID WITH BID INCREMENT';
								
								set CurrentBid = BidPrice + BidIncrement;
								
								insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
								values (AuctionID, now(), BidPrice, SSN, ItemID, b'0'),
							 	 	 	 (AuctionID, now(), BidPrice + BidIncrement, ProxySSN, ItemID, b'1');
							
							end if;
						
						end if;

					-- BID MATCHES REQUIRED BID
					else
						if BidPrice > CurrentHighBid then
							
							-- THIS BID BECOMES NEW CURRENT AND NEW HIGH IS NULL
							-- select 'NEW CURRENT MATCH';
							
							set CurrentBid = BidPrice;
							set CurrentHighBid = NULL;
							
							insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
							values (AuctionID, now(), CurrentBid, SSN, ItemID, b'0');
							
							
						-- PROXY BID WILL OUTBID INCOMING BID
						else
							-- select 'PROXY WILL OUTBID MATCH';
							
							-- CHECK IF PROXY BID WILL OUTBID CURRENT HIGH
							if BidPrice + BidIncrement >= CurrentHighBid then
								-- select 'PROXY HIGHER THAN CURRENT HIGH MATCH';
								
								set CurrentBid = CurrentHighBid;
								set CurrentHighBid = NULL;
								
								insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
								values (AuctionID, now(), BidPrice, SSN, ItemID, b'0');
							
							else
								-- select 'PROXY WILL OUTBID WITH BID INCREMENT MATCH';
								
								set CurrentBid = BidPrice + BidIncrement;
								
								insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
								values (AuctionID, now(), BidPrice, SSN, ItemID, b'0'),
							 	 	 	 (AuctionID, now(), BidPrice + BidIncrement, ProxySSN, ItemID, b'1');
							
							end if;
						
						end if;
					end if;
									
					/*-- IS BID GREATER THAN CURRENT HIGH?
					if BidPrice < CurrentHighBid then
						-- BID WILL BE PLACE BUT PROXY WILL OUTBID IT
						
						-- START BY GETTING PROXY BID INFO
						select B.SSN 
						into ProxySSN
						from Bid B 
						where B.AuctionId = AuctionID 
						order by B.BidPrice desc
						limit 1;
						
						
					-- WE CAN GO AHEAD AND OUTBID INCOMING BID
					else
						set CurrentHighBid = BidPrice;
						set CurrentBid = CurrentBid + Increment;
						
						insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID, IsProxy)
						values (AuctionID, now(), BidPrice, SSN, ItemID, b'0');
					
					end if;*/
				
				end if;
				
			end if; -- IS IT FIRST BID
			
			-- Update Current and Current High Bids
			update Auction A
			set A.CurrentBid = CurrentBid,
				 A.CurrentHighBid = CurrentHighBid
			where A.AuctionID = AuctionID;
			
			
					 
			/*-- Current Bid						
			select Max( B.BidPrice )
			into CurrentBid
			from Bid B
			where B.AuctionID = AuctionID
					and B.BidPrice < ( select MAX( B2.BidPrice)
												from Bid B2
												where B2.AuctionID = AuctionID );
											
			select CurrentBid as 'SECOND HIGHEST BID';*/
					 
				 
			
			/*if (BidPrice >= NewCurrentBid) then
				
				if (BidPrice > CurrentHighBid) then
					
					update Auction A
					set A.CurrentHighBid = BidPrice
					where A.AuctionID = AuctionID;
					
				end if;
				
				update Auction A
				set A.CurrentBid = NewCurrentBid
				where A.AuctionID = AuctionID;
			
				insert into Bid (AuctionID, BidTime, BidPrice, CustomerID, ItemID)
				values (AuctionID, now(), NewCurrentBid, SSN, ItemID);
			
			else
				set ReturnMsg = concat('Place a bid of ''', NewCurrentBid, ''' or higher.');
        		set `Status` = 1;
			
			end if;*/

		end tryBlock;
		
		if (`Status` != 0) then
			rollback;
			select Status, ReturnMsg;
		else
			commit;
			select Status, ReturnMsg;
		end if;

end $$
delimiter ;

