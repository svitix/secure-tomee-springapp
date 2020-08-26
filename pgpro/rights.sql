
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
alter role eko encrypted password '4321';

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




-- ekoadmin
create role ekoadmin;
grant eko to ekoadmin;
revoke all on database eko from ekoadmin;
grant connect on database eko to ekoadmin;
grant all privileges on schema work to ekoadmin;
grant all privileges on table work.test to ekoadmin;

create role ekoadminui;
grant ekoadmin to ekoadminui;
alter role ekoadminui login;
alter role ekoadminui password '4321';



--ekoupdate
create role ekoupdate;
revoke all on database eko from ekoupdate;
grant connect on database eko to ekoupdate;
revoke all on database eko from ekoupdate;
--grant all privileges on table work.test to ekoupdate;

create role ekoupdateui;
grant ekoupdate to ekoupdateui;
alter role ekoupdateui login;
alter role ekoupdateui password '4321';

-- audit
create role auditor;
grant select on table work.test to auditor;
grant auditor to ekoadmin;  
grant auditor to ekoupdate;  

--удалить из search_path схему public;