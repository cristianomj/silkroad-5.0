/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Return a best-seller list.
--
-- Example call:
--    select P.UserName, sum(Copies_Sold) as ItemsSold
--        from Auction A, Post PO, Person P
--       where A.AuctionID = PO.AuctionID
--              and P.SSN = PO.CustomerID
--        group by PO.CustomerID
--        order by ItemsSold desc;
--
-- Example output:
--    UserName          char(20)      -- The username of the seller.
--    ItemsSold         int unsigned  -- The number of items sold by the seller
--
-- Example output with demo data:
--    UserName, ItemsSold
--        phil,         1
--        john,         0
--
--    Because phil posted the Titanic auction which was bought, while john posted the Nissan Sentra auction which
--    no bids were placed on.
/**********************************************************************************************************************/

-- Get the username of the sellers and the number of items they've sold in auctions they've posted,
-- we then order the number of items from highest to lowest. Whichever seller has sold the most will be in the first row
-- returned.
select P.UserName, sum(Copies_Sold) as ItemsSold
        from Auction A, Post PO, Person P
        where A.AuctionID = PO.AuctionID
              and P.SSN = PO.CustomerID
        group by PO.CustomerID
        order by ItemsSold desc;