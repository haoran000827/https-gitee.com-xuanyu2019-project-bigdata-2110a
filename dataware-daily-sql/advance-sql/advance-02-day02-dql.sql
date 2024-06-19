
USE hive_sql_zg6;
SHOW TABLES IN hive_sql_zg6;


-- todo: 1）、每个商品销售首年的年份、销售数量和销售金额
/*
从订单明细表(order_detail)统计每个商品销售首年的年份，销售数量和销售总额。
*/
WITH
-- step1. 计算每个商品每年的销售数量和销售金额
    tmp1 AS (
		SELECT
			sku_id
			-- 销售年份
			, date_format(create_date, 'yyyy') AS sale_year
			-- 销售数量
			, sum(sku_num) AS sku_num_year
			-- 销售金额
			, sum(price * sku_num) AS sku_amount_year
		FROM hive_sql_zg6.order_detail
		GROUP BY sku_id, date_format(create_date, 'yyyy')
    ),
-- step2. 每条数据加上编号：商品分组，年份排序
     tmp2 AS (
		SELECT
			sku_id, sale_year, sku_num_year, sku_amount_year
			, row_number() OVER (PARTITION BY sku_id ORDER BY sale_year) AS rk
			, row_number() OVER (DISTRIBUTE BY sku_id SORT BY sale_year) AS rn
		FROM tmp1
     )
-- step3. 过滤获取每个商品销售首年
SELECT
	sku_id, sale_year, sku_num_year, sku_amount_year
FROM tmp2
WHERE rk = 1
;


-- todo: 2）、筛选去年总销量小于100的商品
/*
从订单明细表(order_detail)中筛选出去年总销量小于100的商品及其销量，
	假设今天的日期是2022-01-10，不考虑上架时间小于一个月的商品
*/
-- d. 统计每个商品销量
SELECT
	sku_id, sum(sku_num) AS sku_num_sum
FROM hive_sql_zg6.order_detail
-- a. 过滤获取去年销售数据
WHERE date_format(create_date, 'yyyy') = add_months('2022-01-10', -12, 'yyyy')
    -- b. 商品上架时间大于等于1个月
	AND sku_id IN (
	    SELECT sku_info.sku_id
	    FROM hive_sql_zg6.sku_info
	    WHERE from_date <= add_months('2022-01-10', -1, 'yyyy-MM-dd')
	)
-- c. 商品分组
GROUP BY sku_id
-- e. 过滤销售小于100
HAVING sum(sku_num) < 100
;


-- 函数：add_months
DESC FUNCTION add_months;
/*
add_months(start_date, num_months, output_date_format)
	- Returns the date that is num_months after start_date.
*/
SELECT
	add_months('2024-04-06', 1, 'yyyy-MM-dd') AS next_month,
	add_months('2024-04-06', -1, 'yyyy-MM-dd') AS last_month
;

-- 日期函数：当前日期
SELECT
	`current_date`() AS curr_dt,
    `current_timestamp`() AS curr_ts,
    -- 字符串日期时间 转换 long类型数字
    unix_timestamp(`current_timestamp`()) AS ts_long,
	-- long类型数字 转换 字符串日期时间
	from_utc_timestamp(from_unixtime(1712374849, 'yyyy-MM-dd HH:mm:ss'), 'GMT+8') AS dt_str
;

DESC FUNCTION from_unixtime;
/*
from_unixtime(unix_time, format) - returns unix_time in the specified format
*/

DESC FUNCTION from_utc_timestamp;
/*
 from_utc_timestamp(timestamp, string timezone)
    - Assumes given timestamp is UTC and converts to given timezone (as of Hive 0.8.0)

 to_utc_timestamp/from_utc_timestamp
    第一个参数要求都是yyyy-MM-dd HH:mm:ss格式
        from_utc_timestamp(to_utc _timestamp(“2023-09-08 15:25:20',原始时区”),目标时区)
            可以将原始时区时间转换成目标时区时间
		from_utc_timestamp(to_utc_timestamp(from_unixtime(1694156493),数据库时区”),'目标时区”)
            可以将毫秒转换成目标时区时间
 */


-- todo: 3）、查询每日新用户数
/*
从用户登录明细表（user_login_detail）中查询每天的新增用户数，
若一个用户在某天登录了，且在这一天之前没登录过，则认为该用户为这一天的新增用户。
*/


-- todo: 4）、统计每个商品的销量最高的日期
/*
从订单明细表（order_detail）中统计出每种商品销售件数最多的日期及当日销量，
如果有同一商品多日销量并列的情况，取其中的最小日期。
*/

-- todo: 5）、查询销售件数高于品类平均数的商品
/*
从订单明细表（order_detail）中查询累积销售件数高于其所属品类平均数的商品
*/

