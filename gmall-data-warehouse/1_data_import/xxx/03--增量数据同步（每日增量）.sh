
# ======================================================================
#                   todo：1. 评论表：comment_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/comment_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    user_id,
    nick_name,
    head_img,
    sku_id,
    spu_id,
    order_id,
    appraise,
    comment_txt,
    create_time,
    operate_time
FROM comment_info
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
      OR date_format(operate_time, '%Y-%m-%d') = '2024-06-19')
      and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：2. 优惠卷领用表：coupon_use（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/coupon_use_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    coupon_id,
    user_id,
    order_id,
    coupon_status,
    create_time,
    get_time,
    using_time,
    used_time,
    expire_time
FROM coupon_use
WHERE (date_format(get_time, '%Y-%m-%d') = '2024-06-19'
	OR date_format(using_time, '%Y-%m-%d') = '2024-06-19'
	OR date_format(used_time, '%Y-%m-%d') = '2024-06-19'
	OR date_format(expire_time, '%Y-%m-%d') = '2024-06-19')
	AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：3. 收藏表：favor_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/favor_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    user_id,
    sku_id,
    spu_id,
    is_cancel,
    create_time,
    cancel_time
FROM favor_info
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
	OR date_format(cancel_time, '%Y-%m-%d') = '2024-06-19')
	AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：4. 订单明细表：order_detail（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    sku_id,
    sku_name,
    img_url,
    order_price,
    sku_num,
    create_time,
    source_type,
    source_id,
    split_total_amount,
    split_activity_amount,
    split_coupon_amount
FROM order_detail
WHERE date_format(create_time, '%Y-%m-%d') = '2024-06-19' AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#       todo：5. 订单明细活动关联表：order_detail_activity（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_activity_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    order_detail_id,
    activity_id,
    activity_rule_id,
    sku_id,
    create_time
FROM order_detail_activity
WHERE date_format(create_time, '%Y-%m-%d') = '2024-06-19' AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



# ======================================================================
#     todo：6. 订单明细优惠卷关联表：order_detail_coupon（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_coupon_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    order_detail_id,
    coupon_id,
    coupon_use_id,
    sku_id,
    create_time
FROM order_detail_coupon
WHERE date_format(create_time, '%Y-%m-%d') = '2024-06-19' AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：7. 订单表：order_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    consignee,
    consignee_tel,
    total_amount,
    order_status,
    user_id,
    payment_way,
    delivery_address,
    order_comment,
    out_trade_no,
    trade_body,
    create_time,
    operate_time,
    expire_time,
    process_status,
    tracking_no,
    parent_order_id,
    img_url,
    province_id,
    activity_reduce_amount,
    coupon_reduce_amount,
    original_total_amount,
    feight_fee,
    feight_fee_reduce,
    refundable_time
FROM order_info
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
  OR date_format(operate_time, '%Y-%m-%d') = '2024-06-19')
  AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#         todo：8. 订单状态日志表：order_status_log（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_status_log_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    order_status,
    operate_time
FROM order_status_log
WHERE date_format(operate_time, '%Y-%m-%d') = '2024-06-19'
  AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



# ======================================================================
#         todo：9. 支付表：payment_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/payment_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    out_trade_no,
    order_id,
    user_id,
    payment_type,
    trade_no,
    total_amount,
    subject,
    payment_status,
    create_time,
    callback_time,
    callback_content
FROM payment_info
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
        OR date_format(callback_time, '%Y-%m-%d') = '2024-06-19'
      ) and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#         todo：10. 退单表：order_refund_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_refund_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    user_id,
    order_id,
    sku_id,
    refund_type,
    refund_num,
    refund_amount,
    refund_reason_type,
    refund_reason_txt,
    refund_status,
    create_time
FROM order_refund_info
WHERE date_format(create_time, '%Y-%m-%d') = '2024-06-19' and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#         todo：11. 退款表：refund_payment（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/refund_payment_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    out_trade_no,
    order_id,
    sku_id,
    payment_type,
    trade_no,
    total_amount,
    subject,
    refund_status,
    create_time,
    callback_time,
    callback_content
FROM refund_payment
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
        OR date_format(callback_time, '%Y-%m-%d') = '2024-06-19')
      and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#         todo：12. 用户表：user_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/user_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT
    id,
    login_name,
    nick_name,
    passwd,
    name,
    phone_num,
    email,
    head_img,
    user_level,
    birthday,
    gender,
    create_time,
    operate_time,
    status
FROM user_info
WHERE (date_format(create_time, '%Y-%m-%d') = '2024-06-19'
        OR date_format(operate_time, '%Y-%m-%d') = '2024-06-19'
      )
      and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'



# ======================================================================
#         todo：13. 加购物车表：cart_info（增量，每一次）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/cart_info_inc/2024-06-19 \
--delete-target-dir \
--query "SELECT id,
       user_id,
       sku_id,
       cart_price,
       sku_num,
       img_url,
       sku_name,
       is_checked,
       create_time,
       operate_time,
       is_ordered,
       order_time,
       source_type,
       source_id
FROM cart_info
WHERE date_format(create_time, '%Y-%m-%d') = '2024-06-19'
  AND \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'