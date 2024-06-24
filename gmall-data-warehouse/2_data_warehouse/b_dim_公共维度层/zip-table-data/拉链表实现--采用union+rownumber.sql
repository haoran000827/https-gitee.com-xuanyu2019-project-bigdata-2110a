
WITH
    old_data AS (
        -- 1. 获取用户维度表中，历史用户数据6.18
        SELECT
            id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
             , start_date, end_date
             , dt
        FROM gmall.dim_user_zip
        WHERE dt = '9999-12-31'
    )
   , new_data AS (
    -- 2. ODS层，增量同步数据6.19
    SELECT
        id, login_name, nick_name, md5(name) AS name, md5(phone_num) AS phone_num, md5(email) AS email
         , user_level, birthday, gender, create_time, operate_time
         , '2024-06-19' AS start_date, '9999-12-31' AS end_date
         , '9999-12-31' AS dt
    FROM gmall.ods_user_info_inc
    WHERE dt = '2024-06-19'
)
   , unin_data AS (
    -- 3. 合并所有数据
    SELECT * FROM old_data
    UNION
    SELECT * FROM new_data
)
   , rank_data AS (
    SELECT
        id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
         , row_number() over (partition by id order by start_date desc) AS rk
             , start_date, end_date, dt
    FROM unin_data
)
SELECT
    id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
     , start_date
     , if(rk = 1, end_date, date_sub('2024-06-19', 1)) AS end_date
     , if(rk = 1, end_date, date_sub('2024-06-19', 1)) AS dt
FROM rank_data
;

