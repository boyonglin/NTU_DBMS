/* avoid exists errors */
DROP DATABASE IF EXISTS MysteryDB;

/* create and use database */
CREATE DATABASE IF NOT EXISTS MysteryDB;
USE MysteryDB;

/* student info */
CREATE TABLE self (
    student_id VARCHAR(10) NOT NULL,
    department VARCHAR(10) NOT NULL,
    school_year INT DEFAULT 1,
    name VARCHAR(10) NOT NULL,
    PRIMARY KEY (student_id)
);

INSERT INTO self
VALUES ('r10945002', '生醫電資所', 1, '林柏詠');

SELECT DATABASE();
SELECT * FROM self;

/* create table */
CREATE TABLE person (
    person_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    last_call_id INT,
    citizenship ENUM('native', 'foreigner') NOT NULL,
    PRIMARY KEY (person_id, citizenship),
    FOREIGN KEY (last_call_id) REFERENCES person (person_id)
);

CREATE TABLE contact (
    id INT NOT NULL,
    phone_number VARCHAR(32) NOT NULL,
    email VARCHAR(256),
    UNIQUE (phone_number),
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES person (person_id)
);

/* weak entity type */
CREATE TABLE bank_account (
	account_type ENUM('checking', 'saving') NOT NULL,
	account_number INT NOT NULL,
    creation_year INT NOT NULL,
    person_id INT NOT NULL,
    UNIQUE (account_number),
    FOREIGN KEY (person_id) REFERENCES person (person_id)
);

/* disjoint specialization */
CREATE TABLE native (
    id_card INT NOT NULL,
    passport INT,
	license_plate VARCHAR(12),
    person_id INT NOT NULL,
    citizenship ENUM('native', 'foreigner') DEFAULT 'native',
    UNIQUE (person_id),
    PRIMARY KEY (id_card),
    FOREIGN KEY (person_id, citizenship) REFERENCES person (person_id, citizenship)
);

CREATE TABLE foreigner (
    passport INT NOT NULL,
    visa_duration DATE NOT NULL,
	license_plate VARCHAR(12),
	person_id INT NOT NULL,
    citizenship ENUM('native', 'foreigner') DEFAULT 'foreigner',
    UNIQUE (person_id),
    PRIMARY KEY (passport),
    FOREIGN KEY (person_id, citizenship) REFERENCES person (person_id, citizenship)
);

/*  union - superclass */
CREATE TABLE interview (
	id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    transcript TEXT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id) REFERENCES person (person_id)
);

/* union - superclass */
CREATE TABLE bakery_security_log (
    id INT NOT NULL AUTO_INCREMENT,
    time TIME NOT NULL,
    door_activity ENUM('open', 'close') NOT NULL,
    license_plate VARCHAR(12),
    PRIMARY KEY (id)
);

/* union - subclass */
CREATE TABLE crime_scene_report (
    id INT NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    street VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    /* overlapping specialization */
    description_form SET('text', 'video', 'picture', 'audio'),
    interview_id INT,
    log_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (interview_id) REFERENCES interview (id),
    FOREIGN KEY (log_id) REFERENCES bakery_security_log (id)
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
('checking', '66041982', '1962', 1),
('saving', '52972669', '1981', 2),
('saving', '40475899', '1981', 3);

INSERT INTO native (id_card, passport, license_plate, person_id) VALUES
('313294194', '554049320', '2106-86-2901', 1),
('317150817', NULL, '4313-78-6601', 2);

INSERT INTO foreigner (passport, visa_duration, license_plate, person_id) VALUES
('688399487', '2028-09-02', '7881-41-6348', 3);

INSERT INTO interview (name, transcript, person_id) VALUES
('Mike Wheeler', "Interviewer: Can you describe the incident that occurred at the bakery?\n
Interviewee: Yes, there was a break-in last night. They took cash and pastries, but luckily the CCTV footage captured the culprit.", 2),
('Mike Wheeler', "Interviewer: Did you recognize the thief in the footage?\n
Interviewee: No, unfortunately they were wearing a hoodie and a mask, so we couldn't see their face.", 2),
('Jane Hopper', "Interviewer: Have you reported the incident to the police?\n
Interviewee: Yes, we filed a report this morning and provided them with the footage. We hope they'll be able to catch the culprit soon.", 3);

INSERT INTO bakery_security_log (time, door_activity, license_plate) VALUES
('14:30:27', 'open', NULL),
('14:35:09', 'close', NULL),
('14:35:54', 'open', '7881-41-6348');

INSERT INTO crime_scene_report (date, street, description, description_form, interview_id, log_id) VALUES
('2023-03-25', 'Church Street', 'Bakery burglarized on Church Street, pastries and cash missing. Suspect entered through the back door, leaving crumbs and evidence behind.', 'video,audio', 1, 3),
('2023-03-25', 'Church Street', 'Investigation ongoing at Church Street bakery, no evidence of foul play found yet.', 'text', 2, NULL),
('2023-03-25', 'Peachtree Street', 'Police patrolled Peachtree Street, but no unusual activity was observed in the area.', 'text', NULL, NULL);

/* create two views (Each view should be based on two tables.) */
CREATE VIEW person_info AS
SELECT name, phone_number, email, citizenship
FROM person, contact
WHERE person.person_id = contact.id;

CREATE VIEW report_details AS
SELECT name as witness, date, time, license_plate, description
FROM interview, bakery_security_log, crime_scene_report
WHERE crime_scene_report.interview_id = interview.id AND crime_scene_report.log_id = bakery_security_log.id;

/* select from all tables and views */
SELECT * FROM person;
SELECT * FROM contact;
SELECT * FROM bank_account;
SELECT * FROM native;
SELECT * FROM foreigner;
SELECT * FROM interview;
SELECT * FROM bakery_security_log;
SELECT * FROM crime_scene_report;
SELECT * FROM person_info;
SELECT * FROM report_details;

/* drop database */
DROP DATABASE IF EXISTS MysteryDB;