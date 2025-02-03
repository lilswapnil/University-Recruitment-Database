CREATE DATABASE UMC_HRDepartment;

USE UMC_HRDepartment;
GO

-- Administrator Table
CREATE TABLE Administrator (
    AdminID int PRIMARY KEY,
    Username varchar(20),
    Password varchar(20),
    Email varchar(20),
    FName varchar(50),
    LName varchar(50)
);

-- JobPlatform Table
CREATE TABLE JobPlatform (
    JobPlatformID int PRIMARY KEY,
    PlatformName varchar(100),
    PlatformDescription varchar(100)
);

-- JobOpenings Table
CREATE TABLE JobOpenings (
    JobOpeningID int PRIMARY KEY,
    NumberOfPositions int,
    JobTitle varchar(100),
    Description varchar(100)
);

-- Job Table
CREATE TABLE Job (
    JobID int PRIMARY KEY,
    Title varchar(100),
    Position varchar(100),
    JobType varchar(100),
    Medium varchar(100),
    NumberOfPositions int,
    Salary money,
    JobCategory varchar(100),
    JobOpeningsID int,
    JobPlatformID int,
    FOREIGN KEY (JobOpeningsID) REFERENCES JobOpenings(JobOpeningID),
    FOREIGN KEY (JobPlatformID) REFERENCES JobPlatform(JobPlatformID)
);

-- Candidates Table
CREATE TABLE Candidates (
    CandidateID int PRIMARY KEY,
    FName varchar(50),
    LName varchar(50),
    Email varchar(50),
    Phone varchar(15),
    Passport varchar(40),
    OfferAccepted varchar(50)
);

-- OnBoarding Table
CREATE TABLE OnBoarding (
    OnBoardingID int PRIMARY KEY,
    StartDate date,
    OfficialStartDate date,
    OnBoardingStatus varchar(100),
    CandidateID int,
    JobID int,
    FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID),
    FOREIGN KEY (JobID) REFERENCES Job(JobID)
);

-- Documents Table
CREATE TABLE Documents (
    DocumentID int PRIMARY KEY,
    DocumentName varchar(50),
    DocumentURL varchar(200),
    LastUpdated date,
    CandidateID int,
    FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID)
);

-- Application Table
CREATE TABLE Application (
    ApplicationID int PRIMARY KEY,
    ApplicationDate date,
    Qualification varchar(100),
    JobExperience varchar(100),
    ExtraCurricular varchar(100),
    CandidateID int,
    JobID int,
    FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID),
    FOREIGN KEY (JobID) REFERENCES Job(JobID)
);

-- ApplicationDocument Table
CREATE TABLE ApplicationDocument (
    ApplicationDocumentID int PRIMARY KEY,
    DocumentID int,
    ApplicationID int,
    FOREIGN KEY (DocumentID) REFERENCES Documents(DocumentID),
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID)
);

-- Reimbursement Table
CREATE TABLE Reimbursement (
    RequestID int PRIMARY KEY,
    Amount money,
    RefundType varchar(40),
    RefundStatus money,
    SanctionedAmount varchar(40),
    ApplicationID int,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID)
);

-- ApplicantGrievance Table
CREATE TABLE ApplicantGrievance (
    ComplaintID int PRIMARY KEY,
    Description varchar(100),
    Validity bit,
    InterviewStatus varchar(100),
    ApplicationID int,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID)
);

-- TestAssessment Table
CREATE TABLE TestAssessment (
    TestAssessmentID int PRIMARY KEY,
    Duration int,
    HighestScore int,
    AssessmentType varchar(50)
);

-- Tests Table
CREATE TABLE Tests (
    TestID int PRIMARY KEY,
    Grade varchar(20),
    MarksObtained int,
    StartTime time,
    EndTime time,
    ApplicationID int,
    TestAssessmentID int,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID),
    FOREIGN KEY (TestAssessmentID) REFERENCES TestAssessment(TestAssessmentID)
);

-- ApplicationStatus Table
CREATE TABLE ApplicationStatus (
    ApplicationStatusID int PRIMARY KEY,
    ApplicationStatus varchar(100)
);

