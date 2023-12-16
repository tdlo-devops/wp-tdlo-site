    DROP PROCEDURE IF EXISTS p_tdlo_process_upload_doc;
    DELIMITER $$
    CREATE PROCEDURE p_tdlo_process_upload_doc(
        p_idlog INT
    )
    BEGIN

        DECLARE v_idlog INT;
        DECLARE v_userid INT;
        DECLARE __wfu_file_upload_user_id__ INT;
        DECLARE __wfu_file_date__ bigint(20);
        DECLARE __wfu_file_path__ text;
        DECLARE __wfu_file_size__ bigint(20);
        DECLARE __wfu_file_upload_id__ INT;
        DECLARE __wfu_file_tag__ text;
        DECLARE __wfu_file_name__ text;
        DECLARE __dl_post_name__ text;
        DECLARE __dl_post_ip_addr__ text;
        DECLARE __dl_post_yyyy_mm__ text;
        DECLARE __wfu_file_link_name__ text;
        DECLARE __dl_post_author__ int;
        DECLARE __dl_post_date__ int;
        DECLARE maxid_post_meta_id_next INT;
        DECLARE maxid_post_meta_id_curr INT;
        DECLARE __dl_post_meta_id_parent__ INT;
        DECLARE __dl_post_meta_id_child__ INT;
        DECLARE maxid_post_id_curr INT;
        DECLARE maxid_post_id_next INT;
        DECLARE __dl_post_id_parent__ INT;
        DECLARE __dl_post_id_child__ INT;
        DECLARE _wp_attached_file text;
        DECLARE __dl_post_title__ text;
        DECLARE __dl_download_url__ text;

        SELECT idlog 
            ,userid
            ,uploaduserid AS __wfu_file_upload_user_id__
            ,uploadtime AS __wfu_file_date__
            ,filepath AS __wfu_file_path__
            ,filesize AS __wfu_file_size__
            ,0 AS __wfu_file_upload_id__
            ,SUBSTRING_INDEX(
                SUBSTRING_INDEX(`filepath`, '/', -1)
                , '.'
                , 1
                ) as __wfu_file_tag__
            ,replace(filepath,'/wp-content/uploads/','') as __wfu_file_name__
            ,replace(lower(__wfu_file_tag__),' ','-') as __dl_post_name__
            , '' as __dl_post_ip_addr__
            , '' AS __dl_post_yyyy_mm__
        INTO v_idlog, 
             v_userid,
             __wfu_file_upload_user_id__,
             __wfu_file_date__,
             __wfu_file_path__,
             __wfu_file_size__,
             __wfu_file_upload_id__,
             __wfu_file_tag__,
             __wfu_file_name__,
             __dl_post_name__,
             __dl_post_ip_addr__,
             __dl_post_yyyy_mm__
        FROM wp_wfu_log
        WHERE idlog = p_idlog;

        INSERT INTO TEMP_wp_wfu_log
            (
                idlog
                ,userid
                ,__wfu_file_upload_user_id__
                ,__wfu_file_date__
                ,__wfu_file_path__
                ,__wfu_file_size__
                ,__wfu_file_upload_id__
                ,__wfu_file_tag__
                ,__wfu_file_name__
                ,__dl_post_name__
                ,__dl_post_ip_addr__
                ,__dl_post_yyyy_mm__
            )
         VALUES 
            (
                v_idlog
                ,v_userid
                ,__wfu_file_upload_user_id__
                ,__wfu_file_date__
                ,__wfu_file_path__
                ,__wfu_file_size__
                ,__wfu_file_upload_id__
                , __wfu_file_tag__
                , __wfu_file_name__
                , __dl_post_name__
                , __dl_post_ip_addr__
                , __dl_post_yyyy_mm__
            );

        /** -- --------------------------------------- -- **/
        SELECT SUBSTRING_INDEX(option_value, '/', -1) 
          INTO __dl_post_ip_addr__ 
          FROM wp_options 
         WHERE option_name = 'siteurl';
        UPDATE TEMP_wp_wfu_log
           SET __dl_post_ip_addr__ =  __dl_post_ip_addr__
         WHERE idlog = p_idlog;
        /** -- --------------------------------------- -- **/
        /** -- --------------------------------------- -- **/
        SELECT DATE_FORMAT(NOW(),'%Y/%m') 
          INTO __dl_post_yyyy_mm__;
        UPDATE TEMP_wp_wfu_log
           SET __dl_post_yyyy_mm__ =  __dl_post_yyyy_mm__
         WHERE idlog = p_idlog;        
        /** -- --------------------------------------- -- **/
        /** -- --------------------------------------- -- **/
        SET __wfu_file_link_name__ = __wfu_file_tag__    ;
        SET __dl_post_author__ = __wfu_file_upload_id__  ;
        SET __dl_post_date__ = __wfu_file_date__         ;

        SELECT MAX(meta_id) INTO maxid_post_meta_id_curr FROM wp_postmeta;
        SET maxid_post_meta_id_next = maxid_post_meta_id_curr + 1 ;

        SET __dl_post_meta_id_parent__ = maxid_post_meta_id_next    ;    
        SET __dl_post_meta_id_child__ = __dl_post_meta_id_parent__ + 1 ;

        SELECT MAX(ID) INTO maxid_post_id_curr FROM wp_posts;
        SET maxid_post_id_next = maxid_post_id_curr + 1 ;
        SET __dl_post_id_parent__ = maxid_post_id_next     ;             
        SET __dl_post_id_child__ = __dl_post_id_parent__ + 1 ;
        /** -- --------------------------------------- -- **/
        /** -- --------------------------------------- -- **/
        SELECT MAX(meta_id) INTO maxid_post_meta_id_curr FROM wp_postmeta;
        SELECT MAX(ID) INTO maxid_post_id_curr FROM wp_posts;

        UPDATE TEMP_wp_wfu_log
            SET 
                __wfu_file_link_name__ = __wfu_file_link_name__,
                __dl_post_author__ = __wfu_file_upload_id__,
                __dl_post_date__ = __wfu_file_date__,
                maxid_post_meta_id_curr = maxid_post_meta_id_curr,
                maxid_post_meta_id_next = maxid_post_meta_id_curr + 1,
                __dl_post_meta_id_parent__ = maxid_post_meta_id_next,

                __dl_post_meta_id_child__ = __dl_post_meta_id_parent__ + 1,
                maxid_post_id_curr = maxid_post_id_curr,
                maxid_post_id_next = maxid_post_id_curr + 1,
                __dl_post_id_parent__ = maxid_post_id_next,
                __dl_post_id_child__ = __dl_post_id_parent__ + 1
            WHERE idlog = p_idlog;
        /** -- --------------------------------------- -- **/

        /************ INSERT(S): wp_postmeta ****************/
        INSERT INTO wp_postmeta 
            VALUES
               ( __dl_post_meta_id_parent__
                 ,__dl_post_id_child__
                 ,'_wp_attached_file'
                 ,CONCAT(__dl_post_yyyy_mm__, '/', __wfu_file_name__)
                 );

        INSERT INTO wp_postmeta 
            VALUES
           ( __dl_post_meta_id_child__
             ,__dl_post_id_child__
             ,'_wp_attachment_metadata'
             ,CONCAT( 'a:1:{s:8:\"filesize\";i:', __wfu_file_size__ , ';}')
           );

        /************ INSERT(S): wp_posts ****************/
        SET __dl_post_title__ = __dl_post_name__ ;

        SET __dl_download_url__ = CONCAT('\r\n\r\n'
                                      ,'<a href=\"http://'
                                      , __dl_post_ip_addr__
                                      ,'/'
                                      ,'wp-content/uploads/'
                                      ,__dl_post_yyyy_mm__
                                      ,'/'
                                      ,__wfu_file_name__) ;
        INSERT INTO wp_posts
        SELECT __dl_post_id_parent__                as ID
                ,__dl_post_author__                 as post_author
                ,FROM_UNIXTIME(__dl_post_date__)    as post_date
                ,FROM_UNIXTIME(__dl_post_date__)    as post_date_gmt
                ,CONCAT(__dl_post_title__
                      ,__dl_download_url__
                      ,'\"'
                      ,' '
                      , 'class="document-library-button button btn"'
                      ,' '
                      , 'download="'
                      ,__wfu_file_name__
                      ,'"'
                      ,' '
                      , 'type="application/pdf"'
                      , '>Download</a>r\n'
                  )                                 as post_content
                ,__dl_post_title__                  as post_title
                -- ,__dl_post_name__                   as post_title
                ,''                                 as post_excerpt
                ,'publish'                          as post_status
                ,'closed'                           as comment_status
                ,'closed'                           as ping_status
                ,''                                 as post_password
                , replace(
                    replace(
                         lower(__wfu_file_name__)
                        ,' ','-'
                        )
                    ,'.','-'
                    )                               as __dl_post_name__
                ,''                                 as to_ping
                ,''                                 as pinged
                ,FROM_UNIXTIME(__dl_post_date__)    as post_modified
                ,FROM_UNIXTIME(__dl_post_date__)    as post_modified_gmt
                ,''                                 as post_content_filtered
                ,0                                  as post_parent
                ,CONCAT('http://'                   
                            ,__dl_post_ip_addr__
                            ,'/'
                            ,'?post_type=dlp_document&#038;p='
                            ,__dl_post_id_parent__
                        )                           as guid 
                ,0                                  as menu_order
                ,'dlp_document'                     as post_type
                ,''                                 as post_mime_type
                ,0                                  as comment_count
            FROM TEMP_wp_wfu_log
            WHERE  idlog = (SELECT MAX(idlog) FROM TEMP_wp_wfu_log);

        INSERT INTO wp_posts
        SELECT __dl_post_id_child__                     as ID
                ,__dl_post_author__                     as post_author
                ,FROM_UNIXTIME(__dl_post_date__)        as post_date
                ,FROM_UNIXTIME(__dl_post_date__)        as post_date_gmt
                ,'__dl_post_attachment_description__'   as post_content
                ,__wfu_file_tag__                       as post_title
                ,'__dl_post_attachment_caption__'       as post_excerpt
                ,'inherit'                              as post_status
                ,'open'                                 as comment_status
                ,'closed'                               as ping_status
                ,''                                     as post_password
                , replace(
                    replace(
                         lower(__wfu_file_name__)
                        ,' ','-'
                        )
                    ,'.','-'
                    )                               as __dl_post_name__
                ,''                                 as to_ping
                ,''                                 as pinged
                ,FROM_UNIXTIME(__dl_post_date__)    as post_modified
                ,FROM_UNIXTIME(__dl_post_date__)    as post_modified_gmt
                ,''                                 as post_content_filtered
                ,__dl_post_id_parent__
                ,CONCAT('http://', __dl_post_ip_addr__,'/','wp-content/uploads/',__dl_post_yyyy_mm__,'/',__wfu_file_name__) as guid
                ,0                                  as menu_order
                ,'attachment'                       as post_type
                ,'application/pdf'                  as post_mime_type
                ,0                                  as comment_count
            FROM TEMP_wp_wfu_log
            WHERE  idlog = (SELECT MAX(idlog) FROM TEMP_wp_wfu_log);


    END$$

    DELIMITER ;

