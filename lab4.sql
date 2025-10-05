-- 1. Retrieve all airline names in uppercase.
SELECT UPPER(airline_name)
FROM airline;

-- 2. Replace any occurrence of the word "Air" in airline names with "Aero".
SELECT airline_name, REPLACE(airline_name, 'Air', 'Aero') AS modified_name
FROM airline;

-- 3. Find all flight numbers that coordinate with both airline 1 and airline 2.
SELECT flight_id FROM flights WHERE airline_id = 1
INTERSECT
SELECT flight_id FROM flights WHERE airline_id = 2;

-- 4. Retrieve airports that contain the word "Regional" and "Air" in their names.
SELECT airport_name
FROM airport
WHERE airport_name ILIKE '%Regional%' AND airport_name ILIKE '%Air%';

-- 5. Retrieve passenger names and format their birth dates as 'Month DD, YYYY'.
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    TO_CHAR(date_of_birth, 'FMMonth DD, YYYY') AS formatted_birth_date
FROM passengers;

-- 6. Find flight numbers that have been delayed based on the actual arrival time.
SELECT flight_id
FROM flights
WHERE act_arrival_time > sch_arrival_time;

-- 7. Create a query that divides passengers into age groups.
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    EXTRACT(YEAR FROM AGE(date_of_birth)) AS age,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 18 AND 35 THEN 'Young'
        WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 36 AND 55 THEN 'Adult'
        ELSE 'Other'
    END AS age_group
FROM passengers;

-- 8. Create a query that categorizes ticket prices.
SELECT
    booking_id,
    ticket_price,
    CASE
        WHEN ticket_price < 300 THEN 'Cheap'
        WHEN ticket_price BETWEEN 300 AND 800 THEN 'Medium'
        ELSE 'Expensive'
    END AS price_category
FROM booking;

-- 9. Find number of airline names in each airline country.
SELECT
    airline_country,
    COUNT(airline_id) AS number_of_airlines
FROM airline
GROUP BY airline_country;

-- 10. Find flights that arrived late.
SELECT *
FROM flights
WHERE act_arrival_time > sch_arrival_time;