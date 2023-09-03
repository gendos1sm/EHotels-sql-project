CREATE TABLE IF NOT EXISTS hotelchain(
Chain_Name VARCHAR(40) PRIMARY KEY,
City_Central VARCHAR(30) NOT NULL,
State_Central CHAR(2) NOT NULL,
Num_Hotels INT NOT NULL,
email varchar(50) NOT NULL,
Phone_Number NUMERIC(10) NOT NULL);

CREATE TABLE IF NOT EXISTS hotel(
Hotel_ID VARCHAR(5) PRIMARY KEY,
Hotel_Name VARCHAR(30) NOT NULL,
Stars INT NOT NULL,
Num_Rooms INT NOT NULL,
City VARCHAR(30) NOT NULL,
State CHAR(2) NOT NULL,
email varchar(50) NOT NULL,
Phone_Number NUMERIC(10) NOT NULL,
Chain_Name VARCHAR(40) NOT NULL,
FOREIGN KEY (Chain_Name) REFERENCES hotelchain(Chain_Name)); 

CREATE TABLE IF NOT EXISTS employee(
Employee_ID VARCHAR(5) PRIMARY KEY,
SIN NUMERIC(9) NOT NULL,
Employee_Name VARCHAR(40) NOT NULL,
Address VARCHAR(60) NOT NULL,
Position VARCHAR(40) NOT NULL,
Manages_Hotel BOOLEAN,
Hotel_ID VARCHAR(5) NOT NULL,
FOREIGN KEY (Hotel_ID) REFERENCES hotel(Hotel_ID));

CREATE TABLE IF NOT EXISTS Room(
Room_ID VARCHAR(5) PRIMARY KEY,
Price INT NOT NULL,
Amenity VARCHAR(200),
Capacity INT NOT NULL,
Room_View VARCHAR(20),
Extra_Bed BOOLEAN,
Damage VARCHAR(100),
Hotel_ID VARCHAR(5) NOT NULL,
FOREIGN KEY (Hotel_ID)
REFERENCES hotel(Hotel_ID));

CREATE TABLE booking(
Booking_ID VARCHAR(5) PRIMARY KEY,
Check_In VARCHAR(10) NOT NULL,
Check_Out VARCHAR(10) NOT NULL,
Amount INT NOT NULL);

CREATE TABLE renting(
Renting_ID VARCHAR(5) PRIMARY KEY,
Check_In VARCHAR(10) NOT NULL,
Check_Out VARCHAR(10) NOT NULL,
Amount INT NOT NULL);

CREATE TABLE archive(
Record_ID VARCHAR(5) PRIMARY KEY,
Check_In VARCHAR(10) NOT NULL,
Check_Out VARCHAR(10) NOT NULL,
Amount INT NOT NULL);

CREATE TABLE customer(
Customer_ID INT PRIMARY KEY,
Full_Name VARCHAR(100) NOT NULL,
Address VARCHAR(200) NOT NULL,
SIN NUMERIC(9) NOT NULL);

------------------------------
SELECT * FROM hotelchain;
SELECT * FROM hotel;
SELECT * FROM room;
SELECT * FROM employee;
SELECT * FROM customer;
SELECT * FROM booking;

-------------------------------------------------
-- SQL trigger that logs the insertions, updates, and deletions to the employee table:
CREATE TRIGGER employee_trigger
AFTER INSERT, UPDATE, DELETE
ON employee
FOR EACH ROW
BEGIN
    IF (INSERTING) THEN
        INSERT INTO employee_log(action, employee_id, SIN, employee_name, address, position, manages_hotel, hotel_id)
        VALUES ('INSERT', NEW.Employee_ID, NEW.SIN, NEW.Employee_Name, NEW.Address, NEW.Position, NEW.Manages_Hotel, NEW.Hotel_ID);
    ELSEIF (UPDATING) THEN
        INSERT INTO employee_log(action, employee_id, SIN, employee_name, address, position, manages_hotel, hotel_id)
        VALUES ('UPDATE', NEW.Employee_ID, NEW.SIN, NEW.Employee_Name, NEW.Address, NEW.Position, NEW.Manages_Hotel, NEW.Hotel_ID);
    ELSEIF (DELETING) THEN
        INSERT INTO employee_log(action, employee_id, SIN, employee_name, address, position, manages_hotel, hotel_id)
        VALUES ('DELETE', OLD.Employee_ID, OLD.SIN, OLD.Employee_Name, OLD.Address, OLD.Position, OLD.Manages_Hotel, OLD.Hotel_ID);
    END IF;