###############################################################################
-- cat <<EOF | tee wfulog
-- SELECT idlog
--     ,maxid_post_meta_id_curr
--     ,maxid_post_meta_id_next
--     ,__dl_post_meta_id_parent__
--     ,__dl_post_meta_id_child__   
-- FROM TEMP_wp_wfu_log;

-- SELECT idlog
--     ,maxid_post_id_curr
--     ,maxid_post_id_next
--     ,__dl_post_id_parent__
--     ,__dl_post_id_child__
-- FROM TEMP_wp_wfu_log;

-- SELECT MAX(meta_id) FROM  wp_postmeta;
-- SELECT MAX(ID) FROM  wp_posts;
-- EOF

-- cat <<EOF | tee postmeta
-- SHOW COLUMNS FROM wp_postmeta;
-- select * 
-- from wp_postmeta 
-- -- where meta_id > (SELECT MAX(meta_id) -20  FROM  wp_postmeta)
-- order by 1;
-- EOF

-- -- select idlog, userid, uploaduserid, uploadtime, sessionid
-- --     , filepath, filehash, filesize, uploadid, pageid, blogid, sid
-- --     , date_from, date_to, action;

-- cat <<EOF | tee posts
-- SHOW COLUMNS FROM wp_posts;
-- SELECT distinct ID
--     , substr(post_content,1,20) as post_content
--   --  , post_title
--     , post_status
--     , comment_status
--     , ping_status
--     , post_name
--     , post_parent
--     , post_type
--     , post_mime_type
--     , post_password
-- FROM wp_posts 
-- order by 1;
-- EOF


###############################################################################

