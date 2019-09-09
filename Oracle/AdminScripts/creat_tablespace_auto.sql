-- 2012-06-20.ccp 
-- script pour création tablespaces
-- ---------------------------
-- Parameters
-- ----------------------------
-- &1 = datafile directory
-- &2 = tablespace name
-- &3 = talbespace size (exemple 100M)
-- 
-- ----------------------------
-- Modification history
-- ---------------------
-- 2012-09-04.ccp - pause and exit added (as it is executed from command file)
-- 2012-09-11.ccp - auto version (no input asked)
-- ----------------------------

CREATE TABLESPACE &2
   DATAFILE '&1.&2._tbl.dbf' SIZE &3
   DEFAULT STORAGE (INITIAL 128K NEXT 1M 
                    MINEXTENTS 1 MAXEXTENTS 999) 
   ONLINE;

-- accept l_input prompt 'Press <Enter> key to exit!'

exit;