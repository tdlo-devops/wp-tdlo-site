
DROP VIEW IF EXISTS v_tdlo_file_upload;

CREATE VIEW v_tdlo_file_upload
AS
SELECT file_id       
    , file_name
    , REPLACE(
        REPLACE(file_name,'.pdf','')
        , '_'
        , ' '
        ) as file_title
    , CONCAT(ROUND(file_size / 1024), ' kb') as size    
    -- , file_cacl     
    -- , file_owner    
    -- , file_group    
    , file_shasum   
    -- , file_sha256sum
    -- , file_sha512sum
    -- , file_info     
    , wp_wfu_idlog
    , SUBSTR(REPLACE(
               REPLACE(
                       REPLACE(
                               file_text, '__SGL_QTE__', "'"
                       ), '__DBL_QTE__', '"'
               ), '__CHEVR__', '^'
     ),1,50) as file_text
   , CONCAT('http://192.168.1.133/wp-admin/wp-content/uploads/2023/11/',REPLACE(file_name,'.pdf','.txt'),'||FULL TEXT') as link
   ,  upload_date
   ,  source_url
   ,  uploaded_by
   -- https://wpdatatables.com||Check out wpDataTables
 FROM wp_auto_upload_file
 ;
