
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 2.1、分组
-- 1）、查询各科成绩最高和最低的分，以如下的形式显示：课程号，最高分，最低分；
SELECT
    course_id
    , max(score) AS max_score
    , min(score) AS min_score
FROM hive_sql_zg5.score_info
GROUP BY course_id
;


-- 2）、查询每门课程有多少学生参加了考试（有考试成绩）；
SELECT
    course_id
    , count(stu_id) AS stu_count
FROM hive_sql_zg5.score_info
WHERE score > 0
GROUP BY course_id
;


-- 3）、查询男生、女生人数；
SELECT
    sex
    , count(stu_id) AS sex_count
FROM hive_sql_zg5.student_info
GROUP BY sex
;


SELECT
    sum(if(sex = '男', 1, 0)) AS male_count
    , sum(if(sex = '女', 1, 0)) AS female_count
FROM hive_sql_zg5.student_info
;


-- todo：2.2、分组结果的条件
-- 1）、查询平均成绩大于60分的学生的学号和平均成绩；
SELECT
    stu_id
    , round(avg(score), 2) AS avg_score
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING round(avg(score), 2) > 60
;

SELECT
    stu_id
     , cast(avg(score) AS DECIMAL(16, 2)) AS avg_score
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING round(avg(score), 2) > 60
;

/*
    todo 查询每门成绩都及格学生  -> 最小成绩 > 60
*/
SELECT
    stu_id
    , collect_list(score) AS score_list
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING min(score) > 60
;


-- 2）、查询至少选修四门课程的学生学号；
SELECT
    stu_id
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING count(course_id) >= 4
;

-- 3）、查询同姓（假设每个学生姓名的第一个字为姓）的学生名单并统计同姓人数大于2的姓；
SELECT
    substring(stu_name, 1, 1) AS first_name
FROM hive_sql_zg5.student_info
GROUP BY substring(stu_name, 1, 1)
HAVING count(stu_id) >= 2
;

-- todo 函数
DESC FUNCTION substring;
/*
substring(str, pos[, len])
    - returns the substring of str that starts at pos and is of length len or substring(bin, pos[, len])
    - returns the slice of byte array that starts at pos and is of length len
*/
SELECT
    substring("郭培华", 0, 1) AS x1
    , substring("郭培华", 1, 1) AS x2
;

-- todo 查看内置函数有哪些
SHOW FUNCTIONS  ;

-- 4）、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列；
SELECT
    course_id
    , cast(avg(score) AS DECIMAL(16, 2)) AS avg_score
FROM hive_sql_zg5.score_info
GROUP BY course_id
ORDER BY avg_score ASC, course_id DESC
;


-- 5）、统计参加考试人数大于等于15的学科；
SELECT
    course_id
    , count(stu_id) AS stu_count
    , collect_list(stu_id) AS stu_list
FROM hive_sql_zg5.score_info
GROUP BY course_id
HAVING count(stu_id) >= 15
;


