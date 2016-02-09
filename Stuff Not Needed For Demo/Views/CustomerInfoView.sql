create view CustomerInfoView as
select CustomerID, Email, ItemsPurchased, ItemsSold, Rating
from Customer