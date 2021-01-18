USE springboardopt;
#Solution at the end of the file 
-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 1. List the name of the student with id equal to v1 (id).

SELECT name FROM Student WHERE id = @v1;

#CREATE INDEX IX_Student_id ON Student (id) 

#Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the Student table to fetch the record corresponding to @v1
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create an index on the student_id column. This switched the execution from a scan to a Non-Unique Key Lookup. 
# If the student_id column is defined as a unique non null column then this column can also be defined as a primary key which will create a clustered index using that column as a key which will also prevent the scan. 
# After the fix, the operator read only 1 row instead of the previous scan which read 400 rows.  