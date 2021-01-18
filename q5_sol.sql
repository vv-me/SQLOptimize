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

-- 5. List the names of students who have taken a course from department v6 (deptId), but not v7.
/*SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;
*/

SELECT name FROM Student JOIN 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
ON Student.id = alias.studId;

# Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the Transcript,Course and Student tables.
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create the following indexes to prevent scans - 
# CREATE INDEX IX_Transcript_crsCode ON Transcript(crsCode)	
# DROP INDEX IX_Transcript_crsCode ON Transcript
# CREATE INDEX IX_Student_id ON Student(id)
# DROP INDEX IX_Student_id ON Student
# I also thought it would make sense to create this index but this increases the cost due to the HASH JOIN operator even though it reduces the number of rows being accessed. So this index was dropped.
# CREATE INDEX IX_Course_deptId ON Course(deptId)	
# DROP INDEX IX_Course_deptId ON Course

# After the fix, the query cost drops to 17.47 from 4112.69 and does key lookups instead of the previous expensive scan on Transcript and Student. Course still has a scan. 
