
-- 创建数据库
CREATE DATABASE IF NOT EXISTS gmall ;
-- 使用数据库
USE gmall;


-- todo 1. 编码字典表：base_dic（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_dic_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_dic_full PARTITION (dt = '2024-06-18');

-- todo 2. 品牌表：base_trademark（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_trademark_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_trademark_full PARTITION (dt = '2024-06-18');

-- todo 3. 三级分类表：base_category3（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_category3_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_category3_full PARTITION (dt = '2024-06-18');

-- todo 4. 二级分类表：base_category2（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_category2_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_category2_full PARTITION (dt = '2024-06-18');

-- todo 5. 一级分类表：base_category1（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_category1_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_category1_full PARTITION (dt = '2024-06-18');

-- todo 6. 库存单元表（商品信息表）：sku_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/sku_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_sku_info_full PARTITION (dt = '2024-06-18');

-- todo 7. 商品表：spu_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/spu_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_spu_info_full PARTITION (dt = '2024-06-18');

-- todo 8. 活动表：activity_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/activity_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_activity_info_full PARTITION (dt = '2024-06-18');

-- todo 9. 优惠规则：activity_rule（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/activity_rule_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_activity_rule_full PARTITION (dt = '2024-06-18');

-- todo 10. 购物车表：cart_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/cart_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_cart_info_full PARTITION (dt = '2024-06-18');

-- todo 11.  优惠券表：coupon_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/coupon_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_coupon_info_full PARTITION (dt = '2024-06-18');

-- todo 12. sku平台属性值关联表：sku_attr_value（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/sku_attr_value_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_sku_attr_value_full PARTITION (dt = '2024-06-18');

-- todo 13. sku销售属性值：sku_sale_attr_value（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/sku_sale_attr_value_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_sku_sale_attr_value_full PARTITION (dt = '2024-06-18');

-- todo 14. 省份表：base_province（一次全量加载）
LOAD DATA INPATH '/origin_data/gmall/base_province_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_province_full PARTITION (dt = '2024-06-18');

-- todo 15. 区域表：base_region（一次全量加载）
LOAD DATA INPATH '/origin_data/gmall/base_region_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_base_region_full PARTITION (dt = '2024-06-18');

-- todo: 1.订单详情表：order_detail（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_detail_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_detail_inc PARTITION (dt = '2024-06-18');

-- todo 2.退单表：order_refund_info（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_refund_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_refund_info_inc PARTITION (dt = '2024-06-18');

-- todo 3.订单状态日志表：order_status_log（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_status_log_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_status_log_inc PARTITION (dt = '2024-06-18');

-- todo 4.订单明细活动关联表：order_detail_activity（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_detail_activity_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_detail_activity_inc PARTITION (dt = '2024-06-18');

-- todo 5.订单明细购物券表：order_detail_coupon（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_detail_coupon_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_detail_coupon_inc PARTITION (dt = '2024-06-18');

-- todo 6.商品评论表：comment_info（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/comment_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_comment_info_inc PARTITION (dt = '2024-06-18');

-- todo 7. 商品收藏表：favor_info（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/favor_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_favor_info_inc PARTITION (dt = '2024-06-18');

-- todo 8.订单表：order_info（每日，新增变化）
LOAD DATA INPATH '/origin_data/gmall/order_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_info_inc PARTITION (dt = '2024-06-18');

-- todo 9.优惠券领用表：coupon_use（每日，新增变化）
LOAD DATA INPATH '/origin_data/gmall/coupon_use_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_coupon_use_inc PARTITION (dt = '2024-06-18');

-- todo 10.用户表：user_info（每日，新增变化）
LOAD DATA INPATH '/origin_data/gmall/user_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_user_info_inc PARTITION (dt = '2024-06-18');

-- todo 11.支付信息表：payment_info（每日，新增变化）
LOAD DATA INPATH '/origin_data/gmall/payment_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_payment_info_inc PARTITION (dt = '2024-06-18');

-- todo 12.退款信息表：refund_payment（每日，新增变化）
LOAD DATA INPATH '/origin_data/gmall/refund_payment_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_refund_payment_inc PARTITION (dt = '2024-06-18');

-- todo 13. 购物车表：cart_info（每日，新增）
LOAD DATA INPATH '/origin_data/gmall/cart_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_cart_info_inc PARTITION (dt = '2024-06-18');

-- todo 1. app日志数据：
LOAD DATA INPATH '/origin_data/gmall/log/2024-04-19'
    OVERWRITE INTO TABLE gmall.ods_log_inc partition(dt='2024-04-19');



LOAD DATA INPATH '/origin_data/gmall/log/2024-04-21'
    OVERWRITE INTO TABLE gmall.ods_log_inc partition(dt='2024-04-21');
SHOW PARTITIONS gmall.ods_log_inc;

ALTER TABLE gmall.ods_log_inc DROP PARTITION (dt = '2024-04-21');
