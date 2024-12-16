-- 1
SELECT flight_id, flight_no, departure_airport, scheduled_departure
FROM flights

--2
SELECT DISTINCT departure_airport, arrival_airport
FROM flights

--3 
SELECT flight_no, departure_airport
FROM flights
WHERE departure_airport = 'VKO'

--4 использовать как AND так и OR в одном условии.
SELECT flight_id, flight_no
FROM flights
WHERE departure_airport = 'VKO' AND (arrival_airport = 'SVO' OR arrival_airport = 'DME');


--5
SELECT  departure_airport, flight_no
FROM flights
WHERE arrival_airport IN ('SVO', 'DME', 'VKO')

--6
SELECT seat_no, aircraft_code, fare_conditions
FROM seats
WHERE seat_no
BETWEEN '5' AND '10'; 

--7
SELECT aircraft_code, model
FROM aircrafts
WHERE model
LIKE 'Boe%';

--8 Использовать одновременно ASC и DESC для разных столбцов
SELECT boarding_no, ticket_no, seat_no
FROM boarding_passes
WHERE boarding_no BETWEEN '10' AND '20'
ORDER BY ticket_no ASC, seat_no DESC;


--9
SELECT EXTRACT(DOW FROM book_date) AS day_of_week, 
       SUM(total_amount) AS total_sales
FROM bookings
WHERE book_date >= '2016-01-01' AND book_date < '2017-01-01'
GROUP BY day_of_week
ORDER BY day_of_week;



--10
SELECT EXTRACT(DOW FROM book_date) AS day_of_week, 
       COUNT(*) AS booking_count
FROM bookings
WHERE book_date >= '2016-01-01' AND book_date < '2017-01-01'
GROUP BY day_of_week
ORDER BY day_of_week;


--11
SELECT EXTRACT(DOW FROM book_date) AS day_of_week, 
       COUNT(*) AS booking_count
FROM bookings
WHERE book_date >= '2016-01-01' AND book_date < '2017-01-01'
GROUP BY day_of_week
HAVING SUM(total_amount) > 100000
ORDER BY day_of_week;

-----

-- создание таблицы, не менее 4х колонок разного типа,1 колонка первичный ключ, одна необнуляймая
CREATE TABLE mytable (
  col1 SERIAL,
  col2 INT,
  col3 VARCHAR(5),
  col4 TEXT,
  PRIMARY KEY (col1)
);


-- удаление таблицы
DROP TABLE mytable;

-- создание индекса
CREATE UNIQUE INDEX mytable_ind
ON myTable (col1);

-- удаление индекса
ALTER TABLE mytable
DROP INDEX mytable_ind;

-- получение описания структуры таблицы
\d mytable

-- очистка таблицы
TRUNCATE TABLE mytable;

-- выбрать одно из вариантов: добавление/удаление/модификация колонок
ALTER TABLE mytable ADD col5 DATE;

-- переименование таблицы
ALTER TABLE mytable RENAME TO yourtable;

-- вставка значений
INSERT INTO mytable (col2, col3, col4, col5)
VALUES (30, 'test', 'this is my table', '2024-12-16 11:11:11');

-- обновление записей
UPDATE mytable 
SET col2 = 768, col3 = 'test2', col4 = 'test3', col5 = '2025-01-01 00:00:00'
WHERE col2 = 30;

-- удаление записей
DELETE FROM mytable 
WHERE col2 = 768;