-- ApplicationStatusUpdate Table
CREATE TABLE ApplicationStatusUpdate (
    UpdateID int PRIMARY KEY,
    UpdatedDate date,
    ApplicationID int,
    ApplicationStatusID int,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID),
    FOREIGN KEY (ApplicationStatusID) REFERENCES ApplicationStatus(ApplicationStatusID)
);

-- InterviewRounds Table
CREATE TABLE InterviewRounds (
    IRoundID int PRIMARY KEY,
    RoundName varchar(20)
);

-- Interviews Table
CREATE TABLE Interviews (
    InterviewID int PRIMARY KEY,
    StartTime time,
    EndTime time,
    InterviewMode varchar(100),
    TestID int,
    FOREIGN KEY (TestID) REFERENCES Tests(TestID)
);

-- Interviewers Table
CREATE TABLE Interviewers (
    InterviewerID int PRIMARY KEY,
    FName varchar(100),
    LName varchar(100),
    JobTitle varchar(100),
    Department varchar(100)
);

-- Process Table
CREATE TABLE Process (
    ProcessID int PRIMARY KEY,
    ProcessDescription varchar(100),
    InterviewerID int,
    FOREIGN KEY (InterviewerID) REFERENCES Interviewers(InterviewerID)
);

-- ProcessRounds Table
CREATE TABLE ProcessRounds (
    PRoundID int PRIMARY KEY,
    ProcessID int,
    IRoundID int,
    FOREIGN KEY (ProcessID) REFERENCES Process(ProcessID),
    FOREIGN KEY (IRoundID) REFERENCES InterviewRounds(IRoundID)
);

-- ApplicantEvaluation Table
CREATE TABLE ApplicantEvaluation (
    EvaluationID int PRIMARY KEY,
    Comments varchar(100),
    Result int,
    ApplicationID int,
    InterviewerID int,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID),
    FOREIGN KEY (InterviewerID) REFERENCES Interviewers(InterviewerID)
);

-- InterviewFeedback Table
CREATE TABLE InterviewFeedback (
    FeedbackID int PRIMARY KEY,
    Result varchar(100),
    FeedbackType varchar(100),
    InterviewID int,
    InterviewerID int,
    FOREIGN KEY (InterviewID) REFERENCES Interviews(InterviewID),
    FOREIGN KEY (InterviewerID) REFERENCES Interviewers(InterviewerID)
);

--Insert Data
INSERT INTO JobPlatform (JobPlatformID, PlatformName, PlatformDescription)
VALUES 
(1, 'LinkedIn', 'Professional networking platform'),
(2, 'Indeed', 'Job listing and company reviews'),
(3, 'Glassdoor', 'Job search and company transparency'),
(4, 'Monster', 'Global employment website'),
(5, 'ZipRecruiter', 'Online employment marketplace');

INSERT INTO JobOpenings (JobOpeningID, NumberOfPositions, JobTitle, Description)
VALUES 
(1, 3, 'Software Developer', 'Develop and maintain software applications'),
(2, 2, 'Product Manager', 'Oversee product development from conception to launch'),
(3, 1, 'Graphic Designer', 'Create visual concepts to communicate ideas'),
(4, 4, 'Sales Associate', 'Manage sales transactions and customer relations'),
(5, 2, 'Data Scientist', 'Analyze data and develop insights');

INSERT INTO Job (JobID, Title, Position, JobType, Medium, NumberOfPositions, Salary, JobCategory, JobOpeningsID, JobPlatformID)
VALUES 
(1, 'Software Engineer', 'Full-Time', 'Remote', 'Digital', 3, 90000, 'IT', 1, 1),
(2, 'Senior Product Manager', 'Full-Time', 'On-site', 'Physical', 2, 115000, 'Management', 2, 2),
(3, 'Junior Graphic Designer', 'Contract', 'Hybrid', 'Digital/Physical', 1, 45000, 'Design', 3, 3),
(4, 'Retail Sales Associate', 'Part-Time', 'On-site', 'Physical', 4, 30000, 'Sales', 4, 4),
(5, 'Lead Data Scientist', 'Full-Time', 'Remote', 'Digital', 2, 130000, 'Data Analysis', 5, 5);

