-- Insert seller phil who will post the auction for Titanic
insert into Person(UserName, SSN, FirstName, LastName, Address, ZipCode, Telephone, Email)
values('phil', 1, 'Lewis', 'Phil', '135 Knowledge Lane, Stony Brook, NY', '11794', '(516)666-8888', 'pml@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values(1, '6789-2345-6789-2345', 1);

-- Insert seller john who will post the auction for Nissan Sentra
insert into Person(SSN, UserName, FirstName, LastName, Address, ZipCode, Telephone, Email)
values(2, 'john', 'John', 'Smith', '789 Peace Blvd., Los Angeles, CA', '12345', '(412)443-4321', 'shlu@ic.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values(2, '2345-6789-2345-6789', 1);

-- Insert customer shiyong
insert into Person(SSN, UserName, FirstName, LastName, Address,
                   ZipCode, Telephone, Email)
values           (3,      'shiyong', 'Shiyong', 'Lu', '123 Success Street, Stony Brook, NY',
                  '11790', '(516)632-8959', 'shiyong@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values(3, '1234-5678-1234-5678', 1);

-- Insert customer haixia
insert into Person(SSN, UserName,FirstName, LastName, Address,
                  ZipCode, Telephone, Email)
values           (4,     'haixia', 'Haixia', 'Du', '456 Fortune Road, Stony Brook, NY',
                  '11790', '(516)632-4360', 'dhaixia@cs.sunysb.edu');

insert into Customer(CustomerID, CreditCardNum, Rating)
values(4, '5678-1234-5678-1234', 1);


-- Insert employee David Smith who will be the customer rep for the Nissan Sentra and Titanic auction
insert into Person(SSN, UserName, FirstName, LastName, Address, ZipCode, Telephone, Email)
values(123456789, 'dsmith', 'David', 'Smith', '123 College road, Stony Brook, NY', '11790', '(516)215-2345', 'dsmith@aol.com');

insert into Employee(EmployeeID, HourlyRate, StartDate, Level)
values(123456789, 60.00, '1998-11-01', 0);

-- Insert employee David Warren who will be the manager
insert into Person(SSN, UserName, FirstName, LastName, Address, ZipCode, Telephone,  Email)
values(789123456, 'dwarren', 'David', 'Warren', '456 Sunken Street, Stony Brook, NY', '11794', '(516)632-9987', 'dsmith@aol.com');

insert into Employee(EmployeeID, HourlyRate, StartDate, Level)
values(789123456, 50.00, '1999-02-02', 1);

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
    values(now() + interval 3 day, now(), 1, 1);

-- Create the auction for copy 1 of Nissan Sentra
insert into auction(AuctionID, BidIncrement, MinimuBid, Copies_Sold, Monitor, ItemID, Reserve)
values(2, 10, 1000, 0, 123456789, 2, 2000);

insert into post(ExpireDate, PostDate, CustomerID, AuctionID)
values(now() + interval 3 day, now(), 2, 2);

-- Insert the bids

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
    values(1, now(), 10, 4, 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 30 second, 10, 3, 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 1 minute, 10, 3, 1);

insert into Bid(AuctionID, BidTime, BidPrice, CustomerID, ItemID)
values(1, now() + interval 2 minute, 15, 3, 1);

-- Close the Titanic auction
update Post set ExpireDate = now() where auctionid = 1;
update Auction set Copies_Sold = 1 where auctionid = 1;