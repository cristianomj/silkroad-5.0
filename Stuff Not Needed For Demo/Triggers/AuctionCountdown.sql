CREATE TRIGGER AuctionCountdown AFTER INSERT (or UPDATE)
ON Auction
FOR EACH ROW
UPDATE TimeLeft SET TimeLeft = (TimeLeft - TIMEDIFF(Now(), OpeningTime)) WHERE ClosingTime is null
