/**********************************************************************************************************************/
-- Author: Kevin Young
--
-- Description:
--    Create a view that returns a best-seller list.
--
-- Example call:
--    select * from BestSellerList;
--
-- Example output:
--    UserName          varchar(20)   -- The username of the seller.
--    ItemsSold         int unsigned  -- The number of items sold by the seller
--
-- Example output with demo data:
--    UserName, ItemsSold
--        phil,         1
/**********************************************************************************************************************/

-- Get the username of the sellers and the number of items they've sold in auctions they've posted,
-- we then order the number of items from highest to lowest. Whichever seller has sold the most will be in the first row
-- returned
drop view if exists BestSellerList;
 create view BestSellerList
   as
   select UserName, sum(CopiesSold) as ItemsSold
        from Auction A, Post P, User U
        where A.AuctionID = P.AuctionID
          and U.UserID = P.CustomerID and U.UserType = 'Customer'
        group by P.CustomerID
        order by ItemsSold;