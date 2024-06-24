/*
Navicat MySQL Data Transfer

Source Server         : node101-mysql
Source Server Version : 50729
Source Host           : node101:3306
Source Database       : gmall

Target Server Type    : MYSQL
Target Server Version : 50729
File Encoding         : 65001

Date: 2024-06-23 16:35:21
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `login_name` varchar(200) DEFAULT NULL COMMENT '用户名称',
  `nick_name` varchar(200) DEFAULT NULL COMMENT '用户昵称',
  `passwd` varchar(200) DEFAULT NULL COMMENT '用户密码',
  `name` varchar(200) DEFAULT NULL COMMENT '用户姓名',
  `phone_num` varchar(200) DEFAULT NULL COMMENT '手机号',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `head_img` varchar(200) DEFAULT NULL COMMENT '头像',
  `user_level` varchar(200) DEFAULT NULL COMMENT '用户级别',
  `birthday` date DEFAULT NULL COMMENT '用户生日',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别 M男,F女',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(200) DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1012 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user_info
-- ----------------------------
INSERT INTO `user_info` VALUES ('1001', 'qyl6wu', '光天', null, '轩辕晨辰', '13711645476', 'qyl6wu@ask.com', null, '2', '2008-02-16', 'M', '2024-06-16 11:35:56', '2024-06-17 11:36:25', null);
INSERT INTO `user_info` VALUES ('1002', '037nueaf3r', '芝玉', null, '雷芝玉', '13158146414', '037nueaf3r@sohu.com', null, '2', '1995-09-16', null, '2024-06-16 11:35:56', null, null);
INSERT INTO `user_info` VALUES ('1003', 'fqms18', '固之', null, '汤固之', '13174952865', 'fqms18@gmail.com', null, '3', '1995-10-16', 'M', '2024-06-16 11:35:56', null, null);
INSERT INTO `user_info` VALUES ('1004', 'ek8hwf5hjt', '倩倩', null, '雷霄', '13877564416', 'ek8hwf5hjt@sohu.com', null, '1', '1995-11-16', 'F', '2024-06-16 11:35:56', '2024-06-18 11:37:38', null);
INSERT INTO `user_info` VALUES ('1005', 'sf7iknyt2m0', '阿和', null, '轩辕和', '13712457755', 'sf7iknyt2m0@0355.net', null, '1', '2001-06-16', null, '2024-06-16 11:35:56', null, null);
INSERT INTO `user_info` VALUES ('1006', '6lq2hl2aiiq', '露瑶', null, '葛瑶', '13693924826', '6lq2hl2aiiq@yahoo.com.cn', null, '1', '1998-07-16', 'M', '2024-06-16 11:35:56', '2024-06-19 11:37:38', null);
INSERT INTO `user_info` VALUES ('1007', 'owwyowwmxs', '言若', null, '汪言若', '13926714127', 'owwyowwmxs@126.com', null, '1', '2008-10-16', 'M', '2024-06-16 11:35:56', null, null);
INSERT INTO `user_info` VALUES ('1008', 'tw5tuus', '筠柔', null, '郝悦昭', '13931183525', 'tw5tuus@msn.com', null, '1', '1986-02-16', null, '2024-06-16 11:35:56', '2024-06-18 11:37:38', null);
INSERT INTO `user_info` VALUES ('1009', 'nwy0mvq7', '阿富', null, '范富', '13669759736', 'nwy0mvq7@126.com', null, '2', '1983-01-16', 'M', '2024-06-16 11:35:56', null, null);
INSERT INTO `user_info` VALUES ('1010', '莺莺', '媛媛', null, '沈莺媛', '13844631761', 'shenyingyuan@sina.com', null, '1', '1993-07-16', 'F', '2024-06-16 11:35:56', '2024-06-19 11:37:38', null);
INSERT INTO `user_info` VALUES ('1011', '郭进黄蓉', '蓉蓉', '', '黄蓉', '13931183525', 'huangrong@msn.com', '', '12', '1986-02-12', 'M', '2024-06-19 10:35:00', '2024-06-19 10:35:00', '');
