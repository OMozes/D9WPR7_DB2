CREATE TABLE Repulojaratok (
Id INTEGER PRIMARY KEY,
Cel varchar2(80),
Indulas DATE,
Tipus varchar2(80)
);

CREATE TABLE Utasok (
Id INTEGER PRIMARY KEY,
Nev varchar2(50),
Poggyasztomeg NUMBER(4),
Jegyvasarlasdatuma DATE,
Repulojaratokid INT REFERENCES Repulojaratok (Id)
);

create table RepuloLog (
id INTEGER primary key,
operation varchar2(20),
o_date timestamp default current_timestamp,
data varchar2(150),
status varchar2(5) default 'new'
);

CREATE OR REPLACE TRIGGER  repulojaratok_trigger
  before insert on Repulojaratok             
  for each row  
BEGIN
  SELECT repulojaratok_sequence.nextval
  INTO :new.id
  FROM dual;
END;

create or replace procedure InsertRepulojaratok(incel in varchar2,inindulas in date,intipus in varchar2) as
cel varchar2(40):=incel;
indulas date:=inindulas;
tipus varchar2(40):=intipus;
nagyertek EXCEPTION;
begin
insert into Repulojaratok values(repulojaratok_sequence.nextval,cel,indulas,tipus);
end;

BEGIN
InsertRepulojaratok('Dubai','2019-december-02','B737MAX');
commit;
end;

select * from repulojaratok;

CREATE OR REPLACE TRIGGER  utasok_trigger
  before insert on Utasok             
  for each row  
BEGIN
  SELECT utasok_sequence.nextval
  INTO :new.id
  FROM dual;
END;

create or replace procedure insertUtasok(innname in varchar2,poggy in number,jegy in date,repulo in varchar2,repuloid in number) as
nev varchar2(50):=innname;
poggyasztomeg number:=poggy;
jegyvasarlasdatuma date:=jegy;
repulojaratokid number;
pca number;
begin
select count(*) into pca from repulojaratok where id like '%'||repuloid||'%';
if pca=0 then
dbms_output.put_line(pca);
dbms_output.put_line('nincs ilyen adat a repulojaratok táblába');
else
select id into repulojaratokid from repulojaratok where id like '%'||repuloid||'%';
insert into utasok values(utasok_sequence.nextval,nev,poggyasztomeg,jegyvasarlasdatuma,repulojaratokid);
end if;
end;

begin
insertUtasok('Nagy Jani',55,'2017-november-10',2,1);
end;

create or replace procedure Repulojaratokupdate(tablenev in varchar2,bfield in varchar2,
adat in varchar2,bid in number) as
begin
if(tablenev='Repulojaratok')then
case
when bfield='Cel' then
update Repulojaratok set cel=adat where id=bid;
when bfield='indulas' then
update Repulojaratok set indulas=adat where id=bid;
when bfield='tipus' then
update Repulojaratok set tipus=adat where id=bid;
end CASE;
else if(tablenev='Utasok') then
case
when bfield='nev' then
update utasok set nev=adat where id=bid;
when bfield='poggyasztomeg' then
update utasok set poggyasztomeg=adat where id=bid;
when bfield='jegyvasarlasdatuma' then
update utasok set jegyvasarlasdatuma=adat where id=bid;
when bfield='repulojaratokid' then
update utasok set Repulojaratokid=adat where id=bid;
end case;
end if;
end if;
end;

begin
Repulojaratokupdate ('Repulojaratok','Cel','Hawaii',1);
end;

select * from Repulojaratok;

begin
Repulojaratokupdate('Utasok','poggyasztomeg',100,1);
end;

select * from Utasok;

create or replace procedure delutasok(inlowlimit in number, inupperlimit in number) as
cursor adatok is select * from Utasok where id between inLowlimit and inupperlimit;
x varchar2(3) := '#';
data varchar2(70);
begin
for a in adatok loop
delete from Utasok where id=a.id;
data:= a.id||x||a.nev||a.poggyasztomeg||x||a.jegyvasarlasdatuma||x||a.repulojaratokid;
dbms_output.put_line('Törölt adatsor: '||data);
End loop;
end;

begin
delutasok(9,9);
end;

select * from Utasok;

