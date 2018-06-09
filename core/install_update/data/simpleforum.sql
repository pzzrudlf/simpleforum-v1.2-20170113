DROP TABLE IF EXISTS simple_user;
CREATE TABLE simple_user (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL default 8,
  `role` tinyint(1) unsigned NOT NULL default 0,
  `score` mediumint(8) unsigned NOT NULL default 0,
  `username` char(16) NOT NULL,
  `email` char(50) NOT NULL,
  `password_hash` char(80) NOT NULL,
  `auth_key` char(32) NOT NULL,
  `avatar` char(50) NOT NULL default 'avatar/0_{size}.png',
  `comment` char(20) NOT NULL default '',
  PRIMARY KEY id(`id`),
  UNIQUE KEY username(`username`),
  UNIQUE KEY email(`email`),
  KEY status_id(`status`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_user_info;
CREATE TABLE simple_user_info (
  `user_id` mediumint(8) unsigned NOT NULL auto_increment,
  `last_login_at` int(10) unsigned NOT NULL,
  `last_login_ip` int(10) unsigned NOT NULL,
  `reg_ip` int(10) unsigned NOT NULL,
  `topic_count` mediumint(8) unsigned NOT NULL default 0,
  `comment_count` mediumint(8) unsigned NOT NULL default 0,
  `favorite_count` smallint(6) unsigned NOT NULL default 0,
  `favorite_node_count` smallint(6) unsigned NOT NULL default 0,
  `favorite_topic_count` smallint(6) unsigned NOT NULL default 0,
  `favorite_user_count` smallint(6) unsigned NOT NULL default 0,
  `website` varchar(100) NOT NULL default '',
  `about` varchar(255) NOT NULL default '',
  PRIMARY KEY user_id(`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_token;
CREATE TABLE simple_token (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL default 0,
  `user_id` mediumint(8) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  `token` varchar(50) NOT NULL COLLATE utf8_bin,
  `ext` varchar(200) NOT NULL default '',
  PRIMARY KEY id(`id`),
  UNIQUE KEY token(`token`),
  KEY user_type_expires(`user_id`, `type`, `expires`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_siteinfo;
CREATE TABLE simple_siteinfo (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `nodes` smallint(6) unsigned NOT NULL default 0,
  `users` mediumint(8) unsigned NOT NULL default 0,
  `topics` mediumint(8) unsigned NOT NULL default 0,
  `comments` int(10) unsigned NOT NULL default 0,
  PRIMARY KEY id(`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO simple_siteinfo VALUES(1, 1, 0, 0, 0);

DROP TABLE IF EXISTS simple_node;
CREATE TABLE simple_node (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `topic_count` mediumint(8) unsigned NOT NULL default 0,
  `favorite_count` smallint(6) unsigned NOT NULL default 0,
  `access_auth` tinyint(1) unsigned NOT NULL default 0,
  `invisible` tinyint(1) unsigned NOT NULL default 0,
  `name` varchar(20) NOT NULL,
  `ename` varchar(20) NOT NULL,
  `about` varchar(255) NOT NULL default '',
  PRIMARY KEY id(`id`),
  UNIQUE KEY name(`name`),
  UNIQUE KEY ename(`ename`),
  KEY topic_id(`topic_count`, `id`),
  KEY invisible(`invisible`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO simple_node VALUES(1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 0, 0, '默认分类', 'default', '');

DROP TABLE IF EXISTS simple_navi;
CREATE TABLE simple_navi (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) unsigned NOT NULL default 0,
  `sortid` tinyint(1) unsigned NOT NULL default 50,
  `name` varchar(20) NOT NULL,
  `ename` varchar(20) NOT NULL,
  PRIMARY KEY id(`id`),
  UNIQUE KEY name(`type`, `name`),
  UNIQUE KEY ename(`type`, `ename`),
  KEY type_sort(`type`,`sortid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_navi_node;
CREATE TABLE simple_navi_node (
  `id` int(10) unsigned NOT NULL auto_increment,
  `navi_id` smallint(6) unsigned NOT NULL,
  `node_id` smallint(6) unsigned NOT NULL,
  `visible` tinyint(1) unsigned NOT NULL default 0,
  `sortid` tinyint(1) unsigned NOT NULL default 50,
  PRIMARY KEY id(`id`),
  UNIQUE KEY navi_node(`navi_id`,`node_id`),
  KEY navi_node_sort(`navi_id`,`node_id`,`sortid`),
  KEY navi_node_visible_sort(`navi_id`,`node_id`,`visible`,`sortid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_topic;
CREATE TABLE simple_topic (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `replied_at` int(10) unsigned NOT NULL,
  `node_id` smallint(6) unsigned NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL,
  `reply_id` mediumint(8) unsigned NOT NULL default 0,
  `alltop` tinyint(1) unsigned NOT NULL default 0,
  `top` tinyint(1) unsigned NOT NULL default 0,
  `invisible` tinyint(1) unsigned NOT NULL default 0,
  `closed` tinyint(1) unsigned NOT NULL default 0,
  `access_auth` tinyint(1) unsigned NOT NULL default 0,
  `comment_closed` tinyint(1) unsigned NOT NULL default 0,
  `comment_count` mediumint(8) unsigned NOT NULL default 0,
  `favorite_count` smallint(6) unsigned NOT NULL default 0,
  `good` smallint(6) unsigned NOT NULL default 0,
  `views` mediumint(8) unsigned NOT NULL default 0,
  `title` char(120) NOT NULL,
  `tags` char(60) NOT NULL default '',
  PRIMARY KEY id(`id`),
  KEY alllist(`node_id`, `alltop`, `replied_at`, `id`),
  KEY nodelist(`node_id`, `top`, `replied_at`, `id`),
  KEY hottopics(`node_id`, `created_at`, `comment_count`, `replied_at`),
  KEY updated(`updated_at`),
  KEY node_updated(`node_id`,`updated_at`),
  KEY allcount(`node_id`, `id`),
  KEY user_id(`user_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_topic_content;
CREATE TABLE simple_topic_content (
  `topic_id` mediumint(8) unsigned NOT NULL auto_increment,
  `content` text NOT NULL,
  PRIMARY KEY topic_id(`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_comment;
CREATE TABLE simple_comment (
  `id` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL,
  `topic_id` mediumint(8) unsigned NOT NULL,
  `position` mediumint(8) unsigned NOT NULL auto_increment,
  `invisible` tinyint(1) unsigned NOT NULL default 0,
  `good` smallint(6) unsigned NOT NULL default 0,
  `content` text NOT NULL,
  PRIMARY KEY topic_position(`topic_id`, `position`),
  UNIQUE KEY id(`id`),
  KEY user_id(`user_id`,`id`),
  KEY topic_updated(`topic_id`, `updated_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_commentid;
CREATE TABLE simple_commentid (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `simple_notice`;
CREATE TABLE `simple_notice` (
  `id` int(10) NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL default 0,
  `target_id` mediumint(8) unsigned NOT NULL,
  `source_id` mediumint(8) unsigned NOT NULL,
  `topic_id` mediumint(8) unsigned NOT NULL default 0,
  `position` mediumint(8) unsigned NOT NULL default 0,
  `notice_count` smallint(6) unsigned NOT NULL default 0,
  `msg` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY target_status_id(`target_id`,`status`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_tag;
CREATE TABLE simple_tag (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `updated_at` int(10) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  `topic_count` smallint(6) unsigned NOT NULL default 0,
  PRIMARY KEY id(`id`),
  UNIQUE KEY name(`name`),
  KEY updated(`updated_at`, `id`),
  KEY topic_count(`topic_count`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_tag_topic;
CREATE TABLE simple_tag_topic (
  `id` int(10) unsigned NOT NULL auto_increment,
  `tag_id` int(10) unsigned NOT NULL,
  `topic_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY id(`id`),
  UNIQUE KEY tag_topic(`tag_id`,`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_link;
CREATE TABLE simple_link (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `sortid` tinyint(1) unsigned NOT NULL default 50,
  `name` varchar(20) NOT NULL,
  `url` varchar(100) NOT NULL,
  PRIMARY KEY id(`id`),
  KEY sort_id(`sortid`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO simple_link VALUES(1, 0, '极简论坛', 'http://simpleforum.org/');


DROP TABLE IF EXISTS simple_setting;
CREATE TABLE simple_setting (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `sortid` tinyint(1) unsigned NOT NULL default 50,
  `block` varchar(10) NOT NULL default '',
  `label` varchar(50) NOT NULL default '',
  `type` varchar(10) NOT NULL default 'text',
  `key` varchar(50) NOT NULL,
  `value_type` varchar(10) NOT NULL default 'text',
  `value` text NOT NULL,
  `option` text NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY id(`id`),
  UNIQUE KEY `key`(`key`),
  KEY block_sort_id(`block`,`sortid`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO simple_setting(`sortid`, `block`, `label`, `type`, `key`, `value_type`, `value`, `description`, `option`) VALUES
(1,'info', '网站名称','text', 'site_name','text', '极简论坛', '考虑到手机浏览，网站名称不要设置过长。', ''),
(2,'info', '网站副标题','text', 'slogan','text', '功能简单,界面简洁,移动优先', '15字以内', ''),
(3,'info', '网站描述','textarea', 'description','text', 'Simple Forum,极简论坛', '给搜索引擎看的，150字以内', ''),
(4,'info', '备案号', 'text', 'icp','text', '', '若有就填，如 京ICP证0603xx号', ''),
(5,'info', '管理员邮箱', 'text', 'admin_email','text', '', '用来接收用户错误报告', ''),
(1,'manage', '网站暂时关闭', 'select','offline','integer', '0', '默认:0(开启)', '["0(开启)","1(关闭)"]'),
(2,'manage', '网站暂时关闭提示', 'textarea','offline_msg','text', '网站维护中，请稍后访问', '简单写明关闭原因', ''),
(3,'manage', '只允许登录访问', 'select','access_auth','integer', '0', '默认0（公开），若规定登录用户才能访问就设为1（适合内部交流）', '["0(公开)","1(登录访问)"]'),
(4,'manage', '注册需邮箱验证', 'select','email_verify','integer', '0', '建议设为1（需验证），若不需要验证就设为0', '["0(关闭验证)","1(开启验证)"]'),
(5,'manage', '注册需管理员验证', 'select','admin_verify','integer', '0', '默认0（不用验证），若需要管理员验证就设为1（适合内部交流）', '["0(关闭验证)","1(开启验证)"]'),
(6,'manage', '关闭用户注册', 'select','close_register', 'integer', '0','默认0，若停止新用户注册就设为1（仍旧可以通过第三方帐号登录方式注册）', '["0(开启注册)","1(关闭注册)","2(只开放邀请码注册)"]'),
(7,'manage', '过滤用户名', 'text','username_filter', 'text', '','指定用户名不能含有某些指定词汇，用半角逗号(,)分割，例：<br />admin,webmaster,admin*', ''),
(8,'manage', '开启验证码', 'select','captcha_enabled', 'integer', '0','开启后，注册和登录时会要求输入验证码', '["0(关闭)","1(开启)"]'),
(9,'manage', '开启自动链接', 'select','autolink', 'integer', '0','自动给帖子内容中的网址加上链接', '["0(关闭)","1(开启)"]'),
(10,'manage', '自动链接排除列表', 'textarea','autolink_filter', 'text', '','不包含http://，可设置主域名或二级域名等，一行一个网址', '["0(关闭","1(开启)"]'),
(11,'manage', '模板', 'text','theme', 'text', '','模板名请用字母数字横杠下划线命名，模板放在"themes/模板名/"目录下', ''),
(12,'manage', '移动模板', 'text','theme_mobile', 'text', 'sf-mobile','移动设备（手机/平板）专用模板，模板名请用字母数字横杠下划线命名，放在"themes/移动模板名/"目录下', ''),
(13,'manage', '会员组', 'textarea','groups', 'text', '1500 普通会员\n3000 铜牌会员\n5000 银牌会员\n8000 金牌会员\n15000 铂金会员\n30000 钻石会员','一行一个组，格式为:最大积分 用户组名"', ''),
(1,'extend', '放在页面头部<br/>head标签里面的<br/>meta或其它信息', 'textarea','head_meta', 'text', '','示例:<br/>&lt;meta property="qc:admins" content="331146677212163161xxxxxxx" /&gt;<br/>&lt;meta name="cpalead-verification" content="ymEun344mP9vt-B2idFRxxxxxxx" /&gt;', ''),
(2,'extend', '放在页面底部的<br/>统计代码', 'textarea','analytics_code', 'text', '','示例： 直接粘贴google 或 百度统计代码', ''),
(3,'extend', '底部链接', 'textarea','footer_links','text', '', '一行一个链接，格式： 描述 http://url<br />如：关于本站 http://simpleforum.org/t/1', ''),
(4,'extend', '时区', 'select','timezone','text', 'Asia/Shanghai', '修改时要特别注意！默认Asia/Shanghai', ''),
(5,'extend', '编辑器', 'select','editor','text', 'WysibbEditor', '普通论坛推荐Wysibb编辑器(BBCode)，技术类论坛推荐SimpleMarkdown编辑器。注意：换编辑器可能会使以前发的帖子格式混乱。', '{"WysibbEditor":"Wysibb编辑器(BBCode)"}'),
(6,'extend', '会员头像', 'select','avatar_style','text', 'img-rounded', '', '{"img-circle":"圆形","img-rounded":"圆角方形"}'),
(1,'cache', '开启缓存', 'select','cache_enabled','integer', '0', '默认0（不开启）', '["0(关闭)","1(开启)"]'),
(2,'cache', '缓存时间(分)', 'text','cache_time','integer', '10', '默认10分', ''),
(3,'cache', '缓存类型', 'select','cache_type', 'text', 'file', '默认file', '{"file":"file","apc":"apc","memcache":"memcache","memcached":"memcached"}'),
(4,'cache', '缓存服务器', 'textarea','cache_servers', 'text','', '缓存类型设为MemCache时设置<br/>一个服务器一行，格式为：IP 端口 权重<br />示例：<br />127.0.0.1 11211 100<br />127.0.0.2 11211 200', ''),
(1,'auth', '开启第三方登录', 'select','auth_enabled', 'integer','0', '', '["0(关闭)","1(开启)"]'),
(2,'auth', '第三方登录设定', 'textarea','auth_setting', 'text','[]', '', ''),
(1,'other', '首页显示帖子数', 'text', 'index_pagesize', 'integer', '20','默认20', ''),
(2,'other', '每页显示帖子数', 'text','list_pagesize', 'integer', '20','默认20', ''),
(3,'other', '每页显示回复数', 'text','comment_pagesize', 'integer', '20','默认20', ''),
(4,'other', '最热主题数', 'text','hot_topic_num', 'integer', '10','默认10', ''),
(5,'other', '最热节点数', 'text','hot_node_num', 'integer', '20','默认20', ''),
(6,'other', '可编辑时间(分)', 'text','edit_space', 'integer', '30','默认30，主题贴和回复发表后可修改时间。', ''),
(7,'other', '发表主题间隔(秒)', 'text','topic_space', 'integer', '30','默认30', ''),
(8,'other', '发表回复间隔(秒)', 'text','comment_space', 'integer', '20','默认20', ''),
(9,'other', 'static目录自定义网址', 'text','alias_static','text', '', '自定义web/static目录的网址，可用于CDN。例：http://static.simpleforum.org', ''),
(10,'other', '头像目录自定义网址', 'text','alias_avatar','text', '', '自定义web/avatar目录的网址，可用于CDN。例：http://avatar.simpleforum.org', ''),
(11,'other', '附件目录自定义网址', 'text','alias_upload','text', '', '自定义web/upload目录的网址，可用于CDN。例：http://upload.simpleforum.org', ''),
(1,'mailer', 'SMTP服务器', 'text','mailer_host', 'text', '','', ''),
(2,'mailer', 'SMTP端口', 'text','mailer_port', 'integer', '','', ''),
(3,'mailer', 'SMTP加密协议', 'text','mailer_encryption', 'text', '','如ssl,tls等，不加密留空', ''),
(4,'mailer', 'SMTP验证邮箱', 'text','mailer_username', 'text', '','请输入完整邮箱地址', ''),
(5,'mailer', 'SMTP验证密码', 'password','mailer_password', 'text', '','验证邮箱的密码', ''),
(1,'upload', '头像上传', 'select','upload_avatar','text', 'local', '默认:上传到网站所在空间', '{"local":"上传到网站所在空间","remote":"上传到第三方空间"}'),
(2,'upload', '附件上传', 'select','upload_file','text', 'disable', '默认:网站空间', '{"disable":"关闭上传","local":"上传到网站所在空间","remote":"上传到第三方空间"}'),
(3,'upload', '附件上传条件(注册时间)', 'text','upload_file_regday','integer', '30', '默认：30天', ''),
(3,'upload', '附件上传条件(主题数)', 'text','upload_file_topicnum','integer', '20', '默认：20', ''),
(4,'upload', '第三方空间', 'select','upload_remote', 'text','', '', '[]');

DROP TABLE IF EXISTS `simple_favorite`;
CREATE TABLE `simple_favorite` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `type` tinyint(1) unsigned NOT NULL default 0,
  `source_id` mediumint(8) unsigned NOT NULL default 0,
  `target_id` mediumint(8) unsigned NOT NULL default 0,
  PRIMARY KEY  (`id`),
  UNIQUE KEY source_type_target(`source_id`, `type`, `target_id`),
  KEY type_target(`type`, `target_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_auth;
CREATE TABLE simple_auth (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `user_id` mediumint(8) unsigned NOT NULL default 0,
  `source` varchar(20) NOT NULL,
  `source_id` varchar(100) NOT NULL,
  PRIMARY KEY id(id),
  UNIQUE KEY user_source(`user_id`, `source`),
  UNIQUE KEY source_source_id(`source`, `source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `simple_history`;
CREATE TABLE `simple_history` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` mediumint(8) unsigned NOT NULL default 0,
  `type` tinyint(1) unsigned NOT NULL default 0,
  `action` tinyint(1) unsigned NOT NULL,
  `action_time` int(10) unsigned NOT NULL,
  `target` int(10) unsigned NOT NULL default 0,
  `ext` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY user_type_id(`user_id`, `type`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_ad;
CREATE TABLE simple_ad (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `created_at` int(10) unsigned NOT NULL,
  `expires` date NOT NULL,
  `location` tinyint(1) unsigned NOT NULL,
  `node_id` smallint(6) unsigned NOT NULL default 0,
  `sortid` tinyint(1) unsigned NOT NULL default 50,
  `name` varchar(20) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY id(`id`),
  UNIQUE KEY id(`id`),
  KEY adkey(`location`,`node_id`, `expires`, `sortid`, `id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS simple_plugin;
CREATE TABLE simple_plugin (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `status` tinyint(1) unsigned NOT NULL default 0,
  `pid` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL default '',
  `author` varchar(20) NOT NULL default '',
  `url` varchar(255) NOT NULL default '',
  `version` varchar(10) NOT NULL default '',
  `config` text NOT NULL,
  `settings` text NOT NULL,
  `events` text NOT NULL,
  PRIMARY KEY id(`id`),
  UNIQUE KEY `pid`(`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `simple_plugin` (`id`, `status`, `pid`, `name`, `description`, `author`, `url`, `version`, `config`, `settings`, `events`) VALUES
(1, 0, 'WysibbEditor', 'Wysibb编辑器(BBcode)', 'Wysibb编辑器(BBcode)', 'SimpleForum', 'http://simpleforum.org', '1.0', '', '', '');
