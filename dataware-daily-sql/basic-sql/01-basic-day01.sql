
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

/*
数据分析中，数据调研：数据有哪些（表有哪些，如何产生的数据，核心数据：业务过程）
    course_info 课程表
    student_info 学生表
    teacher_info 教师表
        维度表，环境
    score_info  成绩表
        事实表，学生学习某个课程，并且考试产生的数据
		分析数据，往往分析就是事实表的数据，此处就是score_info表
*/

-- todo: 1.1、简单查询
-- 1）、检索课程编号为“04”且分数小于60的学生的课程信息，结果按分数降序排列；
WITH
    -- step1. 课程编号为“04”且分数小于60的学生
    tmp1 AS (
        SELECT
            stu_id
             , course_id
             , score
        FROM hive_sql_zg5.score_info
        WHERE course_id = '04' AND score < 60
    )
-- step2. 关联课程表
SELECT
    t1.stu_id
    , t1.course_id
    , t1.score
    , t2.course_name
FROM tmp1 t1
LEFT JOIN hive_sql_zg5.course_info t2 ON t1.course_id = t2.course_id
ORDER BY t1.score DESC
;

-- 2）、查询数学成绩不及格的学生和其对应的成绩，按照学号升序排序；
-- step2. 过滤获取数据，并且排序
SELECT
    stu_id
    , course_id
    , score
FROM hive_sql_zg5.score_info
WHERE score < 60 AND course_id = (
        -- step1. 获取数学课程ID
        SELECT course_info.course_id FROM hive_sql_zg5.course_info WHERE course_name = '数学'
    )
ORDER BY stu_id
;


-- 3）、查询姓名中带“冰”的学生名单；
SELECT
    stu_id, stu_name
FROM hive_sql_zg5.student_info
WHERE stu_name LIKE  '%冰%'
;

-- 4）、查询姓“王”老师的个数；
SELECT
    count(tea_id) AS teacher_count
FROM hive_sql_zg5.teacher_info
WHERE tea_name like '王%'
;

-- todo：1.2、汇总分析
/*
	SQL分析中，5个基本聚合函数使用
		count 计数
		sum 求和
		avg 均值
		max 最大
		min 最小
*/
-- 1）、查询编号为“02”的课程的总成绩；
SELECT
    sum(score) AS sum_score
FROM hive_sql_zg5.score_info
WHERE course_id = '02'
;


-- 2）、查询参加考试的学生个数；
SELECT
    count(DISTINCT stu_id) AS stu_count
FROM hive_sql_zg5.score_info
;

-- todo 当数据量很大时，上述SQL容易产生数据倾斜，因为使用count distinct只有1个Reduce任务，采用group by + count优化
/*
    案例剖析：https://blog.51cto.com/u_16099335/6687050
*/
SELECT
    count(stu_id) AS stu_count
FROM (
    -- a. 去重：group by
     SELECT
         stu_id
     FROM hive_sql_zg5.score_info
     GROUP BY stu_id
) t1
;



/**
-- 查询日志
[bwie@node101 ~]$ hv.sh beeline
    执行SQL语句，查看运行日志

-- 查询计划
explain SELECT ....
*/
explain SELECT
            count(DISTINCT stu_id) AS stu_count
        FROM hive_sql_zg5.score_info
;