create or replace procedure DelRepulojaratok(incel in varchar2, inid in number) as
n_pc1 number;
n_pc2 number;
n_pc number;
x varchar2(3):= '#';
c_id varchar2(10);
c_cel varchar2(80);
c_indulas varchar2(20);
c_tipus varchar2(80);
data varchar2(70);
begin
select count(*) into n_pc1 from Repulojaratok where cel=incel;
select count(*) into n_pc2 from Repulojaratok where Id=inid;
n_pc := n_pc1 + n_pc2;
if n_pc <> 1 then
dbms_output.put_line('Hibás paraméterezés vagy adat');
dbms_output.put_line('ha nevet ad meg, akkor az id legyen =0');
dbms_output.put_line('Ha ID-t ad meg, akkor a név legyen = "" ');
else if n_pc1 = 1 then
select id,cel,indulas,tipus into c_id,c_cel,c_indulas,c_tipus from Repulojaratok where cel=incel;
data:=c_id||x||c_cel||x||c_indulas||x||c_tipus;
delete from Repulojaratok where cel=incel;
dbms_output.put_line('Törölt adatsor: '||data);
else if n_pc2 = 1 then select id,cel,indulas,tipus into c_id,c_cel,c_indulas,c_tipus from Repulojaratok where id=inid;
data:=c_id||x||c_cel||x||c_indulas||x||c_tipus;
delete from Repulojaratok where id=inid;
dbms_output.put_line('Törölt adatsor: '||data);
end if;
end if;
end if;
end;

BEGIN
InsertRepulojaratok('Donyeck','2015-augusztus-11','Honda F9TB');
commit;
end;

begin
DelRepulojaratok('', 21);
end;

select * from RepuloJaratok;

create or replace procedure Logger(inoperation in varchar2, indata in varchar2) as
newid number;
begin 
select max(id) into newid from RepuloLog;
if newid > 0 then
newid:= newid+1;
else
newid:= 1;
end if;
insert into RepuloLog (id,operation,data) values (newid,inoperation,indata);
end;

create or replace trigger UtasokLog
after insert or delete or update on Utasok
for each row
DECLARE
dat char(70);
idd number;
idd2 number;
x varchar2(3):='#';
begin
if inserting then
dat:= :new.id||x||:new.nev||x||:new.poggyasztomeg||x||:new.jegyvasarlasdatuma||x||:new.repulojaratokid;
logger('insert',dat);
else if deleting then
dat:= :old.id||x||:old.nev||x||:old.poggyasztomeg||x||:old.jegyvasarlasdatuma||x||:old.repulojaratokid;
logger('delete',dat);
else 
dat:= :new.id||x||:new.nev||x||:new.poggyasztomeg||x||:new.jegyvasarlasdatuma||x||:new.repulojaratokid;
logger('update',dat);
end if;
end if;
end;

create or replace trigger RepulojaratokLog
after insert or delete or update on Repulojaratok
for each row
DECLARE
dat char(70);
idd number;
idd2 number;
x varchar2(3):='#';
begin
if inserting then
dat:= :new.id||x||:new.cel||x||:new.indulas||x||:new.tipus;
logger('insert',dat);
else if deleting then
dat:= :old.id||x||:old.cel||x||:old.indulas||x||:old.tipus;
logger('delete',dat);
else 
dat:= :new.id||x||:new.cel||x||:new.indulas||x||:new.tipus;
logger('update',dat);
end if;
end if;
end;

begin
insertUtasok('Közepes Lajos',33,'2020-augusztus-10',2,41);
end;

BEGIN
InsertRepulojaratok('Szentpétervár','2010-január-18','AS 12DD');
commit;
end;

begin
delutasok(41,41);
end;

begin
Repulojaratokupdate ('Repulojaratok','Cel','California',1);
end;

select * from RepuloLog;

create or replace function intervalumquery(firstin in date,secondin in date) return number as
first date:= firstin;
second date:= secondin;
counter number;
begin
select count(*) into counter from Utasok Where jegyvasarlasdatuma >= firstin and jegyvasarlasdatuma <= secondin; 
return counter;
end;

select intervalumquery('2019-november-9','2019-december-11') from dual

select * from utasok

