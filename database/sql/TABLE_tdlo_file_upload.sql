
CREATE TABLE IF NOT EXISTS tdlo_file_upload 
(
     file_id bigint(20) unsigned NOT NULL AUTO_INCREMENT
  ,  file_name text DEFAULT NULL
  ,  file_path text DEFAULT NULL
  ,  file_size int(11) DEFAULT NULL
  ,  file_cacl text DEFAULT NULL
  ,  file_owner text DEFAULT NULL
  ,  file_group text DEFAULT NULL
  ,  file_shasum text DEFAULT NULL
  ,  file_sha256sum text DEFAULT NULL
  ,  file_sha512sum text DEFAULT NULL
  ,  file_info text DEFAULT NULL
  ,  wp_wfu_idlog int(11) DEFAULT NULL
  ,  file_text LONGTEXT DEFAULT NULL
  ,  file_title  text DEFAULT NULL
  ,  upload_date datetime DEFAULT CURRENT_TIMESTAMP
  ,  source_url text DEFAULT NULL
  ,  uploaded_by text DEFAULT NULL
  ,  PRIMARY KEY (file_id)
  ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci; """