INSERT INTO Candidates (CandidateID, FName, LName, Email, Phone, Passport, OfferAccepted)
VALUES 
(1, 'Liam', 'Wilson', 'liam.wilson@example.com', '123-456-7890', 'P1234567', 'Yes'),
(2, 'Emma', 'Johnson', 'emma.johnson@example.com', '234-567-8901', 'P2345678', 'No'),
(3, 'Noah', 'Martinez', 'noah.martinez@example.com', '345-678-9012', 'P3456789', 'Yes'),
(4, 'Olivia', 'Lee', 'olivia.lee@example.com', '456-789-0123', 'P4567890', 'Yes'),
(5, 'Ava', 'Garcia', 'ava.garcia@example.com', '567-890-1234', 'P5678901', 'No');

INSERT INTO Candidates (CandidateID, FName, LName, Email, Phone, Passport, OfferAccepted)
VALUES 
(6, 'Marissa', 'Capers', 'marissa@example.com', '567-890-1235', 'P5678902', 'No');

INSERT INTO OnBoarding (OnBoardingID, StartDate, OfficialStartDate, OnBoardingStatus, CandidateID, JobID)
VALUES 
(1, '2024-05-01', '2024-05-15', 'Scheduled', 1, 1),
(2, '2024-06-01', '2024-06-15', 'Pending', 3, 2),
(3, '2024-07-01', '2024-07-15', 'Completed', 4, 3),
(4, '2024-08-01', '2024-08-15', 'Cancelled', 2, 4),
(5, '2024-09-01', '2024-09-15', 'Scheduled', 5, 5);

INSERT INTO Documents (DocumentID, DocumentName, DocumentURL, LastUpdated, CandidateID)
VALUES 
(1, 'Resume', 'http://example.com/resume1.pdf', '2024-04-01', 1),
(2, 'Cover Letter', 'http://example.com/cover2.pdf', '2024-04-02', 2),
(3, 'Portfolio', 'http://example.com/portfolio3.pdf', '2024-04-03', 3),
(4, 'Certifications', 'http://example.com/certs4.pdf', '2024-04-04', 4),
(5, 'References', 'http://example.com/references5.pdf', '2024-04-05', 5);

INSERT INTO Application (ApplicationID, ApplicationDate, Qualification, JobExperience, ExtraCurricular, CandidateID, JobID)
VALUES 
(1, '2024-03-01', 'Bachelor’s in Computer Science', '5 years', 'Coding Bootcamp', 1, 1),
(2, '2024-03-05', 'MBA', '8 years', 'Volunteer Work', 2, 2),
(3, '2024-03-10', 'Bachelor’s in Design', '2 years', 'Freelance Projects', 3, 3),
(4, '2024-03-15', 'High School Diploma', '3 years', 'Retail Management', 4, 4),
(5, '2024-03-20', 'PhD in Data Science', '10 years', 'Published Research', 5, 5);

INSERT INTO ApplicationDocument (ApplicationDocumentID, DocumentID, ApplicationID)
VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO Reimbursement (RequestID, Amount, RefundType, RefundStatus, SanctionAmount, ApplicationID)
VALUES 
(1, 100.00, 'Travel', 50.00, 'Approved', 1),
(2, 200.00, 'Accommodation', 150.00, 'Approved', 2),
(3, 300.00, 'Relocation', 250.00, 'Pending', 3),
(4, 400.00, 'Training', 350.00, 'Denied', 4),
(5, 500.00, 'Miscellaneous', 450.00, 'Approved', 5);

UPDATE Reimbursement
SET RefundStatus = 'Denied'
WHERE ApplicationID IN (4);

SELECT *From Reimbursement;

INSERT INTO ApplicantGrievance (ComplaintID, Description, Validity, InterviewStatus, ApplicationID)
VALUES 
(1, 'Interviewer was late', 1, 'Resolved', 1),
(2, 'Incorrect job description', 0, 'Under Review', 2),
(3, 'Delay in response', 1, 'Resolved', 3),
(4, 'Unfair assessment criteria', 1, 'Pending', 4),
(5, 'Technical issues during online test', 1, 'Resolved', 5);