create or replace package utasokpackage as
procedure insertUtasok(innname in varchar2,poggy in number,jegy in date,repulo in varchar2,repuloid in number);
procedure delutasok(inlowlimit in number, inupperlimit in number);
procedure Repulojaratokupdate(tablenev in varchar2,bfield in varchar2,adat in varchar2,bid in number);
function intervalumquery(firstin in date,secondin in date) return number;
end;
create or replace package body utasokpackage as
procedure insertUtasok(innname in varchar2,poggy in number,jegy in date,repulo in varchar2,repuloid in number) as
nev varchar2(50):=innname;
poggyasztomeg number:=poggy;
jegyvasarlasdatuma date:=jegy;
repulojaratokid number;
pca number;
begin
select count(*) into pca from repulojaratok where id like '%'||repuloid||'%';
if pca=0 then
dbms_output.put_line(pca);
dbms_output.put_line('nincs ilyen adat a repulojaratok táblába');
else
select id into repulojaratokid from repulojaratok where id like '%'||repuloid||'%';
insert into utasok values(utasok_sequence.nextval,nev,poggyasztomeg,jegyvasarlasdatuma,repulojaratokid);
end if;
end;
procedure delutasok(inlowlimit in number, inupperlimit in number) as
cursor adatok is select * from Utasok where id between inLowlimit and inupperlimit;
x varchar2(3) := '#';
data varchar2(70);
begin
for a in adatok loop
delete from Utasok where id=a.id;
data:= a.id||x||a.nev||a.poggyasztomeg||x||a.jegyvasarlasdatuma||x||a.repulojaratokid;
dbms_output.put_line('Törölt adatsor: '||data);
End loop;
end;
procedure Repulojaratokupdate(tablenev in varchar2,bfield in varchar2,
adat in varchar2,bid in number) as
begin
if(tablenev='Repulojaratok')then
case
when bfield='Cel' then
update Repulojaratok set cel=adat where id=bid;
when bfield='indulas' then
update Repulojaratok set indulas=adat where id=bid;
when bfield='tipus' then
update Repulojaratok set tipus=adat where id=bid;
end CASE;
else if(tablenev='Utasok') then
case
when bfield='nev' then
update utasok set nev=adat where id=bid;
when bfield='poggyasztomeg' then
update utasok set poggyasztomeg=adat where id=bid;
when bfield='jegyvasarlasdatuma' then
update utasok set jegyvasarlasdatuma=adat where id=bid;
when bfield='repulojaratokid' then
update utasok set Repulojaratokid=adat where id=bid;
end case;
end if;
end if;
end;
function intervalumquery(firstin in date,secondin in date) return number as
first date:= firstin;
second date:= secondin;
counter number;
begin
select count(*) into counter from Utasok Where jegyvasarlasdatuma >= firstin and jegyvasarlasdatuma <= secondin; 
return counter;
end;
end;

create or replace package repulojaratok_package as
procedure InsertRepulojaratok(incel in varchar2,inindulas in date,intipus in varchar2);
procedure DelRepulojaratok(incel in varchar2, inid in number);
end;
create or replace package body repulojaratok_package as
procedure InsertRepulojaratok(incel in varchar2,inindulas in date,intipus in varchar2) as
cel varchar2(40):=incel;
indulas date:=inindulas;
tipus varchar2(40):=intipus;
nagyertek EXCEPTION;
begin
insert into Repulojaratok values(repulojaratok_sequence.nextval,cel,indulas,tipus);
end;
procedure DelRepulojaratok(incel in varchar2, inid in number) as
n_pc1 number;
n_pc2 number;
n_pc number;
x varchar2(3):= '#';
c_id varchar2(10);
c_cel varchar2(80);
c_indulas varchar2(20);
c_tipus varchar2(80);
data varchar2(70);
begin
select count(*) into n_pc1 from Repulojaratok where cel=incel;
select count(*) into n_pc2 from Repulojaratok where Id=inid;
n_pc := n_pc1 + n_pc2;
if n_pc <> 1 then
dbms_output.put_line('Hibás paraméterezés vagy adat');
dbms_output.put_line('ha nevet ad meg, akkor az id legyen =0');
dbms_output.put_line('Ha ID-t ad meg, akkor a név legyen = "" ');
else if n_pc1 = 1 then
select id,cel,indulas,tipus into c_id,c_cel,c_indulas,c_tipus from Repulojaratok where cel=incel;
data:=c_id||x||c_cel||x||c_indulas||x||c_tipus;
delete from Repulojaratok where cel=incel;
dbms_output.put_line('Törölt adatsor: '||data);
else if n_pc2 = 1 then select id,cel,indulas,tipus into c_id,c_cel,c_indulas,c_tipus from Repulojaratok where id=inid;
data:=c_id||x||c_cel||x||c_indulas||x||c_tipus;
delete from Repulojaratok where id=inid;
dbms_output.put_line('Törölt adatsor: '||data);
end if;
end if;
end if;
end;
end;

BEGIN
utasokpackage.delutasok(43,43);
END;

select * from utasok;

select utasokpackage.intervalumquery('2019-november-10','2019-december-9') from dual;

select * from utasok;