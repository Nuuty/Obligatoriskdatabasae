/*Simple queries*/
-- 1 . List alle oplysninger om alle hoteller.
SELECT * 
FROM Hotel;

-- 2. List alle oplysninger om alle hoteller i Roskilde.
SELECT * 
FROM Hotel 
WHERE Address LIKE '%Roskilde%';

-- 3. List navne og adresser på alle gæster fra Roskilde.
SELECT Name,Address 
FROM Guest 
WHERE Address LIKE '%Roskilde%';

-- 4. List navne og adresser på alle gæster fra Roskilde sorteret alfabetisk efter navn.
SELECT Name,Address 
FROM Guest 
WHERE Address LIKE '%Roskilde%' 
ORDER BY Name ASC;

-- 5. List alle dobbeltværelser med en pris under 200 pr. nat.
SELECT Types,Price 
FROM Room 
WHERE Price BETWEEN 0 AND 200;

-- 6. List alle dobbeltværelser eller familierum med en pris under 400 pr. nat.
SELECT Types,Price 
FROM Room 
WHERE Types = 'F' OR Types = 'D' AND Price BETWEEN 0 AND 400;

-- 7. List alle dobbeltværelser eller familierum med en pris under 400 pr. nat sorteret i stigende orden efter pris.
SELECT  Types,Price 
FROM Room 
WHERE Types = 'F' OR Types = 'D' AND Price BETWEEN 0 AND 400 
ORDER BY Price ASC;

-- 8. List alle gæster, som har et navn, der starter med 'G'.
SELECT Name 
FROM Guest 
WHERE Name LIKE 'G%';

/*Aggregate-funktioner*/
-- 9. Hvor mange hoteller er der?
SELECT COUNT(*) 
FROM Hotel;

-- 10. Hvor mange hoteller er der i Roskilde?
SELECT COUNT(*) 
FROM Hotel 
WHERE Address LIKE '%Roskilde%';

-- 11. Hvad er gennemsnitsprisen på et værelse?
SELECT AVG(Price) 
FROM Room;

-- 12. Hvad er gennemsnitsprisen på et enkeltværelse?
SELECT AVG(Price) 
FROM Room 
WHERE Types = 'S';

-- 13. Hvad er gennemsnitsprisen på et dobbeltværelse?
SELECT AVG(Price) 
FROM Room 
WHERE Types = 'D';

-- 14. Hvad er gennemsnitsprisen på et værelse på Hotel Scandic?
SELECT AVG(Price) 
FROM Room 
WHERE Hotel_No = 7;

-- 15. Hvad er den totale indtægt pr. nat for alle dobbeltværelser?
SELECT SUM(Price) 
FROM Room 
WHERE Types = 'D';

-- 16. Hvor mange forskellige gæster har foretaget bookinger i marts måned?
-- 2 Løsninger, nummer 2 løsning tager alle i marts måned uanset år
SELECT COUNT(*) 
FROM Booking 
WHERE (Date_From BETWEEN '2011-03-01' AND '2011-03-31') AND (Date_To BETWEEN '2011-03-01' AND '2011-03-31');

SELECT COUNT(*)
FROM Booking 
WHERE DATEPART(mm,Date_From) = '03' AND DATEPART(mm,Date_To) = '03';


-- 17. Hvor mange bookinger er der i dag på Scandic hotel?
-- 2 Løsninger alt efter hvordan spørgsmålet tolkes
SELECT COUNT(*) 
FROM Booking 
WHERE Date_From = GETDATE() AND Hotel_No = 7;

SELECT COUNT(*) 
FROM Booking 
WHERE (GETDATE() BETWEEN Date_From AND Date_To) AND Hotel_No = 7;

-- 18. Hvor mange bookinger er der i morgen på Scandic hotel?
SELECT Count(*)
FROM Booking
WHERE (DATEADD(day,1,GETDATE()) BETWEEN Date_From AND Date_To) AND Hotel_No = 7;

/*Subqueries & joins*/
-- 19. List pris og type på alle værelser på 'Prindsen'.
SELECT Price,Hotel.Hotel_No,Name,Address 
FROM Room JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No 
WHERE Hotel.Name = 'Prindsen';

