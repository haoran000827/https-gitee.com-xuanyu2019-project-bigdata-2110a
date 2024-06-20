
/*
mysql> select CURRENT_TIMESTAMP() ;
+---------------------+
| CURRENT_TIMESTAMP() |
+---------------------+
| 2024-06-20 19:37:41 |
+---------------------+
1 row in set (0.00 sec)
*/

USE db_test;

-- 创建表
DROP TABLE IF EXISTS tbl_example;
CREATE TABLE tbl_example
(
    id           INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    data         VARCHAR(255) COMMENT '数据',
    created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据插入时间',
    update_time  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据更新时间'
) ENGINE = INNODB
  CHARACTER SET utf8
  COLLATE utf8_general_ci;
;

-- 增量：首日
SELECT * FROM tbl_example
WHERE date_format(created_time, '%Y-%m-%d') <= '2024-06-20'
  AND (date_format(update_time, '%Y-%m-%d') <= '2024-06-20' OR update_time IS NULL)
;

-- 增量：每日
SELECT * FROM tbl_example
WHERE date_format(created_time, '%Y-%m-%d') = '2024-05-11'
   OR date_format(update_time, '%Y-%m-%d') = '2024-05-11'
;



-- 插入数据
INSERT INTO tbl_example(data) VALUES (88), (99), (100);

-- 查询数据
SELECT * FROM tbl_example;
/*
1,88,2024-04-26 09:20:29,2024-04-26 09:20:29
2,99,2024-04-26 09:20:29,2024-04-26 09:20:29
3,100,2024-04-26 09:20:29,2024-04-26 09:20:29
*/

-- 更新数据
UPDATE tbl_example SET data = 888 WHERE id = 1 ;






