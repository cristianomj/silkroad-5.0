# Creates a view of all items sold in auctions #
# orders them by number of copies sold #
# then selects the top 10 from the view #
# creates a top 10 list #
drop view if exists BestSellingItems;
create view BestSellingItems (ItemName, CopiesSold) as
select I.Name, A.CopiesSold
from item I, Auction A
where I.ItemID = A.ItemId
order by CopiesSold;

select * from BestSellingItems
limit 10;