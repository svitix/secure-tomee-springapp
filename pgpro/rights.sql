-- clean
DROP TABLE IF EXISTS work.test;
DROP SCHEMA IF EXISTS work;
DROP DATABASE IF EXISTS eko;

DROP ROLE IF EXISTS ekoupdateui;
DROP ROLE IF EXISTS ekoadminui;
DROP ROLE IF EXISTS ekoadmin;
DROP ROLE IF EXISTS ekoupdate;
DROP ROLE IF EXISTS auditor;
DROP ROLE IF EXISTS eko;


-- eko
create role eko;
alter role eko login;
alter role eko password '4321';


-- eko database
create database eko with owner eko;
grant connect on database eko to eko;


REVOKE ALL ON schema public FROM public;
-- if not needed
revoke all on database eko from public;

\c eko
CREATE SCHEMA work AUTHORIZATION eko;
create table work.test(id int);
alter table work.test owner to eko;

create role ekoadmin;
create role ekoupdate;

grant eko to ekoadmin, ekoupdate;
revoke all on database eko from ekoadmin, ekoupdate;
grant connect on database eko to ekoadmin, ekoupdate;
grant all privileges on schema work to ekoadmin, ekoupdate;

create role ekoadminui LOGIN PASSWORD '4321';
create role ekoupdateui LOGIN PASSWORD '4321';

grant ekoadmin to ekoadminui;
grant ekoupdate to ekoupdateui;


-- audit
create role auditor;
grant select on table work.test to auditor;
grant auditor to ekoadmin;  
grant auditor to ekoupdate;  

--удалить из search_path схему public;