INSERT INTO TestAssessment (TestAssessmentID, Duration, HighestScore, AssessmentType)
VALUES 
(1, 60, 100, 'Technical Coding Test'),
(2, 30, 100, 'Personality Test'),
(3, 45, 100, 'Design Portfolio Review'),
(4, 90, 100, 'Sales Pitch Simulation'),
(5, 120, 100, 'Data Analysis Test');

INSERT INTO Tests (TestID, Grade, MarksObtained, StartTime, EndTime, ApplicationID, TestAssessmentID)
VALUES 
(1, 'A', 95, '09:00', '10:00', 1, 1),
(2, 'B', 85, '10:30', '11:00', 2, 2),
(3, 'A', 90, '12:00', '12:45', 3, 3),
(4, 'C', 75, '14:00', '15:30', 4, 4),
(5, 'A', 98, '16:00', '18:00', 5, 5);

INSERT INTO ApplicationStatus (ApplicationStatusID, ApplicationStatus)
VALUES 
(1, 'Received'),
(2, 'Under Review'),
(3, 'Interview Scheduled'),
(4, 'Offer Extended'),
(5, 'Rejected');

INSERT INTO ApplicationStatusUpdate (StatusUpdateID, UpdatedDate, ApplicationID, ApplicationStatusID)
VALUES 
(1, '2024-03-02', 1, 1),
(2, '2024-03-06', 2, 2),
(3, '2024-03-11', 3, 3),
(4, '2024-03-16', 4, 4),
(5, '2024-03-21', 5, 5);

INSERT INTO InterviewRounds (IRoundID, RoundName)
VALUES 
(1, 'First Round'),
(2, 'Technical Interview'),
(3, 'HR Round'),
(4, 'Final Round'),
(5, 'Group Discussion');


INSERT INTO Interviews (InterviewID, StartTime, EndTime, InterviewMode, TestID, InterviewerID)
VALUES 
(1, '10:00', '11:00', 'Online', 1, 1),
(2, '11:30', '12:30', 'On-site', 2, 2),
(3, '13:00', '14:00', 'Hybrid', 3, 3),
(4, '14:30', '15:30', 'Online', 4, 4),
(5, '16:00', '17:00', 'On-site', 5, 5);

INSERT INTO Interviewers (InterviewerID, FName, LName, JobTitle, Department)
VALUES 
(1, 'Michael', 'Thompson', 'Senior Engineer', 'Engineering'),
(2, 'Sarah', 'Robinson', 'Project Manager', 'Product Development'),
(3, 'Raj', 'Kumar', 'Creative Director', 'Design'),
(4, 'Jessica', 'Williams', 'Sales Lead', 'Sales'),
(5, 'Daniel', 'Lee', 'Data Scientist', 'Data Science');

INSERT INTO Process (ProcessID, ProcessDescription, InterviewerID)
VALUES 
(1, 'Technical review for software roles', 1),
(2, 'Product management leadership evaluation', 2),
(3, 'Design aptitude and creativity assessment', 3),
(4, 'Sales strategy and customer handling', 4),
(5, 'Advanced analytics and problem-solving evaluation', 5);

INSERT INTO ProcessRounds (PRoundID, ProcessID, IRoundID)
VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO ApplicantEvaluation (EvaluationID, Comments, Result, ApplicationID, InterviewerID)
VALUES 
(1, 'Excellent problem-solving skills', 1, 1, 1),
(2, 'Great leadership but needs technical improvement', 0, 2, 2),
(3, 'Very creative, excellent design skills', 1, 3, 3),
(4, 'Needs more experience in sales', 0, 4, 4),
(5, 'Outstanding analytical skills', 1, 5, 5);

INSERT INTO InterviewFeedback (FeedbackID, Result, FeedbackType, InterviewID, InterviewerID)
VALUES 
(1, 'Passed', 'Positive', 1, 1),
(2, 'Failed', 'Constructive', 2, 2),
(3, 'Passed', 'Positive', 3, 3),
(4, 'Failed', 'Constructive', 4, 4),
(5, 'Passed', 'Positive', 5, 5);

--changes
ALTER TABLE Interviews
ADD InterviewerID int;

ALTER TABLE Interviews
ADD FOREIGN KEY (InterviewerID) REFERENCES Interviewers(InterviewerID);