-- 20. List alle gæster, der p.t. bor på 'Prindsen'.
SELECT Guest.Name,Guest.Address,Hotel.Name 
FROM Booking 
JOIN Guest ON Booking.Guest_No = Guest.Guest_No 
JOIN Hotel ON Booking.Hotel_No = Hotel.Hotel_No 
WHERE Hotel.Name = 'Prindsen' AND GETDATE() BETWEEN Date_From AND Date_To;

-- 21. List alle oplysninger om alle værelser på 'Prindsen', inklusiv navn på gæsten der bor på det givne værelse, hvis værelset er optaget.
-- 2 Løsninger
SELECT	Hotel.Name As HotelName,
		Guest.Name AS GuestName,
		Room.Price AS RoomPrice,
		Room.Room_No AS RoomNo,
		Room.[Types] AS RoomType
FROM	Hotel
JOIN	Room ON Hotel.Hotel_No = Room.Hotel_No
LEFT JOIN(
		  SELECT * 
		  FROM Booking 
		  WHERE '2011-02-06' BETWEEN Date_From AND Date_To
		 ) 
			AS BookingSubSelect 
			ON Hotel.Hotel_No = BookingSubSelect.Hotel_No 
			AND BookingSubSelect.Room_No = Room.Room_No
LEFT JOIN Guest ON Guest.Guest_No = BookingSubSelect.Guest_No
WHERE	Hotel.Name = 'Prindsen';

SELECT Room.Price,Room.Types,hotel.name,guest.name,room.Room_no
FROM Hotel
JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
LEFT JOIN Booking ON Booking.Room_No = Room.Room_No AND Booking.Hotel_No = Room.Hotel_No AND ('2011-02-06' BETWEEN Date_From AND Date_To)
LEFT JOIN Guest ON Guest.Guest_No = Booking.Guest_No
WHERE Hotel.Name = 'Prindsen';

-- 22. Hvad er den totale indkomst for alle bookinger på 'Prindsen' i dag?
SELECT SUM(Price)
FROM Hotel
JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
JOIN Booking ON Booking.Room_No = Room.Room_No AND Booking.Hotel_No = Room.Hotel_No AND ('2011-02-06' BETWEEN Date_From AND Date_To)
WHERE Hotel.Name = 'Prindsen';

-- 23. List værelser, der p.t. er ledige på 'Prindsen'.
SELECT Room.Price,Room.Types,hotel.name,room.Room_no
FROM Hotel
JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
LEFT JOIN Booking ON Booking.Room_No = Room.Room_No AND Booking.Hotel_No = Room.Hotel_No AND ('2011-02-06' BETWEEN Date_From AND Date_To)
LEFT JOIN Guest ON Guest.Guest_No = Booking.Guest_No
WHERE Hotel.Name = 'Prindsen' AND Guest.Guest_No IS NULL;

-- 24. Hvad er den mistede indtægt fra ledige værelser på 'Prindsen'? 
SELECT SUM(Price)
FROM Hotel
JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
LEFT JOIN Booking ON Booking.Room_No = Room.Room_No AND Booking.Hotel_No = Room.Hotel_No AND ('2011-02-06' BETWEEN Date_From AND Date_To)
LEFT JOIN Guest ON Guest.Guest_No = Booking.Guest_No
WHERE Hotel.Name = 'Prindsen' AND Guest.Guest_No IS NULL;

/*Gruppering*/
-- 25. List antal værelser for hvert hotel.
SELECT Hotel.Name, Count(*) AS Rooms
FROM Room
JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No
GROUP BY Hotel.Name;

-- 26. List antal værelser for hvert hotel i Roskilde.
SELECT Hotel.Name, Count(*) AS Rooms
FROM Room
JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No
WHERE Hotel.Address LIKE '%Roskilde%'
GROUP BY Hotel.Name;

-- 27. Hvad er det gennemsnitlige antal bookinger for hvert hotel i denne måned?
SELECT Count(Booking_id) AS Bookninger, Hotel.Name AS Hotel
FROM Booking
JOIN Hotel ON Booking.Hotel_No = Hotel.Hotel_No
WHERE Date_From BETWEEN '2011-03-01' AND '2011-03-31'
GROUP BY Hotel.Name;