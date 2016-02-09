call dropTables();

-- Insert seller phil who will post the auction for Titanic
insert into Person(Type, UserName, SSN, Password, FirstName, LastName, Address, ZipCode, Telephone, Email)
values('Customer', 'phil', '1', 'phil', 'Lewis', 'Phil', '135 Knowledge Lane, Stony Brook, NY', '11794', '(516)666-8888', 'pml@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values('1', '6789-2345-6789-2345', 1);

-- Insert seller john who will post the auction for Nissan Sentra
insert into Person(Type, SSN, UserName, Password, FirstName, LastName, Address, ZipCode, Telephone, Email)
values('Customer', '2', 'john', 'john', 'John', 'Smith', '789 Peace Blvd., Los Angeles, CA', '12345', '(412)443-4321', 'shlu@ic.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values('2', '2345-6789-2345-6789', 1);

-- Insert customer shiyong
insert into Person(Type, SSN, UserName, Password, FirstName, LastName, Address,
                   ZipCode, Telephone, Email)
values           ('Customer', '3',      'shiyong', 'shiyong', 'Shiyong', 'Lu', '123 Success Street, Stony Brook, NY',
                  '11790', '(516)632-8959', 'shiyong@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values('3', '1234-5678-1234-5678', 1);

-- Insert customer haixia
insert into Person(Type, SSN, UserName, Password, FirstName, LastName, Address,
                  ZipCode, Telephone, Email)
values           ('Customer', '4', 'haixia', 'haixia', 'Haixia', 'Du', '456 Fortune Road, Stony Brook, NY',
                  '11790', '(516)632-4360', 'dhaixia@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values('4', '5678-1234-5678-1234', 1);

-- Insert employee David Smith who will be the customer rep for the Nissan Sentra and Titanic auction
insert into Person(Type, UserName, Password, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email)
values('Employee', 'DSmith', 'DSmith', '123456789', 'David', 'Smith', '123 College road, Stony Brook, NY', '11790', '(516)215-2345', 'dsmith@aol.com');

insert into Employee(EmployeeID, HourlyRate, StartDate, Level)
values('123456789', 60.00, '1998-11-01', 0);

-- Insert employee David Warren who will be the manager
insert into Person(Type, UserName, Password, SSN, FirstName, LastName, Address, ZipCode, Telephone,  Email)
values('Employee', 'DWarren', 'DWarren', '789123456', 'David', 'Warren', '456 Sunken Street, Stony Brook, NY', '11794', '(516)632-9987', 'dsmith@aol.com');

insert into Employee(EmployeeID, HourlyRate, StartDate, Level)
values('789123456', 50.00, '1999-02-02', 1);

-- Insert Titanic into the Item table
insert into Item(ItemID, Name, Type, Year, NumCopies)
values(1, 'Titanic', 'DVD', 2005, 4);

-- Insert Nissan Sentra into the Item table
insert into Item(ItemID, Name, Type, Year, NumCopies)
values(2, 'Nissan Sentra', 'Car', 2007, 1);

-- Create the auction for copy 1 of Titanic
insert into auction(AuctionID, BidIncrement, MinimuBid, Copies_Sold, Monitor, ItemID, Reserve)
    values(1, 1, 5, 0, 123456789, 1, 10);

insert into post(ExpireDate, PostDate, CustomerID, AuctionID)
    values(now() + interval 3 day, now(), '1', 1);

update Item set NumCopies = NumCopies - 1 where itemid = 1;

-- Create the auction for copy 1 of Nissan Sentra
insert into auction(AuctionID, BidIncrement, MinimuBid, Copies_Sold, Monitor, ItemID, Reserve)
values(2, 10, 1000, 0, 123456789, 2, 2000);

insert into post(ExpireDate, PostDate, CustomerID, AuctionID)
values(now() + interval 3 day, now(), '2', 2);

update Item set NumCopies = NumCopies - 1 where itemid = 2;

-- Insert the bids

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
    values(1, now(), 5, '4', 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 30 second, 9, '3', 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 1 minute, 10, '3', 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 2 minute, 11, '3', 1);

-- Close the Titanic auction
update Post set ExpireDate = now() where auctionid = 1;
update Auction set Copies_Sold = 1, CurrentBid = 11 where auctionid = 1;

-- Record the titanic sale
insert into Sales(BuyerID, SellerID, Price, Date, ItemID, AuctionID)
  select B.CustomerID, P.CustomerID, B.BidPrice, P.ExpireDate, A.ItemID, A.AuctionID -- ID of Auction that just ended
    as AuctionID
  from Bid B, Post P, Auction A
  where B.AuctionID = 1
        and A.AuctionID = 1
        and B.BidPrice = (select max(B2.BidPrice) from Bid B2 where B2.AuctionID = 1 )
        and P.AuctionID = 1;

