
-- todo 首日数据加载，开启动态分区
-- 开启动态分区
SET hive.exec.dynamic.partition=true;
-- 非严格模式：允许所有分区都是动态的
SET hive.exec.dynamic.partition.mode=nonstrict;

-- todo 1 交易域-加购-事务事实表
/*
    主表：
        加购物车增量表ods_cart_info_inc
    相关表：
        字典表数据ods_base_dic_full
*/
-- （1）首日装载
WITH
    -- a. 加购物车表
    cart AS (
        SELECT
            id,
            user_id,
            sku_id,
            create_time,
            source_id,
            source_type,
            sku_num
        FROM gmall.ods_cart_info_inc
        WHERE dt = '2024-06-18'
    ),
    -- b. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-18' AND parent_code='24'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_cart_add_inc PARTITION (dt)
SELECT
    id
    , user_id
    , sku_id
    , date_format(create_time,'yyyy-MM-dd') AS date_id
    , create_time
    , source_id
    , source_type AS source_type_code
    , dic.dic_name AS source_type_name
    , sku_num
    , date_format(create_time, 'yyyy-MM-dd') AS dt
FROM cart
LEFT JOIN dic ON cart.source_type = dic.dic_code;

-- 查询
SHOW PARTITIONS gmall.dwd_trade_cart_add_inc ;
SELECT * FROM gmall.dwd_trade_cart_add_inc WHERE dt = '2024-06-18' LIMIT 10;

--（2）每日装载
WITH
    -- a. 加购物车表
    cart AS (
        SELECT
            id,
            user_id,
            sku_id,
            if(operate_time IS NOT NULL, operate_time, create_time) AS create_time,
            date_format(if(operate_time IS NOT NULL, operate_time, create_time),'yyyy-MM-dd') AS date_id,
            source_id,
            source_type,
            sku_num
        FROM gmall.ods_cart_info_inc
        WHERE dt = '2024-06-19'
    ),
    -- b. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-19' AND parent_code='24'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_cart_add_inc PARTITION (dt = '2024-06-19')
SELECT
    id,
    user_id,
    sku_id,
    date_id,
    create_time,
    source_id,
    source_type,
    dic.dic_name,
    sku_num
FROM cart
    LEFT JOIN dic ON cart.source_type = dic.dic_code;


-- todo 2 交易域-下单-事务事实表
/*
    主表：
        订单明细表 ods_order_detail_inc
    相关表：
        订单信息表ods_order_info_inc
        订单明细活动关联表ods_order_detail_activity_inc
        订单明细优惠关联表ods_order_detail_coupon_inc
        字典表ods_base_dic_full
*/
-- （1）首日装载
WITH
     -- a. 订单明细数据
     detail AS (
         SELECT
             id,
             order_id,
             sku_id,
             create_time,
             source_id,
             source_type,
             sku_num,
             sku_num * order_price AS split_original_amount,
             split_total_amount,
             split_activity_amount,
             split_coupon_amount
         FROM gmall.ods_order_detail_inc
         WHERE dt = '2024-06-18'
     ),
     -- b. 订单数据
     info AS (
         SELECT
             id,
             user_id,
             province_id
         FROM gmall.ods_order_info_inc
         WHERE dt = '2024-06-18'
     ),
     -- c. 订单明细活动关联表
     activity AS (
         SELECT
             order_detail_id,
             activity_id,
             activity_rule_id
         FROM gmall.ods_order_detail_activity_inc
         WHERE dt = '2024-06-18'
     ),
     -- d. 订单明细优惠卷关联表
     coupon AS (
         SELECT
             order_detail_id,
             coupon_id
         FROM gmall.ods_order_detail_coupon_inc
         WHERE dt = '2024-06-18'
     ),
     -- e. 字典数据
     dic AS (
         SELECT
             dic_code,
             dic_name
         FROM gmall.ods_base_dic_full
         WHERE dt = '2024-06-18' AND parent_code = '24'
     )
