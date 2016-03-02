/*Simple queries*/
-- 1 . List alle oplysninger om alle hoteller.
SELECT * FROM Hotel;

-- 2. List alle oplysninger om alle hoteller i Roskilde.
SELECT * FROM Hotel WHERE Address LIKE '%Roskilde%';

-- 3. List navne og adresser på alle gæster fra Roskilde.
SELECT Name,Address FROM Guest WHERE Address LIKE '%Roskilde%';

-- 4. List navne og adresser på alle gæster fra Roskilde sorteret alfabetisk efter navn.
SELECT Name,Address FROM Guest WHERE Address LIKE '%Roskilde%' ORDER BY Name ASC;

-- 5. List alle dobbeltværelser med en pris under 200 pr. nat.
SELECT Types,Price FROM Room WHERE Price BETWEEN 0 AND 200;

-- 6. List alle dobbeltværelser eller familierum med en pris under 400 pr. nat.
SELECT Types,Price FROM Room WHERE Types = 'F' OR Types = 'D' AND Price BETWEEN 0 AND 400;

-- 7. List alle dobbeltværelser eller familierum med en pris under 400 pr. nat sorteret i stigende orden efter pris.
SELECT  Types,Price FROM Room WHERE Types = 'F' OR Types = 'D' AND Price BETWEEN 0 AND 400 ORDER BY Price ASC;

-- 8. List alle gæster, som har et navn, der starter med 'G'.
SELECT Name FROM Guest WHERE Name LIKE 'G%';

/*Aggregate-funktioner*/
-- 9. Hvor mange hoteller er der?
SELECT COUNT(*) FROM Hotel;

-- 10. Hvor mange hoteller er der i Roskilde?
SELECT COUNT(*) FROM Hotel WHERE Address LIKE '%Roskilde%';

-- 11. Hvad er gennemsnitsprisen på et værelse?
SELECT AVG(Price) FROM Room;

-- 12. Hvad er gennemsnitsprisen på et enkeltværelse?
SELECT AVG(Price) FROM Room WHERE Types = 'S';

-- 13. Hvad er gennemsnitsprisen på et dobbeltværelse?
SELECT AVG(Price) FROM Room WHERE Types = 'D';

-- 14. Hvad er gennemsnitsprisen på et værelse på Hotel Scandic?
SELECT AVG(Price) FROM Room WHERE Hotel_No = 7;

-- 15. Hvad er den totale indtægt pr. nat for alle dobbeltværelser?
SELECT SUM(Price) FROM Room WHERE Types = 'D';

-- 16. Hvor mange forskellige gæster har foretaget bookinger i marts måned?
SELECT * FROM Booking WHERE (Date_From BETWEEN '2011-03-01' AND '2011-03-31') AND (Date_To BETWEEN '2011-03-01' AND '2011-03-31');

-- 17. Hvor mange bookinger er der i dag på Scandic hotel?
-- 2 Løsninger alt efter hvordan spørgsmålet tolkes
SELECT COUNT(*) FROM Booking WHERE Date_From = GETDATE() AND Hotel_No = 7;
SELECT COUNT(*) FROM Booking WHERE (GETDATE() BETWEEN Date_From AND Date_To) AND Hotel_No = 7;

-- 18. Hvor mange bookinger er der i morgen på Scandic hotel?
SELECT * FROM Booking WHERE (DATEADD(day,1,GETDATE()) BETWEEN Date_From AND Date_To) AND Hotel_No = 7;

/*Subqueries & joins*/
-- 19. List pris og type på alle værelser på 'Prindsen'.
SELECT Price,Hotel.Hotel_No,Name,Address FROM Room JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No WHERE Hotel.Name = 'Prindsen';

-- 20. List alle gæster, der p.t. bor på 'Prindsen'.
SELECT Guest.Name,Guest.Address,Hotel.Name FROM Booking JOIN Guest ON Booking.Guest_No = Guest.Guest_No JOIN Hotel ON Booking.Hotel_No = Hotel.Hotel_No WHERE Hotel.Name = 'Prindsen';