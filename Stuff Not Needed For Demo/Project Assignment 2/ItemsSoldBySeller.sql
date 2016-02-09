/***************************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Returns items sold by a given seller and corresponding auction info.
--
-- Parameters:
-- 	  SSN int unsigned:   [Required]	The SSN of the customer. ? in the following query is the SSN
--
-- Example call:
--    select distinct           A.AuctionID,
--                            P.UserName as SellerUserName,
--                            I.Name as ItemName,
--                            I.Type as ItemType,
--                            PO.PostDate,
--                            PO.ExpireDate,
--                            I.Description
--    from Auction A, Post PO, Item I, Person P
--    where  PO.AuctionID = A.AuctionID
--          and PO.CustomerID = 1 -- 1 is the SSN of customer 'phil'
--          and A.Copies_Sold > 0
--          and A.ItemID    = I.ItemID
--          and P.SSN = PO.CustomerID;
--
--  Example output:
--    AuctionID         int unsigned  -- The id of the auction
--    SellerUserName    char(20)      -- The username of the seller.
--    ItemName          char(255)     -- The name of the item
--    ItemType          char(255)     -- The type of the item
--    Description       varchar(255)  -- The description of the item
--    PostDate          datetime      -- The date the auction was posted
--    ExpireDate        datetime      -- The date the auction ended
--
-- Example output with demo data, if we search for items sold by customer 'phil' who's SSN in our database is 1:
--    AuctionID, SellerUserName, ItemName, ItemType,  Description, PostDate,                 ExpireDate
--            1,           phil,  Titanic,      DVD,        NULL,  "2015-10-27 21:14:20",    "2015-10-27 21:14:20"
--
--    AuctionID 1 is the auction for Titanic, which phil successfully sold. This is why we get this output.
/***************************************************************************************************************************/

-- Get the item and corresponding auction info sold by this seller where atleast one item has been sold
select distinct           A.AuctionID,
                            P.UserName as SellerUserName,
                            I.Name as ItemName,
                            I.Type as ItemType,
                            PO.PostDate,
                            PO.ExpireDate,
                            I.Description
from Auction A, Post PO, Item I, Person P
where  PO.AuctionID = A.AuctionID
      and PO.CustomerID = ? -- ? is the SSN of the seller we are searching for
      and A.Copies_Sold > 0
      and A.ItemID    = I.ItemID
      and P.SSN = PO.CustomerID;