INSERT OVERWRITE TABLE gmall.dwd_trade_order_detail_inc PARTITION (dt)
-- f. 订单明细表关联订单info、活动activity、优惠卷coupon、字段dic
SELECT
    detail.id,
    order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time,
    source_id,
    source_type,
    dic_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount,
    date_format(create_time,'yyyy-MM-dd') AS dt
FROM detail
JOIN info ON detail.order_id = info.id
LEFT JOIN activity ON detail.id = activity.order_detail_id
LEFT JOIN coupon ON detail.id = coupon.order_detail_id
LEFT JOIN dic ON detail.source_type = dic.dic_code ;

-- 测试
SHOW PARTITIONS gmall.dwd_trade_order_detail_inc ;
SELECT * FROM gmall.dwd_trade_order_detail_inc WHERE dt = '2024-06-18' LIMIT 10;

-- （2）每日装载
WITH
    -- a. 订单明细数据
    detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            create_time,
            source_id,
            source_type,
            sku_num,
            sku_num * order_price AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM gmall.ods_order_detail_inc
        WHERE dt = '2024-06-19'
    ),
    -- b. 订单数据
    info AS (
        SELECT
            id,
            user_id,
            province_id
        FROM gmall.ods_order_info_inc
        WHERE dt = '2024-06-19'
    ),
    -- c. 订单明细活动关联表
    activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM gmall.ods_order_detail_activity_inc
        WHERE dt = '2024-06-19'
    ),
    -- d. 订单明细优惠卷关联表
    coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM gmall.ods_order_detail_coupon_inc
        WHERE dt = '2024-06-19'
    ),
    -- e. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt='2024-06-19'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_order_detail_inc PARTITION (dt = '2024-06-19')
-- f. 订单明细表关联订单info、活动activity、优惠卷coupon、字段dic
SELECT
    info.id,
    order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time,
    source_id,
    source_type,
    dic_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount
FROM detail
LEFT JOIN info ON detail.order_id = info.id
LEFT JOIN activity ON detail.id = activity.order_detail_id
LEFT JOIN coupon ON detail.id = coupon.order_detail_id
LEFT JOIN dic ON detail.source_type = dic.dic_code;

-- 测试
SHOW PARTITIONS gmall.dwd_trade_order_detail_inc ;
SELECT * FROM gmall.dwd_trade_order_detail_inc WHERE dt = '2024-06-19' LIMIT 10;


-- todo 3. 交易域-支付成功-事务事实表

-- （1）首日装载


-- （2）每日装载


-- todo  4 交易域-购物车-周期快照事实表
/*
    直接从ODS层加购表（全量表）获取数据即可
*/
INSERT OVERWRITE TABLE gmall.dwd_trade_cart_full PARTITION(dt = '2024-06-18')
SELECT
    id,
    user_id,
    sku_id,
    sku_name,
    sku_num
FROM gmall.ods_cart_info_full
WHERE dt = '2024-06-18' and is_ordered = '0';

-- 测试
SHOW PARTITIONS gmall.dwd_trade_cart_full;
SELECT * FROM gmall.dwd_trade_cart_full WHERE dt = '2024-06-18' LIMIT 10 ;


-- todo 5 工具域-优惠券领取-事务事实表
/*
    直接从优惠卷使用增量表获取数据
*/
-- （1）首日装载

-- （2）每日装载


-- todo 6 工具域-优惠券使用(下单)-事务事实表
-- （1）首日装载

-- （2）每日装载


-- todo 7 工具域-优惠券使用(支付)-事务事实表
-- （1）首日装载


-- （2）每日装载


-- todo 8 互动域-收藏商品-事务事实表
-- （1）首日装载

-- （2）每日装载



-- todo 9 互动域-评价-事务事实表
-- （1）首日装载

-- （2）每日装载



-- todo 18 用户域-用户注册-事务事实表
-- （1）首日装载



-- （2）每日装载


-- =========================================================================
-- todo 19 用户域-用户登录-事务事实表
-- =========================================================================

