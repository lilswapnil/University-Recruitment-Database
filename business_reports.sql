/********************************************************************  
*	PROJECT 02  													*
*	Author: Rutvij Patil	 	 	 	 				            *
*	SUID: 407777054													*
*	SQL Script to create Business Reports							*	
*																	*
********************************************************************/ 

SELECT SUM (CASE WHEN Position = 'Software Developer' THEN 1 END) AS SoftwareDeveloper ,
SUM(CASE WHEN Position = 'GO Developer' THEN 1 END) AS GODeveloper,
SUM(CASE WHEN Position = 'Data Analyst' THEN 1 END) AS DataAnalyst,
SUM(CASE WHEN Position = 'Hardware Intern' THEN 1 END) AS HardwareIntern
FROM Job;

SELECT A.ApplicationID, COUNT(ComplaintID) AS 'Number of Complaints'
From Application AS A INNER JOIN ApplicantGrievance AS C
ON A.ApplicationId = C.ApplicationId
GROUP BY A.ApplicationId;

SELECT DISTINCT A.ApplicationID, COUNT(I.InterviewID) AS [NUMBER OF INTERVIEWS]
FROM  Tests AS A INNER JOIN Interviews AS I
ON  A.TestID = I.TestID
GROUP BY A.ApplicationId;


SELECT SUM(Amount) AS [Total Reimbursement Cost]
FROM  Reimbursement ;















