
CREATE TABLE Airline_info (
    airline_id INT PRIMARY KEY NOT NULL,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    info VARCHAR(50) NOT NULL
);

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY NOT NULL,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY NOT NULL,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY NOT NULL,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL
);

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY NOT NULL,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY NOT NULL,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY NOT NULL,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    price DECIMAL(7,2) NOT NULL
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY NOT NULL,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL,
    arriving_airport_id INT NOT NULL,
    departing_gate VARCHAR(50) NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    act_departure_time TIMESTAMP NOT NULL,
    act_arrival_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY NOT NULL,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL
);


ALTER TABLE airline_info RENAME TO airline;

ALTER TABLE booking RENAME COLUMN price TO ticket_price;

ALTER TABLE flights ALTER COLUMN departing_gate TYPE TEXT;

ALTER TABLE airline DROP COLUMN info;

ALTER TABLE Security_check ADD CONSTRAINT fk_passenger_security
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);

ALTER TABLE Booking ADD CONSTRAINT fk_passenger_booking
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);

ALTER TABLE Baggage_check ADD CONSTRAINT fk_passenger_baggage_check
FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id);

ALTER TABLE Baggage_check ADD CONSTRAINT fk_booking_baggage_check
FOREIGN KEY (booking_id) REFERENCES Booking (booking_id);

ALTER TABLE Baggage ADD CONSTRAINT fk_booking_baggage
FOREIGN KEY (booking_id) REFERENCES Booking (booking_id);

ALTER TABLE Boarding_pass ADD CONSTRAINT fk_booking_boarding_pass
FOREIGN KEY (booking_id) REFERENCES Booking (booking_id);

ALTER TABLE Booking_flight ADD CONSTRAINT fk_booking_booking_flight
FOREIGN KEY (booking_id) REFERENCES Booking (booking_id);

ALTER TABLE Booking_flight ADD CONSTRAINT fk_flight_booking_flight
FOREIGN KEY (flight_id) REFERENCES Flights (flight_id);

ALTER TABLE Flights ADD CONSTRAINT fk_departing_airport
FOREIGN KEY (departing_airport_id) REFERENCES Airport (airport_id);

ALTER TABLE Flights ADD CONSTRAINT fk_arriving_airport
FOREIGN KEY (arriving_airport_id) REFERENCES Airport (airport_id);

ALTER TABLE Flights ADD CONSTRAINT fk_airline_flights
FOREIGN KEY (airline_id) REFERENCES Airline (airline_id);


-- DML: Манипуляции с данными

-- 1. Генерация и вставка 200 случайных строк в таблицу Airport
INSERT INTO Airport (airport_id, airport_name, country, state, city, created_at, updated_at)
SELECT
    i,
    'Airport ' || substr(md5(random()::text), 1, 8),
    'Country ' || substr(md5(random()::text), 1, 6),
    'State ' || substr(md5(random()::text), 1, 5),
    'City ' || substr(md5(random()::text), 1, 7),
    NOW() - (random() * interval '365 days'),
    NOW() - (random() * interval '30 days')
FROM generate_series(1, 200) AS i;

-- 2. Добавление новой авиакомпании "KazAir"
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES (201, 'KZR', 'KazAir', 'Kazakhstan', NOW(), NOW());

-- 3. Обновление страны авиакомпании "KazAir" на "Turkey"
UPDATE airline
SET airline_country = 'Turkey', updated_at = NOW()
WHERE airline_name = 'KazAir';

-- 4. Добавление трёх авиакомпаний одним запросом
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(202, 'EZY', 'AirEasy', 'France', NOW(), NOW()),
(203, 'FHI', 'FlyHigh', 'Brazil', NOW(), NOW()),
(204, 'FFL', 'FlyFly', 'Poland', NOW(), NOW());

-- 5. Удаление всех рейсов с прибытием в 2024 году
DELETE FROM flights
WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024;

-- 6. Увеличение цены всех билетов на 15%
UPDATE booking
SET ticket_price = ticket_price * 1.15;

-- 7. Удаление всех билетов, цена которых меньше 10000
DELETE FROM booking
WHERE ticket_price < 10000;


-- TASKS: Задачи (запросы на выборку)

-- 1. Выбрать все данные пассажиров, у которых имя совпадает с фамилией
SELECT *
FROM passengers
WHERE first_name = last_name;

-- 2. Выбрать фамилии всех пассажиров без дубликатов
SELECT DISTINCT last_name
FROM passengers;

-- 3. Найти всех пассажиров мужского пола, рожденных между 1990 и 2000 годами
SELECT *
FROM passengers
WHERE gender = 'Male' AND EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000;

-- 4. Найти стоимость проданных билетов за каждый месяц в отсортированном виде
SELECT
    DATE_TRUNC('month', created_at)::DATE AS sales_month,
    SUM(ticket_price) AS total_revenue
FROM booking
GROUP BY sales_month
ORDER BY sales_month;

-- 5. Создать запрос, который показывает все рейсы, летящие в 'China'
SELECT f.*
FROM flights f
JOIN airport a ON f.arriving_airport_id = a.airport_id
WHERE a.country = 'China';

-- 6. Показать авиакомпании из ('France','Portugal','Poland'), созданные между '2023-11-01' и '2024-03-31'
SELECT *
FROM airline
WHERE airline_country IN ('France', 'Portugal', 'Poland')
AND created_at BETWEEN '2023-11-01' AND '2024-03-31';

-- 7. Найти названия всех авиакомпаний, базирующихся в Казахстане
SELECT airline_name
FROM airline
WHERE airline_country = 'Kazakhstan';

-- 8. Уменьшить стоимость бронирований на 10%, созданных до '11-01-2023'
UPDATE booking
SET ticket_price = ticket_price * 0.90
WHERE created_at < '2023-11-01';

-- 9. Найти топ-3 единицы багажа с перевесом более 25 кг
SELECT *
FROM baggage
WHERE weight_in_kg > 25
ORDER BY weight_in_kg DESC
LIMIT 3;

-- 10. Найти полное имя самого молодого пассажира
SELECT first_name, last_name
FROM passengers
ORDER BY date_of_birth DESC
LIMIT 1;

-- 11. Найти самую дешевую стоимость бронирования на каждой платформе
SELECT booking_platform, MIN(ticket_price) AS cheapest_price
FROM booking
GROUP BY booking_platform;

-- 12. Вернуть авиакомпании, в коде которых (airline_code) есть цифра
SELECT *
FROM airline
WHERE airline_code ~ '\d';

-- 13. Вывести топ-5 самых недавно созданных авиакомпаний
SELECT *
FROM airline
ORDER BY created_at DESC
LIMIT 5;

-- 14. Вернуть все строки, где booking_id между 200 и 300 включительно и check_result <> 'Checked'
SELECT *
FROM baggage_check
WHERE booking_id BETWEEN 200 AND 300
AND check_result <> 'Checked';

-- 15. Проверки багажа, где updated_at находится в том же месяце, что и created_at, но произошло раньше
SELECT *
FROM baggage_check
WHERE DATE_TRUNC('month', updated_at) = DATE_TRUNC('month', created_at)
AND updated_at < created_at;