-- 2012-06-20.ccp 
-- script drop tablespaces
-- ---------------------------
-- Parameters
-- ----------------------------
-- &1 = tablespace name
-- 
-- ----------------------------
-- Modification history
-- ---------------------

drop tablespace &1 including contents and datafiles;

exit