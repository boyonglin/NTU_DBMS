/* create and use database */
CREATE DATABASE MysteryDB;
USE MysteryDB;

/* info */
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r10945002', '生醫電資所', 1, '林柏詠');

SELECT DATABASE();
SELECT * FROM self;

/* create table */
CREATE TABLE person (
    person_id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    last_call_id INT,
    citizenship ENUM('native', 'foreigner') NOT NULL,
    PRIMARY KEY (person_id, citizenship),
    FOREIGN KEY (last_call_id) REFERENCES person (person_id)
);

CREATE TABLE contact (
    id INT NOT NULL,
    phone_number VARCHAR(32) NOT NULL UNIQUE,
    email VARCHAR(256),
    FOREIGN KEY (id) REFERENCES person (person_id)
);

CREATE TABLE bank_account (
	account_type ENUM('checking', 'saving') NOT NULL,
	account_number INT NOT NULL UNIQUE,
    creation_year INT NOT NULL CHECK (creation_year > 1397),
    owner_id INT NOT NULL,
    PRIMARY KEY (owner_id, account_type),
    FOREIGN KEY (owner_id) REFERENCES person (person_id)
);

CREATE TABLE native (
    id_card INT NOT NULL UNIQUE,
    passport INT,
	license_plate VARCHAR(12),
    person_id INT NOT NULL UNIQUE,
    citizenship ENUM('native', 'foreigner') DEFAULT 'native' CHECK (citizenship = 'native'),
    FOREIGN KEY (person_id, citizenship) REFERENCES person (person_id, citizenship)
);

CREATE TABLE foreigner (
    passport INT NOT NULL UNIQUE,
    visa_duration DATE NOT NULL,
	license_plate VARCHAR(12),
	person_id INT NOT NULL UNIQUE,
    citizenship ENUM('native', 'foreigner') DEFAULT 'foreigner' CHECK (citizenship = 'foreigner'),
    FOREIGN KEY (person_id, citizenship) REFERENCES person (person_id, citizenship)
);

CREATE TABLE crime_scene_report (
    report_id INT AUTO_INCREMENT,
    date DATE NOT NULL,
    street VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    description_form SET('text', 'video', 'picture', 'audio'),
    PRIMARY KEY (report_id)
);

CREATE TABLE interview (
	interview_id INT AUTO_INCREMENT,
	person_id INT NOT NULL,
    transcript TEXT NOT NULL,
    report_id INT,
    PRIMARY KEY (interview_id),
    FOREIGN KEY (person_id) REFERENCES person (person_id),
    FOREIGN KEY (report_id) REFERENCES crime_scene_report (report_id)
);

CREATE TABLE bakery_security_log (
    log_id INT AUTO_INCREMENT,
    time TIME NOT NULL,
    door_activity ENUM('open', 'close') NOT NULL,
    license_plate VARCHAR(12),
    report_id INT,
    PRIMARY KEY (log_id),
	FOREIGN KEY (report_id) REFERENCES crime_scene_report (report_id)
);

CREATE TABLE airport (
    airport_id INT AUTO_INCREMENT,
    abbreviation VARCHAR(3) NOT NULL,
    full_name VARCHAR(50) NOT NULL,
    city VARCHAR(30) NOT NULL,
    PRIMARY KEY (airport_id)
);

CREATE TABLE flight (
    flight_id VARCHAR(5) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    depart_airport_id INT NOT NULL,
    arrive_airport_id INT NOT NULL,
    PRIMARY KEY (flight_id),
	FOREIGN KEY (depart_airport_id) REFERENCES airport (airport_id),
    FOREIGN KEY (arrive_airport_id) REFERENCES airport (airport_id)
);

CREATE TABLE passenger (
	seat VARCHAR(3) NOT NULL,
    passport INT NOT NULL,
    age INT NOT NULL CHECK (age > 6),
    PRIMARY KEY (seat)
);

CREATE TABLE air_ticket (
	flying_time INT NOT NULL CHECK (flying_time > 0),
    flight_id VARCHAR(5) NOT NULL,
    seat VARCHAR(3) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES flight (flight_id),
    FOREIGN KEY (seat) REFERENCES passenger (seat)
);

