
DROP VIEW IF EXISTS v_tdlo_wp_posts;

CREATE VIEW v_tdlo_wp_posts
AS
SELECT `wp_posts`.`ID` AS `ID`
,`wp_posts`.`post_author` AS `post_author`
,`wp_posts`.`post_date` AS `post_date`
,`wp_posts`.`post_date_gmt` AS `post_date_gmt`
,`wp_posts`.`post_title` AS `post_title`
,`wp_posts`.`post_excerpt` AS `post_excerpt`
,`wp_posts`.`post_status` AS `post_status`
,`wp_posts`.`comment_status` AS `comment_status`
,`wp_posts`.`ping_status` AS `ping_status`
,`wp_posts`.`post_password` AS `post_password`
,`wp_posts`.`post_name` AS `post_name`
,`wp_posts`.`to_ping` AS `to_ping`
,`wp_posts`.`pinged` AS `pinged`
,`wp_posts`.`post_modified` AS `post_modified`
,`wp_posts`.`post_modified_gmt` AS `post_modified_gmt`
,`wp_posts`.`post_content_filtered` AS `post_content_filtered`
,`wp_posts`.`post_parent` AS `post_parent`
,`wp_posts`.`guid` AS `guid`
,`wp_posts`.`menu_order` AS `menu_order`
,`wp_posts`.`post_type` AS `post_type`
,`wp_posts`.`post_mime_type` AS `post_mime_type`
,`wp_posts`.`comment_count` AS `comment_count` 
from `wp_posts` 
where `wp_posts`.`post_type` = 'post'
;