
-- todo 函数1：named_struct
DESC FUNCTION named_struct ;
/*
named_struct(name1, val1, name2, val2, ...)
    - Creates a struct with the given field names and values
*/
WITH
    tmp1 AS (
        SELECT 'zhangsan' AS name, 23 AS age, 'male' AS gender, 'beijing' AS address
        UNION
        SELECT 'lis' AS name, 21 AS age, 'female' AS gender, 'shangh' AS address
        UNION
        SELECT 'wangwu' AS name, 22 AS age, 'male' AS gender, 'hanghzou' AS address
    )
SELECT
    named_struct('name', name, 'age', age, 'gender', gender, 'address', address) AS user_json
FROM tmp1;


-- todo 函数2：数据脱敏
/*
    md5 对数据进行加密处理，返回一段字符串，可用于数据脱敏
*/
DESC FUNCTION md5 ;
/*
md5(str or bin) - Calculates an MD5 128-bit checksum for the string or binary.
 */
SELECT md5('八维教育') AS name_md5 ;

/*
    mask 对数据集近马赛克
*/
DESC FUNCTION mask;
/*
    masks the given value
*/
WITH
    tmp1 AS (
        SELECT '张三' AS name, '15198760233' AS telephone
        UNION
        SELECT '李小四' AS name, '15123468744' AS telephone
        UNION
        SELECT '王五' AS name, '18698760123' AS telephone
    )
SELECT
    name, telephone
     -- 字符串替换
     , concat(substr(name, 1, 1), if(length(name) == 2, '*', '**')) AS new_name
     -- md5算法加密脱敏
     , md5(name) AS md5_name
     -- mask函数数据脱敏
     , mask(telephone) AS mask_telephone_all
     , mask_show_first_n(telephone, 4) AS mask_telephone_first
     , mask_show_last_n(telephone, 4) AS mask_telephone_last
     , mask_hash(name) AS name_mask_hash
FROM tmp1 ;


-- todo 面试题：如何对数据加密和解密，数据脱敏处理
/*
    Hive UDF实现数据加密解密功能
     https://blog.csdn.net/m0_37689903/article/details/133427692
*/


