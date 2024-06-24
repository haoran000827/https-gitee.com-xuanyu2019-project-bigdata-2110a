

-- todo 数据加载： 1 商品维度表
/*
    数据来源于：
        主维表：ods_sku_info
        相关维表：ods_spu_info、ods_base_category3、ods_base_category2、ods_base_category1、
                ods_base_trademark、ods_sku_attr_value、ods_sku_sale_attr_value
*/
WITH
    -- a. SKU商品信息表
    sku AS
        (
            SELECT
                id,
                price,
                sku_name,
                sku_desc,
                weight,
                is_sale,
                spu_id,
                category3_id,
                tm_id,
                create_time
            FROM gmall.ods_sku_info_full
            WHERE dt = '2024-06-18'
        ),
    -- b. SPU商品信息表
    spu AS
        (
            SELECT
                id,
                spu_name
            FROM gmall.ods_spu_info_full
            WHERE dt = '2024-06-18'
        ),
    -- c. 三级品类表
    c3 AS
        (
            SELECT
                id,
                name,
                category2_id
            FROM gmall.ods_base_category3_full
            WHERE dt = '2024-06-18'
        ),
    -- c. 二级品类表
    c2 AS
        (
            SELECT
                id,
                name,
                category1_id
            FROM gmall.ods_base_category2_full
            WHERE dt = '2024-06-18'
        ),
    -- d. 一级品类表
    c1 AS
        (
            SELECT
                id,
                name
            FROM gmall.ods_base_category1_full
            WHERE dt='2024-06-18'
        ),
    -- e. 品牌表
    tm AS
        (
            SELECT
                id,
                tm_name
            FROM gmall.ods_base_trademark_full
            WHERE dt='2024-06-18'
        ),
    -- f. sku商品平台属性表
    attr AS
        (
            SELECT
                sku_id,
                collect_set(
                    named_struct('attr_id',attr_id,'value_id',value_id,'attr_name',
                        attr_name,'value_name',value_name)
                ) AS attrs
            FROM gmall.ods_sku_attr_value_full
            WHERE dt='2024-06-18'
            GROUP BY sku_id
        ),
    -- g. sku商品销售平台属性表
    sale_attr AS
        (
            SELECT
                sku_id,
                collect_set(
                    named_struct('sale_attr_id',sale_attr_id,'sale_attr_value_id',sale_attr_value_id,
                        'sale_attr_name',sale_attr_name,'sale_attr_value_name',sale_attr_value_name)
                ) AS sale_attrs
            FROM gmall.ods_sku_sale_attr_value_full
            WHERE dt='2024-06-18'
            GROUP BY sku_id
        )
INSERT OVERWRITE TABLE gmall.dim_sku_full PARTITION(dt = '2024-06-18')
-- h. 以sku商品为主表，left join关联其他表
SELECT
    sku.id,
    sku.price,
    sku.sku_name,
    sku.sku_desc,
    sku.weight,
    sku.is_sale,
    sku.spu_id,
    spu.spu_name,
    sku.category3_id,
    c3.name,
    c3.category2_id,
    c2.name,
    c2.category1_id,
    c1.name,
    sku.tm_id,
    tm.tm_name,
    attr.attrs,
    sale_attr.sale_attrs,
    sku.create_time
FROM sku
LEFT JOIN spu ON sku.spu_id = spu.id
LEFT JOIN c3 ON sku.category3_id = c3.id
LEFT JOIN c2 ON c3.category2_id = c2.id
LEFT JOIN c1 ON c2.category1_id = c1.id
LEFT JOIN tm ON sku.tm_id = tm.id
LEFT JOIN attr ON sku.id = attr.sku_id
LEFT JOIN sale_attr ON sku.id = sale_attr.sku_id;

-- 查询数据
SHOW PARTITIONS gmall.dim_sku_full;
SELECT * FROM gmall.dim_sku_full WHERE dt = '2024-06-18' LIMIT 10 ;

