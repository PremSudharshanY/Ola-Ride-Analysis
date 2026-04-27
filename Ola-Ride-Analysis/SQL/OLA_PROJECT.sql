
-- OLA PROJECT DATABASE SETUP & ANALYSIS

-- Create & Use Database
CREATE DATABASE ola_project;
USE ola_project;

-- ============================================
-- TABLE CREATION
-- ============================================

CREATE TABLE bookings (
    Date                        DATE,
    Time                        TIME,
    Booking_ID                  VARCHAR(20),
    Booking_Status              VARCHAR(50),
    Customer_ID                 VARCHAR(15),
    Vehicle_Type                VARCHAR(30),
    Pickup_Location             VARCHAR(100),
    Drop_Location               VARCHAR(100),
    V_TAT                       FLOAT,
    C_TAT                       FLOAT,
    Canceled_Rides_by_Customer  VARCHAR(100),
    Canceled_Rides_by_Driver    VARCHAR(100),
    Incomplete_Rides            VARCHAR(10),
    Incomplete_Rides_Reason     VARCHAR(100),
    Booking_Value               INT,
    Payment_Method              VARCHAR(20),
    Ride_Distance               FLOAT,
    Driver_Ratings              FLOAT,
    Customer_Rating             FLOAT,
    Vehicle_Images              VARCHAR(255)
);

-- ============================================
-- DATA LOADING
-- ============================================

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bookings.csv'
INTO TABLE bookings
CHARACTER SET utf8
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Date, Time, Booking_ID, Booking_Status, Customer_ID, Vehicle_Type,
    Pickup_Location, Drop_Location, V_TAT, C_TAT,
    Canceled_Rides_by_Customer, Canceled_Rides_by_Driver,
    Incomplete_Rides, Incomplete_Rides_Reason,
    Booking_Value, Payment_Method, Ride_Distance,
    Driver_Ratings, Customer_Rating, Vehicle_Images
);

-- Verify Data Load
SELECT COUNT(*) AS total_records FROM bookings;

-- ============================================
-- VIEWS FOR ANALYSIS
-- ============================================

-- 1. Successful Bookings
CREATE VIEW Successful_Bookings AS
SELECT * FROM bookings
WHERE Booking_Status = 'Success';

-- 2. Average Ride Distance per Vehicle Type
CREATE VIEW Ride_Distance_By_Vehicle AS
SELECT Vehicle_Type, AVG(Ride_Distance) AS avg_distance
FROM bookings
GROUP BY Vehicle_Type;

-- 3. Total Cancelled Rides by Customers
CREATE VIEW Cancelled_Rides_By_Customers AS
SELECT COUNT(*) AS total_cancel
FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

-- 4. Top 5 Customers by Number of Rides
CREATE VIEW Top_5_Customers AS
SELECT Customer_ID, COUNT(*) AS total_bookings
FROM bookings
GROUP BY Customer_ID
ORDER BY total_bookings DESC
LIMIT 5;

-- 5. Driver Cancellations (Personal & Car Issues)
CREATE VIEW Driver_Cancellations_Personal_Car AS
SELECT COUNT(*) AS total_driver_cancellations
FROM bookings
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';

-- 6. Max & Min Driver Ratings (Prime Sedan)
CREATE VIEW Max_Min_Driver_Rating AS
SELECT 
    MAX(Driver_Ratings) AS max_rating,
    MIN(Driver_Ratings) AS min_rating
FROM bookings
WHERE Vehicle_Type = 'Prime Sedan';

-- 7. UPI Payments
CREATE VIEW UPI_Payments AS
SELECT * FROM bookings
WHERE Payment_Method = 'UPI';

-- 8. Average Customer Rating per Vehicle Type
CREATE VIEW Avg_Customer_Rating AS
SELECT Vehicle_Type, AVG(Customer_Rating) AS avg_customer_rating
FROM bookings
GROUP BY Vehicle_Type;

-- 9. Total Value of Successful Rides
CREATE VIEW Total_Successful_Ride_Value AS
SELECT SUM(Booking_Value) AS total_value
FROM bookings
WHERE Booking_Status = 'Success';

-- 10. Incomplete Rides with Reason
CREATE VIEW Incomplete_Rides_Analysis AS
SELECT Booking_ID, Incomplete_Rides_Reason
FROM bookings
WHERE Incomplete_Rides = 'Yes';

-- ============================================
-- SAMPLE QUERIES (OPTIONAL CHECKS)
-- ============================================

SELECT * FROM Successful_Bookings;
SELECT * FROM Ride_Distance_By_Vehicle;
SELECT * FROM Cancelled_Rides_By_Customers;
SELECT * FROM Top_5_Customers;
SELECT * FROM Driver_Cancellations_Personal_Car;
SELECT * FROM Max_Min_Driver_Rating;
SELECT * FROM UPI_Payments;
SELECT * FROM Avg_Customer_Rating;
SELECT * FROM Total_Successful_Ride_Value;
SELECT * FROM Incomplete_Rides_Analysis;

-- ============================================
-- END OF PROJECT
-- ============================================