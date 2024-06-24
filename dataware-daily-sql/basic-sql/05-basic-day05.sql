
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 5.1、表连接
-- 1）、查询学生的选课情况：学号，姓名，课程号，课程名称；
SELECT
    t1.stu_id
    , t2.stu_name
    , t1.course_id
    , t3.course_name
FROM hive_sql_zg5.score_info t1
LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
LEFT JOIN hive_sql_zg5.course_info t3 ON t1.course_id = t3.course_id
;


-- 2）、查询出每门课程的及格人数和不及格人数；
SELECT
    course_id
    , sum(if(score >= 60, 1, 0)) AS `及格人数`
    , sum(if(score < 60, 1, 0)) AS `不及格人数`
FROM hive_sql_zg5.score_info
GROUP BY course_id
;


-- 3）、查询课程编号为03且课程成绩在80分以上的学生的学号和姓名及课程信息；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , course_id
        FROM hive_sql_zg5.score_info
        WHERE course_id = '03' AND score > 80
    )
SELECT
    t1.stu_id
    , t2.stu_name
    , t1.course_id
    , t3.course_name
    , t3.tea_id
FROM tmp1 t1
    LEFT JOIN  hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
    LEFT JOIN  hive_sql_zg5.course_info t3 ON t1.course_id = t3.course_id
;



-- todo：5.2、多表连接
-- 1）、查询学过“李体音”老师所教的所有课的同学的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- b. 老师所带课程
            SELECT course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师id
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
        GROUP BY stu_id
        HAVING count(course_id) = (
            -- b. 老师所带课程
            SELECT
                count(course_id) AS course_count
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师id
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
    )
SELECT
    t1.stu_id, t2.stu_name
FROM tmp1 t1
    LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;



-- 2）、查询学过“李体音”老师所讲授的任意一门课程的学生的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- b. 老师所带课程
            SELECT course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师id
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
        GROUP BY stu_id
    )
SELECT
    t1.stu_id, t2.stu_name
FROM tmp1 t1
         LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;


-- 3）、查询没学过"李体音"老师讲授的任一门课程的学生姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- b. 老师所带课程
            SELECT course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师id
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
        GROUP BY stu_id
    )
    , tmp2 AS (
        SELECT stu_id
        FROM hive_sql_zg5.score_info
        WHERE stu_id NOT IN (
            SELECT tmp1.stu_id FROM tmp1
        )
        GROUP BY stu_id
    )
SELECT
    t1.stu_id, t2.stu_name
FROM tmp2 t1
LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;

-- 4）、查询至少有一门课与学号为“001”的学生所学课程相同的学生的学号和姓名；
SELECT
    DISTINCT stu_id
FROM hive_sql_zg5.score_info
WHERE course_id IN (
        -- a. “001”的学生所学课程
        SELECT course_id FROM hive_sql_zg5.score_info WHERE stu_id = '001'
    )
;

-- 5）、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩；
SELECT
    stu_id
    , collect_list(
        concat(course_id, '=', score)
    ) AS all_score
    , round(avg(score), 2) AS score_avg
FROM hive_sql_zg5.score_info
GROUP BY stu_id
ORDER BY score_avg DESC
;


SELECT
    stu_id, course_id, score
    -- 每个学生所有成绩的平均成绩
    , round(
        avg(score) OVER (PARTITION BY stu_id)
        , 2
    )  AS avg_score
FROM hive_sql_zg5.score_info
ORDER BY avg_score DESC
;
