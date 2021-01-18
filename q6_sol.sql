USE springboardopt;
USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 6. List the names of students who have taken all courses offered by department v8 (deptId).
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;

# Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the Transcript,Course, Teaching and Student tables.
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create the following indexes to prevent scans - 
# CREATE INDEX IX_Teaching_crsCode ON Teaching(crsCode)	
# DROP INDEX IX_Transcript_crsCode ON Transcript
# CREATE INDEX IX_Course_deptId ON Course(deptId)	
# DROP INDEX IX_Course_deptId ON Course
# CREATE INDEX IX_Transcript_crsCode ON Transcript(crsCode)
# DROP INDEX IX_Transcript_crsCode ON Transcript
# CREATE INDEX IX_Student_id ON Student(id)
# DROP INDEX IX_Student_id ON Student
# After the fix, the query cost drops to 11.29 from 1441.00 and does key lookups instead of the previous expensive scans.