ALTER TABLE Interviews
ALTER COLUMN StartTime datetime;

ALTER TABLE Application
ADD ApplicationStatusID INT; -- Add a column to store the ApplicationStatusID

ALTER TABLE Application
ADD Status VARCHAR(100);

-- Drop the existing foreign key constraint on JobID
ALTER TABLE Application DROP CONSTRAINT FK_Application_JobID;

-- Add a new foreign key constraint to reference JobOpenings table
-- Add a foreign key constraint to reference JobOpenings table
ALTER TABLE Application
ADD CONSTRAINT FK_Application_JobOpeningID FOREIGN KEY (JobID) REFERENCES JobOpenings(JobOpeningID);

EXEC sp_helpconstraint 'Application';

-- Add TestResult column to TestAssessment table
ALTER TABLE TestAssessment
ADD TestResult VARCHAR(10);

-- Update existing records in TestAssessment to populate TestResult
UPDATE TestAssessment
SET TestResult = CASE
                    WHEN HighestScore >= 60 THEN 'PASS'
                    ELSE 'FAIL'
                END;

-- Verify the changes
SELECT * FROM TestAssessment;

-- Add a temporary column
ALTER TABLE Reimbursement
ADD TempSanctionedAmount money;

-- Update the temporary column with converted values
UPDATE Reimbursement
SET TempSanctionedAmount = TRY_CAST(SanctionedAmount AS money);

-- Drop the original SanctionedAmount column
ALTER TABLE Reimbursement
DROP COLUMN TempSanctionedAmount;

EXEC sp_rename 'Reimbursement.RefundStatus', 'SanctionAmount', 'COLUMN';

ALTER TABLE Reimbursement
ADD RefundStatus varchar(20);

select *from Reimbursement;

-- Rename the temporary column to SanctionedAmount
EXEC sp_rename 'Reimbursement.TempSanctionedAmount', 'SanctionedAmount', 'COLUMN';


-- Rename the temporary column to SanctionedAmount
EXEC sp_rename 'Reimbursement.TempSanctionedAmount', 'SanctionedAmount', 'COLUMN';



-- Start by deleting data from tables that are referenced by foreign keys in other tables last
DELETE FROM InterviewFeedback;
DELETE FROM ApplicantEvaluation;
DELETE FROM ApplicationStatusUpdate;
DELETE FROM Tests;
DELETE FROM ApplicationDocument;
DELETE FROM Reimbursement;
DELETE FROM Interviews;
DELETE FROM ApplicantGrievance;

-- Process and ProcessRounds depend on Interviewers and InterviewRounds
DELETE FROM ProcessRounds;
DELETE FROM Process;

-- These tables have foreign keys pointing to them, so delete after the referencing tables are cleared
DELETE FROM Interviewers;
DELETE FROM InterviewRounds;
DELETE FROM TestAssessment;
DELETE FROM ApplicationStatus;

-- These tables have items that are foreign keys in many of the above tables
DELETE FROM Application;
DELETE FROM Documents;
DELETE FROM OnBoarding;

-- Finally, delete records from these independent or root level tables
DELETE FROM Candidates;
DELETE FROM Job;
DELETE FROM JobOpenings;
DELETE FROM JobPlatform;


--display tables 
-- Confirm deletion (optional, you can use SELECT to check if tables are empty)
SELECT * FROM Administrator;
SELECT * FROM Job;
SELECT * FROM JobOpenings;
SELECT * FROM JobPlatform;
SELECT * FROM Candidates;
SELECT * FROM Application;
SELECT * FROM Tests;
SELECT * FROM TestAssessment;
SELECT * FROM Interviews;
SELECT * FROM Reimbursement;
SELECT * FROM Interviewers;
SELECT * FROM InterviewRounds;
SELECT * FROM InterviewFeedback;
SELECT * FROM ApplicantEvaluation;
SELECT * FROM ApplicationStatus;
SELECT * FROM ApplicationStatusUpdate;
SELECT * FROM Process;
SELECT * FROM ProcessRounds;
SELECT * FROM ApplicationDocument;
SELECT * FROM ApplicantGrievance;
SELECT * FROM Documents;
SELECT * FROM OnBoarding;



