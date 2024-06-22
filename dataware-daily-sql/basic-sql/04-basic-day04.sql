
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 4.1、表连接
-- 1）、查询有两门以上的课程不及格的同学的学号及其平均成绩；
SELECT
    stu_id
    , round(avg(score), 2) AS score_avg
FROM hive_sql_zg5.score_info
WHERE stu_id IN (
        -- step1. 找到2门不及格同学
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE score < 60
        GROUP BY stu_id
        HAVING count(course_id) >= 2
    )
GROUP BY stu_id
;


-- todo 解法2：使用 left join关联，筛选数据
WITH
    tmp1 AS (
        -- step1. 找到2门不及格同学
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE score < 60
        GROUP BY stu_id
        HAVING count(course_id) >= 2
    )
SELECT
    t1.stu_id
     , round(avg(score), 2) AS score_avg
FROM tmp1 t1
LEFT JOIN hive_sql_zg5.score_info t2 ON t1.stu_id = t2.stu_id
GROUP BY t1.stu_id
;



-- 2）、查询所有学生的学号、姓名、选课数、总成绩；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , count(course_id) AS course_count
             , sum(score) AS score_sum
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
    )
SELECT
    t1.stu_id
    , t2.stu_name
    , t1.course_count
    , t1.score_sum
FROM tmp1 t1
LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;

-- 3）、查询平均成绩大于85的所有学生的学号、姓名和平均成绩；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , round(avg(score), 2) AS score_avg
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
        HAVING round(avg(score), 2) > 85
    )
SELECT
    t1.stu_id
     , t2.stu_name
     , t1.score_avg
FROM tmp1 t1
         LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;

-- todo：4.2、多表连接
-- 1）、课程编号为"01"且课程分数小于60，按分数降序排列的学生信息；
WITH
    tmp1 AS (
        SELECT
            stu_id, course_id, score
        FROM hive_sql_zg5.score_info
        WHERE course_id = '01' AND score < 60
    )
SELECT
    t1.stu_id, t2.stu_name, t1.course_id, t1.score
FROM tmp1 t1
    LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
ORDER BY t1.score DESC
;



-- 2）、查询所有课程成绩在70分以上的学生的姓名、课程名称和分数，按分数升序排列；
WITH
    tmp1 AS (
        -- step1. 所有课程成绩在70分以上
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
        HAVING min(score) > 70
    )
SELECT
    t3.stu_name
    , t4.course_name
     , t2.score
FROM tmp1 t1
    LEFT JOIN hive_sql_zg5.score_info t2 ON t1.stu_id = t2.stu_id
    LEFT JOIN hive_sql_zg5.student_info t3 ON t1.stu_id = t3.stu_id
    LEFT JOIN hive_sql_zg5.course_info t4 ON t2.course_id = t4.course_id
ORDER BY t2.score
;



-- 3）、查询该学生不同课程的成绩相同的学生编号、课程编号、学生成绩；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id, score
        HAVING count(course_id) >= 2
    )
SELECT
    t1.stu_id
     , t2.course_id
     , t2.score
FROM tmp1 t1
         LEFT JOIN hive_sql_zg5.score_info t2 ON t1.stu_id = t2.stu_id
;


-- 4）、查询课程编号为“01”的课程比“02”的课程成绩高的所有学生的学号；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , sum(if(course_id = '01', score, 0)) AS `score_01`
             , sum(if(course_id = '02', score, 0)) AS `score_02`
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
    )
SELECT stu_id
FROM tmp1
WHERE score_01 > score_02
;



-- 5）、查询学过编号为“01”的课程并且也学过编号为“02”的课程的学生的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , collect_list(course_id) AS course_list
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
    )
SELECT stu_id
FROM tmp1
WHERE array_contains(course_list, '01') AND array_contains(course_list, '02')
;