END;
-- This trigger logs each insertion, update, and deletion to a separate employee_log table, which should have the same columns as the employee table, plus an additional action column to indicate the type of change. 
-- The trigger checks whether the operation is an insertion, update, or deletion using the INSERTING, UPDATING, and DELETING keywords, respectively. It then inserts a row into the employee_log table with the appropriate values.

-- SQL statement to create an index on the Hotel_ID column of the employee table:
CREATE INDEX employee_hotel_idx ON employee (Hotel_ID);
-- This statement creates index named employee_hotel_idx on the Hotel_ID column of the employee table. Indexes can improve the performance of queries that filter, join, or sort data based on the indexed column(s).

-- SQL trigger that logs the insertions, updates, and deletions to the customer table:
CREATE TRIGGER customer_update_trigger
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
    INSERT INTO customer_log (Customer_ID, Action_Performed)
    VALUES (OLD.Customer_ID, CONCAT('Customer updated: Full Name=', OLD.Full_Name, ', Address=', OLD.Address, ', SIN=', OLD.SIN));
END;
-- This trigger fires after an update is made to the customer table and inserts a new row into a separate customer_log table. The OLD keyword is used to refer to the old values of the row that was updated. 
-- The trigger logs the customer ID and the action performed (in this case, an update with the customer's previous full name, address, and SIN). 

-- SQL statement to create an index on the Full_Name column of the customer table:
CREATE INDEX idx_customer_name ON customer (Full_Name);
-- This statement creates an index called idx_customer_name on the Full_Name column of the customer table. Indexes are used to speed up queries by allowing the database to find the relevant rows more quickly. 
-- In this case, the index will speed up queries that involve searching for customers by their full name.

-- Trigger for the booking table that calculates the total amount for each booking and updates the Amount column whenever a row is inserted or updated:
CREATE TRIGGER update_booking_amount
AFTER INSERT, UPDATE ON booking
FOR EACH ROW
BEGIN
    DECLARE total_amount INT;
    SET total_amount = DATEDIFF(NEW.Check_Out, NEW.Check_In) * 100;
    SET NEW.Amount = total_amount;
END;
-- This trigger uses the DATEDIFF function to calculate the number of nights between the check-in and check-out dates of a booking and multiplies it by 100 to get the total amount. It then sets the Amount column of the inserted or updated row to this calculated value.
-- Trigger assumes that the Check_In and Check_Out columns are stored as VARCHAR values in the format "yyyy-mm-dd". If they are stored as DATE values instead, you can use the DATEDIFF function directly on the columns without converting them.

-- Index on the booking table in SQL on Booking_ID column:
CREATE INDEX booking_id_index ON booking (Booking_ID);
-- This statement creates an index called booking_id_index on the Booking_ID column of the booking table.

-- Trigger to update the number of rooms in the hotel table after an insert or delete in the Room table
CREATE TRIGGER update_num_rooms
AFTER INSERT ON Room
FOR EACH ROW
BEGIN
    UPDATE hotel
    SET Num_Rooms = Num_Rooms + 1
    WHERE Hotel_ID = NEW.Hotel_ID;
END;

CREATE TRIGGER decrease_num_rooms
AFTER DELETE ON Room
FOR EACH ROW
BEGIN
    UPDATE hotel
    SET Num_Rooms = Num_Rooms - 1
    WHERE Hotel_ID = OLD.Hotel_ID;
END;

-- Trigger to prevent the deletion of a hotel that has rooms associated with it
CREATE TRIGGER prevent_hotel_deletion
BEFORE DELETE ON hotel
FOR EACH ROW
BEGIN
    DECLARE num_rooms INT;
    SELECT COUNT(*) INTO num_rooms
    FROM Room
    WHERE Hotel_ID = OLD.Hotel_ID;

    IF num_rooms > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete hotel with associated rooms.';
    END IF;
END;

-- Index on the Stars column of the hotel table. This index will allow for faster queries that involve selecting hotels based on their star rating.
CREATE INDEX idx_hotel_stars ON hotel (Stars);

-- Index on the Price column of the Room table. This index will allow for faster queries that involve selecting rooms based on their price.
CREATE INDEX idx_room_price ON Room (Price);

-- Index on the "City" column of the "hotel" table. This index would be useful if your application frequently queries hotels by city. It would speed up queries that include a "WHERE" clause that filters on the "City" column.
CREATE INDEX idx_hotel_city ON hotel (City);

-- View 1: Number of available rooms per area
CREATE VIEW available_rooms_per_area AS
SELECT City, State, SUM(Num_Rooms) AS Total_Rooms, COUNT(Room_ID) AS Available_Rooms
FROM hotel LEFT JOIN Room ON hotel.Hotel_ID = Room.Hotel_ID
GROUP BY City, State;

-- View 2: Capacity of all rooms of a specific hotel
CREATE VIEW room_capacity_by_hotel AS
SELECT Hotel_Name, SUM(Capacity) AS Total_Capacity
FROM hotel INNER JOIN Room ON hotel.Hotel_ID = Room.Hotel_ID
GROUP BY Hotel_Name;

-----------------------------------------------------------------------------------------------------------------
INSERT INTO hotelchain
VALUES
('Best Western Hotels', 'Phoenix', 'AZ', 8, 'bestwestern_central@bestwestern.com', 6023339977),
('Choice Hotels International', 'Rockville', 'MD', 8, 'choicehotels_central@choicehotels.com', 2407779988),
('Hilton Worldwide', 'Tysons Corner', 'VA', 8, 'hilton_central@hilton.com', 7037779211),
('Marriott International', 'Bethesda', 'MD', 8, 'marriott_central@marriott.com', 2401119211),
('Wyndham Hotels and Resorts', 'Parsippany-Troy Hills', 'NJ', 8, 'wyndham_central@wyndham.com', 9738882134);

INSERT INTO hotel
VALUES
('B0001', 'BW Toronto', 3, 5, 'Toronto', 'ON', 'bestwestern_premier_toronto@bestwestern.com', 4166377000, 'Best Western Hotels'),
('B0002', 'BW Toronto Second', 2, 5, 'Toronto', 'ON', 'bestwestern_toronto@bestwestern.com', 4164300444, 'Best Western Hotels'),
('B0003', 'BW New York', 3, 5, 'New York', 'NY', 'bestwestern_premier_newyork@bestwestern.com', 2127761024, 'Best Western Hotels'),
('B0004', 'BW Vancouver', 4, 5, 'Vancouver', 'BC', 'bestwestern_vancouver@bestwestern.com', 6046697070, 'Best Western Hotels'),
('B0005', 'BW Gatineau', 3, 5, 'Gatineau', 'QC', 'bestwestern_gatineau@bestwestern.com', 8197708550, 'Best Western Hotels'),
('B0006', 'BW Chicago', 2, 5, 'Chicago', 'IL', 'bestwestern_chicago@bestwestern.com', 3129222900, 'Best Western Hotels'),
('B0007', 'BW Seattle', 3, 5, 'Seattle', 'WA', 'bestwestern_seattle@bestwestern.com', 2063401234, 'Best Western Hotels'),
('B0008', 'BW Calgary', 3, 5, 'Calgary', 'AB', 'bestwestern_calgary@bestwestern.com', 4032488888, 'Best Western Hotels'),
('C0001', 'CH Anaheim', 3, 5, 'Anaheim', 'CA', 'choicehotels_anaheim@choicehotels.com', 7147503131, 'Choice Hotels International'),
('C0002', 'CH Sudbury', 3, 5, 'Greater Sudbury', 'ON', 'choicehotels_sudbury@choicehotels.com', 7056747517, 'Choice Hotels International'),
('C0003', 'CH Richmond', 2, 5, 'Richmond', 'BC', 'choicehotels_richmond@choicehotels.com', 6042443051, 'Choice Hotels International'),
('C0004', 'CH Richmond Second', 3, 5, 'Richmond', 'BC', 'choicehotels_quality_richmond@choicehotels.com', 7789072918, 'Choice Hotels International'),
('C0005', 'CH Irving', 2, 5, 'Irving', 'TX', 'choicehotels_irving@choicehotels.com', 9725739320, 'Choice Hotels International'),
('C0006', 'CH Springs', 4, 5, 'Miami Springs', 'FL', 'choicehotels_miami@choicehotels.com', 3059214268, 'Choice Hotels International'),
('C0007', 'CH Carleton', 2, 5, 'Carleton Place', 'ON', 'choicehotels_carleton@choicehotels.com', 6132160079, 'Choice Hotels International'),
('C0008', 'CH Anjou', 2, 5, 'Anjou', 'QC', 'choicehotels_anjou@choicehotels.com', 5144936363, 'Choice Hotels International'),
('H0001', 'HW Vancouver', 5, 5, 'Vancouver', 'BC', 'hilton_vancouver@hilton.com', 6046021999, 'Hilton Worldwide'),
('H0002', 'HW New York', 4, 5, 'New York', 'NY', 'hilton_midtown@hilton.com', 2125867000, 'Hilton Worldwide'),
('H0003', 'HW New York Second', 3, 5, 'New York', 'NY', 'hilton_tsquare@hilton.com', 2125817000, 'Hilton Worldwide'),
('H0004', 'HW San Francisco', 4, 5, 'San Francisco', 'CA', 'hilton_sanfran@hilton.com', 4157711400, 'Hilton Worldwide'),
('H0005', 'HW Calgary', 3, 5, 'Calgary', 'AB', 'hilton_calgary@hilton.com', 5873522020, 'Hilton Worldwide'),
('H0006', 'HW Winnipeg', 4, 5, 'Winnipeg', 'MB', 'hilton_winnipeg@hilton.com', 2047831700, 'Hilton Worldwide'),
('H0007', 'HW Toronto', 4, 5, 'Toronto', 'ON', 'hilton_toronto@hilton.com', 4168693456, 'Hilton Worldwide'),
('H0008', 'HW Quebec', 4, 5, 'Québec', 'QC', 'hilton_quebec@hilton.com', 4186472411, 'Hilton Worldwide'),
('M0001', 'MI Vancouver', 5, 5, 'Vancouver', 'BC', 'marriott_parq@marriott.com', 6046760888, 'Marriott International'),
('M0002', 'MI Vancouver Second', 4, 5, 'Vancouver', 'BC', 'marriott_vancouver@marriott.com', 6046841128, 'Marriott International'),
('M0003', 'MI Ottawa', 4, 5, 'Ottawa', 'ON', 'marriott_ottawa@marriott.com', 6132381122, 'Marriott International'),
('M0004', 'MI Nashville', 3, 5, 'Nashville', 'TN', 'marriott_nashville@marriott.com', 6152560900, 'Marriott International'),
('M0005', 'MI Washington', 4, 5, 'Washington', 'DC', 'marriott_washington@marriott.com', 2023932000, 'Marriott International'),
('M0006', 'MI San Diego', 3, 5, 'San Diego', 'CA', 'marriott_sdiego@marriott.com', 6194463000, 'Marriott International'),
('M0007', 'MI Halifax', 4, 5, 'Halifax', 'NS', 'marriott_halifax@marriott.com', 9024211700, 'Marriott International'),
('M0008', 'MI Portland', 5, 5, 'Portland', 'OR', 'marriott_portland@marriott.com', 5032267600, 'Marriott International'),
('W0001', 'WH Ottawa', 3, 5, 'Ottawa', 'ON', 'wyndham_rideau@wyndham.com', 6132883500, 'Wyndham Hotels and Resorts'),
('W0002', 'WH Ottawa Second', 2, 5, 'Ottawa', 'ON', 'wyndham_ottawa@wyndham.com', 6137397555, 'Wyndham Hotels and Resorts'),
('W0003', 'WH Toronto', 4, 5, 'Toronto', 'ON', 'wyndham_toronto@wyndham.com', 4169774823, 'Wyndham Hotels and Resorts'),
('W0004', 'WH Calgary', 4, 5, 'Calgary', 'AB', 'wyndham_calgary@wyndham.com', 4035162266, 'Wyndham Hotels and Resorts'),
('W0005', 'WH St. Louis', 2, 5, 'St. Louis', 'MO', 'wyndham_louis@wyndham.com', 3144928824, 'Wyndham Hotels and Resorts'),
('W0006', 'WH Orlando', 3, 5, 'Orlando', 'FL', 'wyndham_orlando@wyndham.com', 4073512420, 'Wyndham Hotels and Resorts'),
('W0007', 'WH Houston', 3, 5, 'Houston', 'TX', 'wyndham_houston@wyndham.com', 7137483221, 'Wyndham Hotels and Resorts'),
('W0008', 'WH Pittsburgh', 3, 5, 'Pittsburgh', 'PA', 'wyndham_pittsburgh@wyndham.com', 4123914600, 'Wyndham Hotels and Resorts');

INSERT INTO room
VALUES
('BWP01', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0001'),
('BWP02', 105, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0001'),
('BWP03', 150, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0001'),
('BWP04', 180, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0001'),
('BWP05', 115, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0001'),
('BWT06', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker', 2, 'City view', True, 'No damages', 'B0002'),
('BWT07', 105, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker', 2, 'No view', True, 'No damages', 'B0002'),
('BWT08', 150, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker', 4, 'City view', False, 'Cracked window', 'B0002'),
('BWT09', 180, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker', 4, 'River view', False, 'No damages', 'B0002'),
('BWT10', 115, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker', 2, 'City view', True, 'No damages', 'B0002'),
('BWY11', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0003'),
('BWY12', 105, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0003'),
('BWY13', 150, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0003'),
('BWY14', 180, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0003'),
('BWY15', 115, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0003'),
('BWV16', 135, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0004'),
('BWV17', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0004'),
('BWV18', 190, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0004'),
('BWV19', 220, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0004'),
('BWV20', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0004'),
('BWG21', 135, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0005'),
('BWG22', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0005'),
('BWG23', 190, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0005'),
('BWG24', 220, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0005'),
('BWG25', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0005'),
('BWC26', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0006'),
('BWC27', 105, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0006'),
('BWC28', 150, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0006'),
('BWC29', 180, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0006'),
('BWC30', 115, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0006'),
('BWS31', 135, 'Wi-Fi, mini-refrigerator, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0007'),
('BWS32', 125, 'Wi-Fi, mini-refrigerator, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0007'),
('BWS33', 190, 'Wi-Fi, mini-refrigerator, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0007'),
('BWS34', 220, 'Wi-Fi, mini-refrigerator, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0007'),
('BWS35', 125, 'Wi-Fi, mini-refrigerator, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0007'),
('BWC36', 135, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0008'),
('BWC37', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'No view', True, 'No damages', 'B0008'),
('BWC38', 190, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'City view', False, 'Cracked window', 'B0008'),
('BWC39', 220, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 4, 'River view', False, 'No damages', 'B0008'),
('BWC40', 125, 'Wi-Fi, mini-refrigerator, work desk, coffee and tea maker, bath amenities', 2, 'City view', True, 'No damages', 'B0008'),
('CHA01', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'Missing chair', 'C0001'),
('CHA02', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0001'),
('CHA03', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0001'),
('CHA04', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0001'),
('CHA05', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0001'),
('CHS06', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'Missing chair', 'C0002'),
('CHS07', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0002'),
('CHS08', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0002'),
('CHS09', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0002'),
('CHS10', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0002'),
('CHR11', 120, 'Plush premium bedding, Free high-speed internet', 2, 'City view', True, 'Missing chair', 'C0003'),
('CHR12', 170, 'Plush premium bedding, Free high-speed internet', 4, 'City view', True, 'No damages', 'C0003'),
('CHR13', 110, 'Plush premium bedding, Free high-speed internet', 2, 'No view', False, 'No damages', 'C0003'),
('CHR14', 125, 'Plush premium bedding, Free high-speed internet', 2, 'River view', True, 'No damages', 'C0003'),
('CHR15', 125, 'Plush premium bedding, Free high-speed internet', 2, 'River view', True, 'No damages', 'C0003'),
('CHR16', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'Missing chair', 'C0004'),
('CHR17', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0004'),
('CHR18', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0004'),
('CHR19', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0004'),
('CHR20', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0004'),
('CHI21', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'No damages', 'C0005'),
('CHI22', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0005'),
('CHI23', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0005'),
('CHI24', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0005'),
('CHI25', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0005'),
('CHM26', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'No damages', 'C0006'),
('CHM27', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0006'),
('CHM28', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0006'),
('CHM29', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0006'),
('CHM30', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0006'),
('CHC31', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'City view', True, 'No damages', 'C0007'),
('CHC32', 210, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 4, 'City view', True, 'No damages', 'C0007'),
('CHC33', 130, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'No view', False, 'No damages', 'C0007'),
('CHC34', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0007'),
('CHC35', 150, 'Plush premium bedding, Free high-speed internet, 24-hour business center', 2, 'River view', True, 'No damages', 'C0007'),
('CHA36', 150, 'Plush premium bedding, Free high-speed internet', 2, 'City view', True, 'No damages', 'C0008'),
('CHA37', 210, 'Plush premium bedding, Free high-speed internet', 4, 'City view', True, 'No damages', 'C0008'),
('CHA38', 130, 'Plush premium bedding, Free high-speed internet', 2, 'No view', False, 'No damages', 'C0008'),
('CHA39', 150, 'Plush premium bedding, Free high-speed internet', 2, 'River view', True, 'No damages', 'C0008'),
('CHA40', 150, 'Plush premium bedding, Free high-speed internet', 2, 'River view', True, 'No damages', 'C0008'),
('HWV01', 320, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0001'),
('HWV02', 410, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Ocean view', True, 'No damages', 'H0001'),
('HWV03', 240, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0001'),
('HWV04', 270, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0001'),
('HWV05', 280, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0001'),
('HWY06', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0002'),
('HWY07', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Ocean view', True, 'No damages', 'H0002'),
('HWY08', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0002'),
('HWY09', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0002'),
('HWY10', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0002'),
('HWY11', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0003'),
('HWY12', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Ocean view', True, 'No damages', 'H0003'),
('HWY13', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0003'),
('HWY14', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0003'),
('HWY15', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0003'),
('HWF16', 270, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'Sink is cracked', 'H0004'),
('HWF17', 370, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Ocean view', True, 'No damages', 'H0004'),
('HWF18', 200, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0004'),
('HWF19', 210, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0004'),
('HWF20', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Ocean view', True, 'No damages', 'H0004'),
('HWC21', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0005'),
('HWC22', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Lake view', True, 'No damages', 'H0005'),
('HWC23', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0005'),
('HWC24', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0005'),
('HWC25', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0005'),
('HWW26', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0006'),
('HWW27', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Lake view', True, 'No damages', 'H0006'),
('HWW28', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0006'),
('HWW29', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0006'),
('HWW30', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0006'),
('HWT31', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0007'),
('HWT32', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Lake view', True, 'No damages', 'H0007'),
('HWT33', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'Dead rat', 'H0007'),
('HWT34', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0007'),
('HWT35', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0007'),
('HWQ36', 300, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0008'),
('HWQ37', 400, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'Lake view', True, 'No damages', 'H0008'),
('HWQ38', 220, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'City view', False, 'No damages', 'H0008'),
('HWQ39', 230, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 4, 'City view', False, 'No damages', 'H0008'),
('HWQ40', 250, 'On-site restaurant, Fitness center, Business center, Indoor pool, Executive lounge, Outdoor pool, Room service', 2, 'Lake view', True, 'No damages', 'H0008'),
('MIV01', 365, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0001'),
('MIV02', 265, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0001'),
('MIV03', 400, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'Ocean view', False, 'No damages', 'M0001'),
('MIV04', 330, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'Ocean view', False, 'No damages', 'M0001'),
('MIV05', 355, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0001'),
('MIV06', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0002'),
('MIV07', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0002'),
('MIV08', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'Ocean view', False, 'No damages', 'M0002'),
('MIV09', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'Ocean view', False, 'Light bulb out', 'M0002'),
('MIV10', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0002'),
('MIO11', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0003'),
('MIO12', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0003'),
('MIO13', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'River view', False, 'No damages', 'M0003'),
('MIO14', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'River view', False, 'No damages', 'M0003'),
('MIO15', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0003'),
('MIN16', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0004'),
('MIN17', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0004'),
('MIN18', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'River view', False, 'No damages', 'M0004'),
('MIN19', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'River view', False, 'No damages', 'M0004'),
('MIN20', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0004'),
('MIW21', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0005'),
('MIW22', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0005'),
('MIW23', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'Lake view', False, 'No damages', 'M0005'),
('MIW24', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'Lake view', False, 'No damages', 'M0005'),
('MIW25', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0005'),
('MID26', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0006'),
('MID27', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0006'),
('MID28', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'River view', False, 'No damages', 'M0006'),
('MID29', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'River view', False, 'No damages', 'M0006'),
('MID30', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0006'),
('MIH31', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0007'),
('MIH32', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0007'),
('MIH33', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'River view', False, 'No showerhead', 'M0007'),
('MIH34', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'River view', False, 'No damages', 'M0007'),
('MIH35', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0007'),
('MIP36', 345, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0008'),
('MIP37', 245, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'City view', True, 'No damages', 'M0008'),
('MIP38', 380, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'River view', False, 'No damages', 'M0008'),
('MIP39', 310, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 2, 'River view', False, 'No damages', 'M0008'),
('MIP40', 335, 'Refrigerator, microwave, workstation, kitchen, coffee maker, crib, and ironing board', 4, 'City view', True, 'No damages', 'M0008'),
('WHO01', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0001'),
('WHO02', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0001'),
('WHO03', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0001'),
('WHO04', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0001'),
('WHO05', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0001'),
('WHO06', 60, 'No amenities', 2, 'No windows, no view', False, 'Broken TV', 'W0002'),
('WHO07', 80, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0002'),
('WHO08', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0002'),
('WHO09', 80, 'No amenities', 4, 'No windows, no view', False, 'Dirty towels', 'W0002'),
('WHO10', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0002'),
('WHT11', 60, 'No amenities', 2, 'No windows, no view', False, 'Broken TV', 'W0003'),
('WHT12', 80, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0003'),
('WHT13', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0003'),
('WHT14', 80, 'No amenities', 4, 'No windows, no view', False, 'Dirty towels', 'W0003'),
('WHT15', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0003'),
('WHC16', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0004'),
('WHC17', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0004'),
('WHC18', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0004'),
('WHC19', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0004'),
('WHC20', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0004'),
('WHL21', 60, 'No amenities', 2, 'No windows, no view', False, 'Broken TV', 'W0005'),
('WHL22', 80, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0005'),
('WHL23', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0005'),
('WHL24', 80, 'No amenities', 4, 'No windows, no view', False, 'Dirty towels', 'W0005'),
('WHL25', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0005'),
('WHO26', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0006'),
('WHO27', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0006'),
('WHO28', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0006'),
('WHO29', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0006'),
('WHO30', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0006'),
('WHH31', 60, 'No amenities', 2, 'No windows, no view', False, 'Broken TV', 'W0007'),
('WHH32', 80, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0007'),
('WHH33', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0007'),
('WHH34', 80, 'No amenities', 4, 'No windows, no view', False, 'Dirty towels', 'W0007'),
('WHH35', 60, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0007'),
('WHO36', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0008'),
('WHO37', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0008'),
('WHO38', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0008'),
('WHO39', 90, 'No amenities', 4, 'No windows, no view', False, 'No damages', 'W0008'),
('WHO40', 70, 'No amenities', 2, 'No windows, no view', False, 'No damages', 'W0008');