-- clean
DROP TABLE IF EXISTS work.test;
DROP SCHEMA IF EXISTS work;
DROP DATABASE IF EXISTS kkk;

DROP ROLE IF EXISTS kkkupdateui;
DROP ROLE IF EXISTS kkkadminui;
DROP ROLE IF EXISTS kkkadmin;
DROP ROLE IF EXISTS kkkupdate;
DROP ROLE IF EXISTS auditor;
DROP ROLE IF EXISTS kkk;


-- kkk
create role kkk;
alter role kkk login;
alter role kkk password '4321';


-- kkk database
create database kkk with owner kkk;
grant connect on database kkk to kkk;


REVOKE ALL ON schema public FROM public;
-- if not needed
revoke all on database kkk from public;

\c kkk
CREATE SCHEMA work AUTHORIZATION kkk;
create table work.test(id int);
alter table work.test owner to kkk;

create role kkkadmin;
create role kkkupdate;

grant kkk to kkkadmin, kkkupdate;
revoke all on database kkk from kkkadmin, kkkupdate;
grant connect on database kkk to kkkadmin, kkkupdate;
grant all privileges on schema work to kkkadmin, kkkupdate;

create role kkkadminui LOGIN PASSWORD '4321';
create role kkkupdateui LOGIN PASSWORD '4321';

grant kkkadmin to kkkadminui;
grant kkkupdate to kkkupdateui;


-- audit
create role auditor;
grant select on table work.test to auditor;
grant auditor to kkkadmin;  
grant auditor to kkkupdate;  

--удалить из search_path схему public;