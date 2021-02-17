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

-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).
SELECT name FROM Student WHERE id >= @v2 AND id <= @v3;

#CREATE INDEX IX_Student_id ON Student (id, name) 
#DROP INDEX IX_Student_id ON Student

#Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the Student table to fetch the record corresponding to the range between @v2 AND @v3
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create a composite index on the student_id, name column. This switched the execution from a scan to a Index Range Scan. 
# After the fix, the operator read only 278 row instead of the previous scan which read 400 rows.  
