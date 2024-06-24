
-- 清空数据：
TRUNCATE TABLE gmall.user_info ;

-- 插入数据：2024-03-17
INSERT INTO `gmall`.`user_info` VALUES ('1', 'g5vuvt', '阿元', null, '茅钧', '13267245671', 'g5vuvt@aol.com', null, '1', '1972-05-17', 'M', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('2', '1zxcfajbop5', '芳燕', null, '和芳燕', '13165513595', '1zxcfajbop5@163.com', null, '1', '2001-07-17', 'F', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('3', '6ob7y5v7y0', '阿岩', null, '公孙岩', '13474673448', '6ob7y5v7y0@0355.net', null, '2', '2007-07-17', null, '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('4', 'ngkwm6q640', '春菊', null, '王芝', '13977633429', 'ngkwm6q640@aol.com', null, '1', '2008-05-17', 'F', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('5', '9eggpruv', '勇毅', null, '鲍泽晨', '13851362474', '9eggpruv@gmail.com', null, '1', '2007-04-17', 'M', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('6', '1ouocgjxa', '菁梦', null, '孟馨艺', '13863932811', '1ouocgjxa@sina.com', null, '1', '1997-02-17', null, '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('7', '6mya9h6qyanu', '政谦', null, '吴航弘', '13955343482', '6mya9h6qyanu@gmail.com', null, '1', '1983-10-17', 'M', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('8', '85sdnc3yi9q', '芸芸', null, '彭爱', '13779723342', 's4tf0grvkzhp@yeah.net', null, '1', '1987-10-17', 'F', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('9', '9pvt9lwq206s', '行时', null, '康行时', '13556126278', '9pvt9lwq206s@ask.com', null, '1', '2005-11-17', null, '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);
INSERT INTO `gmall`.`user_info` VALUES ('10', 'kimpfl47c8a', '露瑶', null, '葛姣婉', '13536199166', 'jlqk37@3721.net', null, '1', '2003-01-17', 'F', '2024-03-17 18:17:35', '2024-03-17 18:17:35', null);

-- 同步数据到HDFS：2024-03-24
-- todo sh mysql_to_hdfs_init.sh user_info 2024-03-24
-- todo hdfs dfs -cat /origin_data/gmall/user_info_inc/2024-03-24/par* | zcat

-- 导入ODS层：2024-03-24
-- todo sh hdfs_to_ods_init.sh ods_user_info 2024-03-24


-- 插入数据：2024-03-25
REPLACE INTO `gmall`.`user_info` VALUES ('9', '9pvt9lwq206s', '行时', null, '康行时', '13556126278', '9pvt9lwq206s@ask.com', null, '1', '2005-11-17', 'M', '2024-03-17 18:17:35', '2024-03-25 18:17:35', null);
REPLACE INTO `gmall`.`user_info` VALUES ('10', 'kimpfl47c8a', '露瑶', null, '葛姣婉', '13536199166', 'luyao@3721.net', null, '1', '2003-01-17', 'F', '2024-03-17 18:17:35', '2024-03-25 18:17:35', null);
REPLACE INTO `gmall`.`user_info` VALUES ('11', 'ddddsere', '马涛', null, '海涛', '13977633428', 'matao@126.com', null, '1', '2004-01-12', 'M', '2024-03-25 09:00:23', '2024-03-25 09:00:23', null);

-- 同步数据到HDFS：2024-03-25
-- todo sh mysql_to_hdfs.sh user_info 2024-03-25
-- todo hdfs dfs -cat /origin_data/gmall/user_info_inc/2024-03-25/par* | zcat

-- 导入ODS层：2024-03-25
-- todo sh hdfs_to_ods.sh ods_user_info 2024-03-25


