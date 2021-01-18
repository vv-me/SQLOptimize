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

-- 3. List the names of students who have taken course v4 (crsCode).
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

#CREATE INDEX IX_Student_id ON Student (id, name) 
#DROP INDEX IX_Student_id ON Student 
#CREATE INDEX IX_Transcript_crsCode ON Transcript (crsCode, studId) 
#DROP INDEX IX_Transcript_crsCode ON Transcript

# Solution - 
# What was the bottleneck? - The bottleneck is the full table scan of the Student table and Transcript table.
# How did you identify it? - Turned on the explain plan to understand the optimizer's execution plan.
# What method you chose to resolve the bottleneck - Create a composite index on the student_id, name column in the Student table and crsCode, studId in the Transcript table . This switched the execution from a scan to a Index Range Scan. 
# After the fix, the query cost drops to 1.18 from 414.29 and does only key lookups on the Student and Transcript tables instead of the previous expensive scan.  