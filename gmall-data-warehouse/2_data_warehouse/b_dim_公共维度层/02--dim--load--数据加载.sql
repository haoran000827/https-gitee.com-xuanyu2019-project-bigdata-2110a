

-- todo 数据加载： 1 商品维度表


-- todo 数据加载： 2 优惠券维度表


-- todo 数据加载： 3 活动维度表


-- todo 数据加载： 4. 地区维度表
/*
    数据来源于：
        ods_base_province（全量） 和  ods_base_region（全量） 合并
*/
SET hive.stats.autogather=false;
WITH
    -- a. 省份数据
    province AS (
        SELECT
            id,
            name,
            region_id,
            area_code,
            iso_code,
            iso_3166_2
        FROM gmall.ods_base_province_full
        WHERE dt = '2024-04-18'
    ),
    -- b. 地区数据
    region AS (
        SELECT
            id,
            region_name
        FROM gmall.ods_base_region_full
        WHERE dt = '2024-04-18'
    )
INSERT OVERWRITE TABLE gmall.dim_province_full PARTITION(dt = '2024-04-18')
-- c. 省份数据关联地区数据，按照region_id关联
SELECT
    province.id,
    province.name,
    province.area_code,
    province.iso_code,
    province.iso_3166_2,
    region_id,
    region_name
FROM province
LEFT JOIN region ON province.region_id = region.id;

-- 测试
SHOW PARTITIONS gmall.dim_province_full;
SELECT * FROM gmall.dim_province_full WHERE dt = '2024-04-18' LIMIT 10 ;



-- todo 数据加载： 5 日期维度表
/*
    数据来源于：
        通常情况下，时间维度表的数据并不是来自于业务系统，而是手动写入，并且由于时间维度表数据的可预见性，
    无须每日导入，一般可一次性导入一年的数据。
*/
--（1）创建临时表
DROP TABLE IF EXISTS gmall.tmp_dim_date_info;
CREATE TABLE gmall.tmp_dim_date_info (
    `date_id` STRING COMMENT '日',
    `week_id` STRING COMMENT '周ID',
    `week_day` STRING COMMENT '周几',
    `day` STRING COMMENT '每月的第几天',
    `month` STRING COMMENT '第几月',
    `quarter` STRING COMMENT '第几季度',
    `year` STRING COMMENT '年',
    `is_workday` STRING COMMENT '是否是工作日',
    `holiday_id` STRING COMMENT '节假日'
) COMMENT '时间维度表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/tmp/tmp_dim_date_info/';

-- （2）将数据文件上传到HFDS上临时表路径/warehouse/gmall/tmp/tmp_dim_date_info
-- hdfs dfs -put date_info.txt /warehouse/gmall/tmp/tmp_dim_date_info/

--（3）执行以下语句将其导入时间维度表
INSERT OVERWRITE TABLE gmall.dim_date
SELECT date_id,
       week_id,
       week_day,
       day,
       month,
       quarter,
       year,
       is_workday,
       holiday_id
FROM gmall.tmp_dim_date_info;

-- 测试
SELECT * FROM gmall.dim_date ;



-- todo 数据加载： 6 用户维度表

