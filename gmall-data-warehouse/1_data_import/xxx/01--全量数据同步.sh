
# ======================================================================
#                   todo：1. 活动信息表：activity_info（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/activity_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    activity_name,
    activity_type,
    activity_desc,
    start_time,
    end_time,
    create_time
FROM activity_info
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：2. 活动信息表：activity_rule（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/activity_rule_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    activity_id,
    activity_type,
    condition_amount,
    condition_num,
    benefit_amount,
    benefit_discount,
    benefit_level
FROM activity_rule
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：3. 一级品类表：base_category1（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_category1_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    name
FROM base_category1
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：4. 二级品类表：base_category2（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_category2_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    name,
    category1_id
FROM base_category2
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：5. 三级品类表：base_category3（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_category3_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    name,
    category2_id
FROM base_category3
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：6. 编码字典表：base_dic（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_dic_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  dic_code,
  dic_name,
  parent_code,
  create_time,
  operate_time
FROM base_dic
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：7. 省份表：base_province（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_province_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    name,
    region_id,
    area_code,
    iso_code,
    iso_3166_2
FROM base_province
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：8. 地区表：base_region（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_region_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    region_name
FROM base_region
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：9. 品牌表：base_trademark（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_trademark_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    tm_name,
    logo_url
FROM base_trademark
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：10. 购物车表：cart_info（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/cart_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
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
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：11. 优惠卷信息表：coupon_info（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/coupon_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
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
    expire_time,
    range_desc
FROM coupon_info
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：12. 商品平台属性表：sku_attr_value（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_attr_value_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    attr_id,
    value_id,
    sku_id,
    attr_name,
    value_name
FROM sku_attr_value
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：13. 商品销售属性表：sku_sale_attr_value（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_sale_attr_value_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    sku_id,
    spu_id,
    sale_attr_value_id,
    sale_attr_id,
    sale_attr_name,
    sale_attr_value_name
FROM sku_sale_attr_value
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：14. 商品表sku：sku_info（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    spu_id,
    price,
    sku_name,
    sku_desc,
    weight,
    tm_id,
    category3_id,
    sku_default_img,
    is_sale,
    create_time
FROM sku_info
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


# ======================================================================
#                   todo：15. SPU表：spu_info（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    spu_name,
    description,
    category3_id,
    tm_id
FROM spu_info
WHERE 1 = 1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'


