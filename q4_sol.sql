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
/*
-- 4. List the names of students who have taken a course taught by professor v5 (name).
SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;
*/
SELECT name FROM Student JOIN 
	(SELECT studId FROM Transcript JOIN
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			ON Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	ON Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
ON Student.id = alias2.studId;


# Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the 4 tables involved.
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create the following indexes to prevent scans - 
#CREATE INDEX IX_Professor_name ON Professor(name)
#CREATE INDEX IX_Teaching_id ON Teaching(profId)
#CREATE INDEX IX_Transcript_crsCode ON Transcript (crsCode) 
#CREATE INDEX IX_Transcript_semester ON Transcript (semester) 
#CREATE INDEX IX_Student_id ON Student (id) 
# After the fix, the query cost drops to 1.07 from 17513.72 and does only key lookups instead of the previous expensive scan on Transcript, Teaching, Professor and Student.  
# The queries were also rewritten using JOINS and ON instead of the older form of writing with WHERE clauses.