-- todo 数据加载： 2 优惠券维度表
/*
    数据来源于：
        优惠卷信息表 关联 字典表中维度属性值
*/
SET hive.stats.autogather=false;
WITH
    -- a. 优惠卷信息表
    ci AS (
        SELECT
            id,
            coupon_name,
            coupon_type,
            condition_amount,
            condition_num,
            activity_id,
            benefit_amount,
            benefit_discount,
            create_time,
            range_type,
            limit_num,
            taken_count,
            start_time,
            end_time,
            operate_time,
            expire_time
        FROM gmall.ods_coupon_info_full
        WHERE dt='2024-06-18'
    ),
    -- b. 购物券类型字典数据
    coupon_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-18' AND parent_code = '32'
    ),
    -- c. 优惠券范围字典数据
    range_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-18' AND parent_code = '33'
    )
INSERT OVERWRITE TABLE gmall.dim_coupon_full PARTITION(dt = '2024-06-18')
-- d. 优惠卷信息表，关联字段表，并且转换类型值
SELECT
    id,
    coupon_name,
    coupon_type,
    coupon_dic.dic_name,
    condition_amount,
    condition_num,
    activity_id,
    benefit_amount,
    benefit_discount,
    -- 优惠类型
    case coupon_type
        WHEN '3201' THEN concat('满', condition_amount, '元减', benefit_amount, '元')
        WHEN '3202' THEN concat('满', condition_num, '件打', 10 * (1 - benefit_discount), '折')
        WHEN '3203' THEN concat('减', benefit_amount, '元')
    end AS benefit_rule,
    create_time,
    range_type,
    range_dic.dic_name,
    limit_num,
    taken_count,
    start_time,
    end_time,
    operate_time,
    expire_time
FROM ci
LEFT JOIN coupon_dic ON ci.coupon_type = coupon_dic.dic_code
LEFT JOIN range_dic ON ci.range_type = range_dic.dic_code;

-- 查询
SHOW PARTITIONS gmall.dim_coupon_full;
SELECT * FROM gmall.dim_coupon_full WHERE dt = '2024-06-18' LIMIT 10 ;


-- todo 数据加载： 3 活动维度表
/*
    数据来源于：
        活动规则表 关联 活动信息表和字典属性数据
*/
SET hive.stats.autogather=false;
WITH
     -- a. 活动规则表
     rule AS (
         SELECT
             id,
             activity_id,
             activity_type,
             condition_amount,
             condition_num,
             benefit_amount,
             benefit_discount,
             benefit_level
         FROM gmall.ods_activity_rule_full
         WHERE dt='2024-06-18'
     ),
     -- b. 活动信息表
     info AS (
         SELECT
             id,
             activity_name,
             activity_type,
             activity_desc,
             start_time,
             end_time,
             create_time
         FROM gmall.ods_activity_info_full
         WHERE dt = '2024-06-18'
     ),
     -- c. 活动类型字典数据
     dic AS (
         SELECT
             dic_code,
             dic_name
         FROM gmall.ods_base_dic_full
         WHERE dt = '2024-06-18' AND parent_code = '31'
     )
INSERT OVERWRITE TABLE gmall.dim_activity_full PARTITION(dt = '2024-06-18')
-- d. 活动规则 关联 活动信息 和 字段属性数据
SELECT
    rule.id,
    info.id,
    activity_name,
    rule.activity_type,
    dic.dic_name,
    activity_desc,
    start_time,
    end_time,
    create_time,
    condition_amount,
    condition_num,
    benefit_amount,
    benefit_discount,
    case rule.activity_type
        WHEN '3101' THEN concat('满',condition_amount,'元减',benefit_amount,'元')
        WHEN '3102' THEN concat('满',condition_num,'件打',10*(1-benefit_discount),'折')
        WHEN '3103' THEN concat('打',10*(1-benefit_discount),'折')
    end AS benefit_rule,
    benefit_level
FROM rule
LEFT JOIN info ON rule.activity_id = info.id
LEFT JOIN dic ON rule.activity_type = dic.dic_code;

-- 查询
SHOW PARTITIONS gmall.dim_activity_full;
SELECT * FROM gmall.dim_activity_full WHERE dt = '2024-06-18' LIMIT 10 ;


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
        WHERE dt = '2024-06-18'
    ),
    -- b. 地区数据
    region AS (
        SELECT
            id,
            region_name
        FROM gmall.ods_base_region_full
        WHERE dt = '2024-06-18'
    )
