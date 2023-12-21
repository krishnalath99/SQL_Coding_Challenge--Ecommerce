CREATE DATABASE CrimeAnalysisAndReporting;
USE CrimeAnalysisAndReporting;

CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
);

CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) ON DELETE CASCADE
);

CREATE TABLE Suspect (
 SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) ON DELETE CASCADE
);


INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');


--QUERIES
--1. Select all open incidents.
SELECT *
FROM Crime
WHERE Status = 'Open';

--2. Find the total number of incidents.
SELECT COUNT(*) as TotalNumberOfIncidents
FROM Crime;

--3. List all unique incident types.
SELECT DISTINCT IncidentType
FROM Crime;

--4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.
SELECT *
FROM Crime
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

--5. List persons involved in incidents in descending order of age.
--NO AGE COLUMN IN ANY TABLE OF THE DATABASE

--6. Find the average age of persons involved in incidents.
--NO AGE COLUMN IN ANY TABLE OF THE DATABASE

--7. List incident types and their counts, only for open cases.
SELECT IncidentType, COUNT(CrimeID) aS NumberOfOpenCases
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType;

--8. Find persons with names containing 'Doe'.
SELECT * FROM Victim
WHERE Name LIKE '%Doe%';

--9. Retrieve the names of persons involved in open cases and closed cases.
SELECT v.Name, c.Status
FROM Crime c, Victim v
WHERE c.CrimeID = v.CrimeID
AND (c.Status = 'Open' OR c.Status = 'Closed');

--10.List incident types where there are persons aged 30 or 35 involved.
--NO AGE COLUMN IN ANY TABLE OF THE DATABASE