/* insert */
INSERT INTO person (name, citizenship) VALUES
('Jim Hopper', 'native'),
('Mike Wheeler', 'native'),
('Jane Hopper', 'foreigner');

INSERT INTO contact VALUES
(1, '+1-1014697393', 'jimhopper@mail.com'),
(2, '+1-2676570338', 'mikewheeler@mail.com'),
(3, '+1-7756761002', 'eleven@mail.com');

INSERT INTO bank_account VALUES
('checking', '1166041982', '1982', 1),
('saving', '1152972669', '2001', 2),
('saving', '1140475899', '2001', 3);

INSERT INTO native (id_card, passport, license_plate, person_id) VALUES
('313294194', '554049320', '2106-86-2901', 1),
('317150817', NULL, '4313-78-6601', 2);

INSERT INTO foreigner (passport, visa_duration, license_plate, person_id) VALUES
('688399487', '2028-09-02', '7881-41-6348', 3);

INSERT INTO crime_scene_report (date, street, description, description_form) VALUES
('2023-02-25', 'Church Street', 'Bakery burglarized on Church Street, pastries and cash missing. Suspect entered through the back door, leaving crumbs and evidence behind.', 'video,audio'),
('2023-02-25', 'Church Street', 'Investigation ongoing at Church Street bakery, no evidence of foul play found yet.', 'text'),
('2023-02-25', 'Peachtree Street', 'Police patrolled Peachtree Street, but no unusual activity was observed in the area.', 'text');

INSERT INTO interview (person_id, transcript, report_id) VALUES
(2, "Interviewer: Can you describe the incident that occurred at the bakery?\n
Interviewee: Yes, there was a break-in last night. They took cash and pastries, but luckily the CCTV footage did not captured the culprit.", 1),
(2, "Interviewer: Did you recognize the thief in the footage?\n
Interviewee: No, unfortunately they were wearing a hoodie and a mask, so we couldn't see their face.", 2),
(3, "Interviewer: Have you reported the incident to the police?\n
Interviewee: Yes, we filed a report this morning and provided them with the footage. We hope they'll be able to catch the culprit soon.", 1);

INSERT INTO bakery_security_log (time, door_activity, license_plate, report_id) VALUES
('14:30:27', 'open', NULL, NULL),
('14:35:09', 'close', NULL, NULL),
('14:35:54', 'open', '7881-41-6348', 1);

INSERT INTO airport (abbreviation, full_name, city) VALUES
('SFO', 'San Francisco', 'San Francisco'),
('LAX', 'Los Angeles', 'Los Angeles'),
('ROC', 'Rochester', 'New York');

INSERT INTO flight VALUES
('LS164', '2023-02-24', '07:20', '2', '1'),
('SL158', '2023-02-25', '14:30', '1', '2'),
('RL583', '2023-02-25', '17:45', '3', '2');

INSERT INTO passenger VALUES
('H11', '554049320', '41'),
('D06', '317690617', '26'),
('A42', '265908209', '32');

INSERT INTO air_ticket VALUES
('118', 'SL158', 'H11'),
('124', 'SL158', 'D06'),
('210', 'LS164', 'A42');

/* create two views (Each view should be based on two tables.) */
CREATE VIEW person_info AS
SELECT name, phone_number, email, citizenship
FROM person, contact
WHERE person.person_id = contact.id;

CREATE VIEW report_details AS
SELECT GROUP_CONCAT(name) as witness, date, time, license_plate, description
FROM interview, bakery_security_log, crime_scene_report, person
WHERE crime_scene_report.report_id = interview.report_id
AND crime_scene_report.report_id = bakery_security_log.report_id
AND interview.person_id=person.person_id
GROUP BY date, time, license_plate, description;

/* select from all tables and views */
SELECT * FROM person;
SELECT * FROM contact;
SELECT * FROM bank_account;
SELECT * FROM native;
SELECT * FROM foreigner;
SELECT * FROM interview;
SELECT * FROM bakery_security_log;
SELECT * FROM crime_scene_report;
SELECT * FROM airport;
SELECT * FROM flight;
SELECT * FROM passenger;
SELECT * FROM air_ticket;
SELECT * FROM person_info;
SELECT * FROM report_details;

/* drop database */
DROP DATABASE MysteryDB;