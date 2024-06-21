
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 3.1、查询结果排序&分组指定条件
-- 1）、查询学生的总成绩并按照总成绩降序排序；
SELECT
    stu_id
    , sum(score) AS score_sum
FROM hive_sql_zg5.score_info
GROUP BY stu_id
ORDER BY score_sum DESC
;


-- 2）、按如下格式显示学生的语文、数学、英语三科成绩，没有成绩的输出为0，按照学生的有效平均成绩降序显示；
-- 学生id 语文 数学 英语 有效课程数 有效平均成绩
-- 001    98   80  60    3       83
-- 002    85   90  0     2       87.5
WITH
    tmp1 AS (
        SELECT
            t1.*
            , t2.course_name
        FROM hive_sql_zg5.score_info t1
        LEFT JOIN hive_sql_zg5.course_info t2 ON t1.course_id = t2.course_id
    )
SELECT
    stu_id AS `学生id`
    , sum(if(course_name = '语文', score, 0.0)) AS `语文`
    , sum(if(course_name = '数学', score, 0.0)) AS `数学`
    , sum(if(course_name = '英语', score, 0.0)) AS `英语`
    , sum(if(score > 0, 1, 0)) AS `有效课程数`
    , cast(avg(score) AS DECIMAL(16, 2)) AS `有效平均成绩`
FROM tmp1
GROUP BY stu_id
ORDER BY `有效平均成绩` DESC
;


-- 3）、查询一共参加三门课程且其中一门为语文课程的学生的id和姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
             -- 课程数目
             , count(course_id) AS course_count
             -- 课程名称
             , collect_list(course_id) AS all_course
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
    )
    , tmp2 AS (
        SELECT
            stu_id
        FROM tmp1
        WHERE course_count = 3
          AND array_contains(
                all_course,
                (SELECT course_id FROM hive_sql_zg5.course_info WHERE course_name = '语文')
            )
    )
SELECT
    t1.stu_id, t2.stu_name
FROM tmp2 t1
LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;

DESC FUNCTION array_contains;
/*
array_contains(array, value) - Returns TRUE if the array contains value.
*/
SELECT `array`(1, 2, 3, 4, 5)
    , array_contains(
        `array`(1, 2, 3, 4, 5), 4
    )
    , array_contains(
        `array`(1, 2, 3, 4, 5), 10
    )
    ;

-- todo：3.2、子查询
-- 1）、查询所有课程成绩均小于60分的学生的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
            , collect_list(score) AS score_list
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
        HAVING max(score) < 60
    )
SELECT
    t1.stu_id, t2.stu_name
    , score_list
FROM tmp1 t1
LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;

-- 2）、查询没有学全所有课的学生的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id, count(course_id) AS course_count
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
    )
    , tmp2 AS (
        SELECT
            stu_id
        FROM tmp1
        WHERE course_count < (
            SELECT count(course_id) AS cnt FROM hive_sql_zg5.course_info
        )
    )
SELECT
    tt2.stu_id, tt3.stu_name
FROM tmp2 tt2
         LEFT JOIN hive_sql_zg5.student_info tt3 ON tt2.stu_id = tt3.stu_id
;


-- 3）、查询出只选修了三门课程的全部学生的学号和姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        GROUP BY stu_id
        HAVING count(course_id) = 3
    )
SELECT
    t1.stu_id, t2.stu_name
FROM tmp1 t1
         LEFT JOIN hive_sql_zg5.student_info t2 ON t1.stu_id = t2.stu_id
;



