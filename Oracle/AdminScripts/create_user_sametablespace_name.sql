-- -------------------------
-- 2012-06-21.CCP
-- Create user on Oracle.
-- -------------------------
-- &1 - Schema name AND tablespace name
-- &2 - Password
-- &3 - Tablespace
-- ----------------------------
-- Modification history
-- ---------------------
-- 2012-09-04.ccp - pause and exit added (as it is executed from command file)
-- 2015.10.02.ccp - pause put in comment (as used from powershell)
-- 2020.11.08.CCP - separate user from tablespace parameter
-- ----------------------------


CREATE USER &1
  IDENTIFIED BY &2
  DEFAULT TABLESPACE &3
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

  GRANT CONNECT TO &1 WITH ADMIN OPTION;
  ALTER USER &1 DEFAULT ROLE ALL;

  GRANT ALTER ANY TYPE TO &1 WITH ADMIN OPTION;
  GRANT CREATE TYPE TO &1 WITH ADMIN OPTION;
  GRANT CREATE TABLE TO &1 WITH ADMIN OPTION;
  GRANT ALTER ANY TRIGGER TO &1 WITH ADMIN OPTION;
  GRANT ALTER ANY TABLE TO &1 WITH ADMIN OPTION;
  GRANT ALTER ANY PROCEDURE TO &1 WITH ADMIN OPTION;
  GRANT ALTER SESSION TO &1 WITH ADMIN OPTION;
 
  GRANT CREATE TRIGGER TO &1 WITH ADMIN OPTION;
  GRANT CREATE PROCEDURE TO &1 WITH ADMIN OPTION;
  GRANT CREATE VIEW TO &1 WITH ADMIN OPTION;
  GRANT CREATE ANY SEQUENCE TO &1 WITH ADMIN OPTION;

  ALTER USER &1 QUOTA UNLIMITED ON &3;

--accept l_input prompt 'Press <Enter> key to exit!'

exit;