INSERT OVERWRITE TABLE gmall.dim_province_full PARTITION(dt = '2024-06-18')
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
SELECT * FROM gmall.dim_province_full WHERE dt = '2024-06-18' LIMIT 10 ;



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
-- 1. 以前日期维度数据获取（历史数据）
SELECT * FROM gmall.dim_date
UNION
-- 2. 当年的日期数据
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
SELECT * FROM gmall.dim_date WHERE date_format(date_id, 'yyyy') = '2024';



-- todo 数据加载： 6 用户维度表
/*
    数据来源于：用户表ods_user_info
    1）、首日数据加载（历史加载）
        将所有数据放入最大分区：9999-12-31
    2）、每日数据加载
        每天新增和修改数据，写入最大分区：9999-12-31
        每天过期数据（被修改老数据），写入当日分区：2024-03-25
        |
        使用动态分区方式将数据插入到用户维度表：dim_user_zip
*/
-- todo 首日装载（第一次）
SET hive.stats.autogather=false;
INSERT OVERWRITE TABLE gmall.dim_user_zip PARTITION (dt = '9999-12-31')
SELECT
    id,
    login_name,
    nick_name,
    md5(name) AS name,
    md5(phone_num) AS phone_num,
    md5(email) AS email,
    user_level,
    birthday,
    gender,
    create_time,
    operate_time,
    '2024-06-18' AS start_date,
    '9999-12-31' AS end_date
FROM gmall.ods_user_info_inc
WHERE dt = '2024-06-18';

-- 查询
SHOW PARTITIONS gmall.dim_user_zip;
SELECT * FROM gmall.dim_user_zip WHERE dt = '9999-12-31' LIMIT 10;

-- todo 每日装载（每一次）
/*
启动态分区，设置为非严格模式
-- 表示每个maper或reducer可以允许创建的最大动态分区个数，默认是100，超出则会报错。
set hive.exec.max.dynamic.partitions.pernode=100 （默认100）
-- 最大动态分区个数，超出报错。
set hive.exec.max.dynamic.partitions=1000 (默认值)
-- 全局可以创建的最大文件个数，超出报错。
set hive.exec.max.created.files=10000 (默认)
*/
SET hive.stats.autogather=false;
-- 启用Hive中动态分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
WITH
    -- a. 以前用户数据（老数据）
    old_data AS (
        SELECT
            id,
            login_name,
            nick_name,
            name,
            phone_num,
            email,
            user_level,
            birthday,
            gender,
            create_time,
            operate_time,
            start_date,
            end_date
        FROM gmall.dim_user_zip
        WHERE dt = '9999-12-31'
    ),
    -- b. 新增和修改用户数据（新数据）
    new_data AS (
        SELECT
            id,
            login_name,
            nick_name,
            md5(name) AS name,
            md5(phone_num) AS phone_num,
            md5(email) AS email,
            user_level,
            birthday,
            gender,
            create_time,
            operate_time,
            '2024-06-19' AS start_date,
            '9999-12-31' AS end_date
        FROM gmall.ods_user_info_inc
        WHERE dt = '2024-06-19'
    ),
    -- c. 老数据 union 新数据
    unin_data AS (
        SELECT * FROM old_data
        UNION
        SELECT * FROM new_data
    ),
    -- d. 每条数据加上序号
    rank_data AS (
        SELECT
            *,
            row_number() OVER (PARTITION BY id ORDER BY start_date DESC) AS rnk
        FROM unin_data
    )
INSERT OVERWRITE TABLE gmall.dim_user_zip partition(dt)
-- f. 当序号不为1时，修改end_date为数据过期日期和分区dt字段值
SELECT
    id, login_name, nick_name, name, phone_num, email, user_level, birthday, gender, create_time, operate_time
    , start_date
    , if(rnk = 1, end_date, date_sub('2024-06-19', 1)) AS  end_date
    , if(rnk = 1, end_date, date_sub('2024-06-19', 1)) AS  dt
FROM rank_data
;


