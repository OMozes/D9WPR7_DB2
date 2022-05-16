CREATE TABLE Bank (
Id NUMBER(4) PRIMARY KEY,
Nev varchar2(50),
Cim varchar2(30),
Alapitasev DATE,
Ertek NUMBER(4)
);
----------------------------------------------------------------------

CREATE TABLE Banki_ugyfelek (
Id INTEGER PRIMARY KEY,
Nev varchar2(50),
Szulido DATE,
Szulhely varchar2(35),
Elegedettsegimezo NUMBER(2),
Jelszo varchar2(25),
Bankid INT REFERENCES Bank (Id)
);
----------------------------------------------------------------------

create table
EmpLog ( id
number primary
key, operation
varchar2(20),
o_date timestamp
default
current_timestamp,
data varchar2(70),
status varchar2(5)
default 'new'
);
----------------------------------------------------------------------

BEGIN
INSERT INTO Bank VALUES (1,'MKB','1679 Et Ave','2012-December-30',45);
INSERT INTO Bank VALUES (2,'OTP','Ap 947-249 HendreritRd.','1971-November-29',19);
INSERT INTO Bank VALUES (3,'KandH','3535 Miskolc','1980-December-01',35);
INSERT INTO Bank VALUES (4,'Erste','P.O. Box 606, 9135 Magna.Rd.','1969-December-05',18);
INSERT INTO Bank VALUES (5,'UniCredit','P.O. Box 248, 7330 AcRoad','1954-Július-03',45);
INSERT INTO Bank VALUES (6,'Gránit','P.O. Box 265, 7345 AcRoad','1967-Január-05',61);
INSERT INTO Bank VALUES (7,'Takarék','2234 Maglód. 1.','1967-Június-20',30);
INSERT INTO Bank VALUES (8,'Raiffeisen','1077 Budapest','1943-Június-03',12);
end;
----------------------------------------------------------------------

BEGIN
INSERT INTO Banki_ugyfelek VALUES (1,'Abdul','1980-március-12','Warminster',7,'in',1);
INSERT INTO Banki_ugyfelek VALUES (2,'Quail','1990-január-06','Flamierge',9,'massa',2);
INSERT INTO Banki_ugyfelek VALUES (3,'Cedric','1975-április-16','Berlin',9,'Proin',3);
INSERT INTO Banki_ugyfelek VALUES (4,'Josiah','1990-február-15','Tryokhgorny',7,'non,',4);
INSERT INTO Banki_ugyfelek VALUES (5,'Ralph','1994-március-12','Wepion',8,'turpis',5);
INSERT INTO Banki_ugyfelek VALUES (6,'Zeph','1986-augusztus-22','Radebeul',4,'tellus',6);
INSERT INTO Banki_ugyfelek VALUES (7,'Deacon','1983-július-29','Chagai',2,'et',7);
INSERT INTO Banki_ugyfelek VALUES (8,'Joe','2000-december-15','Castelmezzano',10,'egestas',8);
INSERT INTO Banki_ugyfelek VALUES (9,'Amelia','1978-június03','Vancouver',5,'amet',7);
INSERT INTO Banki_ugyfelek VALUES (10,'Harding','1986-április-26','Dieppe',10,'Sed',6);
end;
----------------------------------------------------------------------

create or replace function PassGen (inlength in number, intype in number) return varchar2 as
c_data varchar2(100) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
c_digits varchar2(10) := '0123456789';
c_specs varchar2(30) := '~!@#%^&*()-_=[{]}:<>?';
c_k char(1);
ps varchar(20):='';
begin
if intype > 1 then
c_data:=c_data||c_digits;
end if;
if intype = 3 then
c_data :=c_data||c_specs;
end if;
for i in 1 .. inlength loop
c_k := substr(c_data, round(dbms_random.value() * length(c_data))+1, 1);
ps:=ps||c_k;
end loop;
return ps;
end;

select Passgen(10,3) from dual;
----------------------------------------------------------------------

create or replace procedure InsertEmp(inname in varchar2,szulhely in varchar2,eleg in number,szuli in date,bank in varchar2) as
uname varchar2(40):=inname;
password varchar2(20):=PassGen(8, 3);
szul varchar2(40):=szulhely;
elegedettsegimezo number:=eleg;
szulido date:=szuli;
bankid number;
pc number;
begin
select count(*) into pc from bank where nev like '%'||bank||'%';
if pc=0 then
dbms_output.put_line(pc);
dbms_output.put_line('nincs ilyen adat a bank tálába');
else
select id into bankid from bank where nev like '%'||bank||'%';
insert into banki_ugyfelek values(NEWIDBANKI_UGYELEK.nextval,uname,szulido,szul,elegedettsegimezo,password,bankid);
end if;
end;

begin
InsertEmp('Kiss Jani','Gyula',10,'2000-Február-10','MKB');
end;
----------------------------------------------------------------------

create or replace procedure InsertBank(bankname in varchar2,address in varchar2,alap in date,val in number) as
name varchar2(20):=bankname;
add varchar2(40):=address;
ertek number:=val;
szulido date:=alap;
nagyertek EXCEPTION;
begin
if ertek not between 1 and 100 then
raise nagyertek;
else
insert into bank values(BANKID_SEQUENCE.nextval,name,add,szulido,ertek);
end if;
EXCEPTION
when nagyertek then
dbms_output.put_line('Túl nagy az érték');
end;

begin
InsertBank('Béla','asdasd','1985-december-02',20);
commit;
end;
----------------------------------------------------------------------

create or replace procedure Bankupdate(tablenev in varchar2,bfield in varchar2,adat in varchar2,bid in number) as
begin
if(tablenev='Bank')then
case
when bfield='Nev' then
update bank set nev=adat where id=bid;
when bfield='cim' then
update bank set cim=adat where id=bid;
when bfield='alapitasev' then
update bank set alapitasev=adat where id=bid;
when bfield='ertek' then
update bank set ertek=adat where id=bid;
end CASE;
else if(tablenev='banki_ugyfelek') then
case
when bfield='nev' then
update banki_ugyfelek set nev=adat where id=bid;
when bfield='szulido' then
update banki_ugyfelek set szulido=adat where id=bid;
when bfield='szulhely' then
update banki_ugyfelek set szulhely=adat where id=bid;
when bfield='elegedettsegimezo' then
update banki_ugyfelek set elegedettsegimezo=adat where id=bid;
when bfield='jelszo' then
update banki_ugyfelek set Jelszo=adat where id=bid;
when bfield='bankid' then
update banki_ugyfelek set Bankid=adat where id=bid;
end case;
end if;
end if;
end;

Begin
Bankupdate('Bank','cim','Damjanich utca 20/1',42);
end;

Begin
Bankupdate('Bank','cim','Damjanich utca 20/1',42);
end;
----------------------------------------------------------------------

create or replace procedure delemp(inlowlimit in number, inupperlimit in number) as
cursor adatok is select * from banki_ugyfelek where id between inLowlimit and inupperlimit;
x varchar2(3) := '#';
data varchar2(70);
begin
for a in adatok loop
delete from banki_ugyfelek where id=a.id;
data:= a.id||x||a.nev||a.szulido||x||a.szulhely||x||a.elegedettsegimezo||x||a.jelszo||a.bankid;
dbms_output.put_line('Törölt adatsor: '||data);
End loop;
end;

begin
delemp(8,10);
end;
----------------------------------------------------------------------

create or replace procedure DelBank(inname in varchar2, inid in number) as
n_pc1 number;
n_pc2 number;
n_pc number;
x varchar2(3):= '#';
c_id varchar2(10);
c_cim varchar2(60);
c_name varchar2(40);
c_alapev varchar2(15);
c_ertek varchar2(20);
data varchar2(70);
begin
select count(*) into n_pc1 from bank where nev=inname;
select count(*) into n_pc2 from bank where Id=inid;
n_pc := n_pc1 + n_pc2;
if n_pc <> 1 then
dbms_output.put_line('Hibás paraméterezés vagy adat');
dbms_output.put_line('ha nevet ad meg, akkor az id legyen =0');
dbms_output.put_line('Ha ID-t ad meg, akkor a név legyen = "" ');
else if n_pc1 = 1 then
select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from bank where nev=inname;
data:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
delete from bank where nev=inname;
dbms_output.put_line('Törölt adatsor: '||data);
else if n_pc2 = 1 then select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from bank where id=inid;
data:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
delete from bank where id=inid;
dbms_output.put_line('Törölt adatsor: '||data);
end if;
end if;
end if;
end;

begin
Delbank('', 42);
end;
----------------------------------------------------------------------

create or replace function banklekerdezes(neve in varchar2) return varchar2 as
adatok varchar2(70);
c_id varchar2(10);
c_cim varchar2(60);
c_name varchar2(40);
c_alapev varchar2(15);
c_ertek varchar2(20);
x varchar2(3):= '#';
begin
select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from Bank Where nev like '%'||neve||'%';
adatok:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
return adatok;
end;

select banklekerdezes('MKB') from dual;
----------------------------------------------------------------------

create or replace function banki_ugyfeleklekerdezes(neve in varchar2) return varchar2 as
adatok varchar2(70);
c_id varchar2(10);
c_name varchar2(40);
c_szulido varchar2(60);
c_szulhely varchar2(60);
c_eleg varchar2(20);
c_jelszo varchar2(40);
c_bankid varchar2(10);
x varchar2(3):= '#';
begin
select id,nev,szulido,szulhely,elegedettsegimezo,jelszo,bankid into c_id,c_name,c_szulido,c_szulhely,c_eleg,c_jelszo,c_bankid from Banki_ugyfelek Where nev like '%'||neve||'%';
adatok:=c_id||x||c_name||x||c_szulido||x||c_szulhely||x||c_eleg||x||c_jelszo||x|| c_bankid;
return adatok;
end;

select banki_ugyfeleklekerdezes ('Abdul') from dual;
----------------------------------------------------------------------

create or replace function bankelegossz(neve in varchar2) return varchar2 as
ertek number;
id_n number;
begin
select id into id_n from bank where nev like '%'||neve||'%';
select sum(elegedettsegimezo) into ertek from banki_ugyfelek where bankid=id_n;
return ertek;
end;

select bankelegossz('Takarék') from dual;
----------------------------------------------------------------------

create or replace package bankprog as 
procedure Bankupdate(tablenev in varchar2,bfield in varchar2,adat in varchar2,bid in number);
procedure DelBank(inname in varchar2, inid in number);
procedure InsertBank(bankname in varchar2,address in varchar2,alap in date,val in number);
procedure kiirbank;
function bankatlagos(neve in varchar2) return varchar2;
function banklekerdezes(neve in varchar2) return varchar2;
function bankmaxertek return varchar2;
function NewIdBank return number;
end;
----------------------------------------------------------------------

create or replace package body bankprog as 
procedure Bankupdate(tablenev in varchar2,bfield in varchar2,adat in varchar2,bid in number) as 
begin 
if(tablenev='Bank') then
case
when bfield='Nev' then 
update bank set nev=adat where id=bid;
when bfield='cim' then 
update bank set cim=adat where id=bid;
when bfield='alapitasev' then 
update bank set alapitasev=adat where id=bid;
when bfield='ertek' then 
update bank set ertek=adat where id=bid;
end CASE;
else if(tablenev='banki_ugyfelek') then 
case 
when bfield='nev' then 
update banki_ugyfelek set nev=adat where id=bid;
when bfield='szulido' then 
update banki_ugyfelek set szulido=adat where id=bid;
when bfield='szulhely' then 
update banki_ugyfelek set szulhely=adat where id=bid; 
when bfield='elegedettsegimezo' then 
update banki_ugyfelek set elegedettsegimezo=adat where id=bid; 
when bfield='jelszo' then 
update banki_ugyfelek set Jelszo=adat where id=bid; 
when bfield='bankid' then 
update banki_ugyfelek set Bankid=adat where id=bid;
end case;
end if;
end if;
end;
procedure DelBank(inname in varchar2, inid in number) as
n_pc1 number;
n_pc2 number;
n_pc number;
x varchar2(3):= '#';
c_id varchar2(10);
c_cim varchar2(60);
c_name varchar2(40);
c_alapev varchar2(15);
c_ertek varchar2(20);
data varchar2(70);
begin
select count(*) into n_pc1 from bank where nev=inname;
select count(*) into n_pc2 from bank where Id=inid;
n_pc := n_pc1 + n_pc2;
if n_pc <> 1 then
dbms_output.put_line('Hibás paraméterezés vagy adat');
dbms_output.put_line('ha nevet ad meg, akkor az id legyen =0');
dbms_output.put_line('Ha ID-t ad meg, akkor a név legyen = "" ');
else if n_pc1 = 1 then
select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from bank where nev=inname;
data:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
delete from bank where nev=inname;
dbms_output.put_line('Törölt adatsor: '||data);
else if n_pc2 = 1 then select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from bank where id=inid;
data:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
delete from bank where id=inid;
dbms_output.put_line('Törölt adatsor: '||data);
end if;
end if;
end if;
end;
procedure InsertBank(bankname in varchar2,address in varchar2,alap in date,val in number) as
name varchar2(20):=bankname;
add varchar2(40):=address;
ertek number:=val;
szulido date:=alap;
nagyertek EXCEPTION;
begin
if ertek not between 1 and 100 then
raise nagyertek;
else
insert into bank values(BANKID_SEQUENCE.nextval,name,add,szulido,ertek);
end if;
EXCEPTION
when nagyertek then
dbms_output.put_line('Túl nagy az érték');
end;
procedure kiirbank as
Cursor adatok is Select * From bank;
file utl_file.file_type;
dat char(70);
x varchar2(3):='#';
begin
file :=UTL_file.Fopen('PLSQL','bank.txt','w');
for c in adatok loop
dat:= c.id||x||c.nev||x||c.cim||x||c.alapitasev||x||c.ertek;
utl_file.put_line(file, dat);
end loop;
utl_file.fclose(file);
end;
function bankatlagos(neve in varchar2) return varchar2 as
ertek number;
id_n number;
begin
select id into id_n from bank where nev like '%' ||neve||'%';
select sum(elegedettsegimezo) into ertek from banki_ugyfelek where bankid=id_n;
return ertek;
end;
function banklekerdezes(neve in varchar2) return varchar2 as
adatok varchar2(70);
c_id varchar2(10);
c_cim varchar2(60);
c_name varchar2(40);
c_alapev varchar2(15);
c_ertek varchar2(20);
x varchar2(3):= '#';
begin
select id,nev,cim,alapitasev,ertek into c_id,c_name,c_cim,c_alapev,c_ertek from Bank Where nev like '%'||neve||'%';
adatok:=c_id||x||c_name||x||c_cim||x||c_alapev||x||c_ertek;
return adatok;
end;
function bankmaxertek return varchar2 as
ertek number;
begin
select sum(elegedettsegimezo) into ertek from banki_ugyfelek where bankid=1;
return ertek;
end;
function NewIdBank return number as
maxid number:=0;
begin
select max(id) into maxid from bank;
if maxid > 0 then
return maxid+ 1;
else 
return 1;
end if;
end;
end;


begin
bankprog.Bankupdate('Bank','ertek','70',90);
end;

select * from bank

begin
bankprog.Delbank('otp2','');
end;

select * from bank

begin 
bankprog.insertbank('otp2','János utca 3','1930-Május-20',80);
end;

select * from bank

select bankprog.bankatlagos('MKB') from dual

select bankprog.banklekerdezes('MKB') from dual

select bankprog.bankmaxertek from dual

select bankprog.NewIDBank from dual
----------------------------------------------------------------------

create or replace procedure kiirbanki_ugyfelek as
Cursor adatok is Select * From banki_ugyfelek;
file utl_file.file_type;
dat char(70);
x varchar2(3):='#';
begin
file :=UTL_file.Fopen('PLSQL','banki_ugyfelek.txt','w');
for c in adatok loop
dat:= c.id||x||c.nev||x||c.szulido||x||c.szulhely||x||c.elegedettsegimezo||x||c.jelszo||x||c.bankid;
utl_file.put_line(file, dat);
end loop;
utl_file.fclose(file);
end;   
----------------------------------------------------------------------

create or replace package banki_ugyfelekprog as
procedure InsertEmp (inname in varchar2,szulhely in varchar2,eleg in number,szuli in date,bank in varchar2);
procedure kiirbanki_ugyfelek;
procedure delemp(inlowlimit in number, inupperlimit in number);
function banki_ugyfeleklekerdezes(neve in varchar2) return varchar2;
end;
----------------------------------------------------------------------

create or replace package body banki_ugyfelekprog as
procedure InsertEmp(inname in varchar2,szulhely in varchar2,eleg in number,szuli in date,bank in varchar2) as
uname varchar2(40):=inname;
password varchar2(20):=PassGen(8, 3);
szul varchar2(40):=szulhely;
elegedettsegimezo number:=eleg;
szulido date:=szuli;
bankid number;
pc number;
begin
select count(*) into pc from bank where nev like '%'||bank||'%';
if pc=0 then
dbms_output.put_line(pc);
dbms_output.put_line('nincs ilyen adat a bank tálába');
else
select id into bankid from bank where nev like '%'||bank||'%';
insert into banki_ugyfelek values(NEWIDBANKI_UGYELEK.nextval,uname,szulido,szul,elegedettsegimezo,password,bankid);
end if;
end;
procedure kiirbanki_ugyfelek as
Cursor adatok is Select * From banki_ugyfelek;
file utl_file.file_type;
dat char(70);
x varchar2(3):='#';
begin
file :=UTL_file.Fopen('PLSQL','banki_ugyfelek.txt','w');
for c in adatok loop
dat:= c.id||x||c.nev||x||c.szulido||x||c.szulhely||x||c.elegedettsegimezo||x||c.jelszo||x||c.bankid;
utl_file.put_line(file, dat);
end loop;
utl_file.fclose(file);
end;   
procedure delemp(inlowlimit in number, inupperlimit in number) as
cursor adatok is select * from banki_ugyfelek where id between inLowlimit and inupperlimit;
x varchar2(3) := '#';
data varchar2(70);
begin
    for a in adatok loop
    delete from banki_ugyfelek where id=a.id;
    data:= a.id||x||a.nev||a.szulido||x||a.szulhely||x||a.elegedettsegimezo||x||a.jelszo||a.bankid;
    dbms_output.put_line('Törölt adatsor: '||data);
    End loop;
    end;
function banki_ugyfeleklekerdezes(neve in varchar2) return varchar2 as
adatok varchar2(70);
c_id varchar2(10);
c_name varchar2(40);
c_szulido varchar2(60);
c_szulhely varchar2(60);
c_eleg varchar2(20);
c_jelszo varchar2(40);
c_bankid varchar2(10);
x varchar2(3):= '#';
begin
select id,nev,szulido,szulhely,elegedettsegimezo,jelszo,bankid into c_id,c_name,c_szulido,c_szulhely,c_eleg,c_jelszo,c_bankid from Banki_ugyfelek Where nev like '%'||neve||'%';
adatok:=c_id||x||c_name||x||c_szulido||x||c_szulhely||x||c_eleg||x||c_jelszo||x|| c_bankid;
return adatok;
end;
end;

begin
banki_ugyfelekprog.InsertEmp('Ultra Ibolya','Budapest',15,'1975-Április-20','MKB');
end;

select * from banki_ugyfelek;
----------------------------------------------------------------------

create or replace procedure Logger(inoperation in varchar2, indata in varchar2) as
newid number;
begin 
select max(id) into newid from Emplog;
if newid > 0 then
newid:= newid+1;
else
newid:= 1;
end if;
insert into emplog (id,operation,data) values (newid,inoperation,indata);
end;
----------------------------------------------------------------------

create or replace trigger Bankiugyfeleklog
after insert or delete or update on Banki_ugyfelek
for each row
DECLARE
dat char(70);
idd number;
idd2 number;
x varchar2(3):='#';
begin
if inserting then
dat:= :new.id||x||:new.nev||x||:new.szulido||x||:new.szulhely||x||:new.elegedettsegimezo||x||:new.jelszo||x||:new.bankid;
logger('insert',dat);
else if deleting then
dat:= :old.id||x||:old.nev||x||:old.szulido||x||:old.szulhely||x||:old.elegedettsegimezo||x||:old.jelszo||x||:old.bankid;
logger('delete',dat);
else 
dat:= :new.id||x||:new.nev||x||:new.szulido||x||:new.szulhely||x||:new.elegedettsegimezo||x||:new.jelszo||x||:new.bankid;
logger('update',dat);
end if;
end if;
end;
----------------------------------------------------------------------

create or replace procedure FelhBackUp(datafel in varchar2) as
felh varchar2(150);
n_pc number;
n1 varchar2(70);
n2 varchar2(70);
n3 varchar2(70);
n4 varchar2(70);
n5 varchar2(70);
n6 varchar2(70);
n7 varchar2(70);
s_1 number;
s_2 number;
s_3 number;
s_4 number;
s_5 number;
s_6 number;
n_id number;
begin
select count(*) into n_pc from emplog where data LIKE '%'||datafel||'%';
if n_pc = 0 then
dbms_output.put_line('Hibás paraméterezés,vagy nincs ilyen adat');
ELSe
select data into felh from emplog where data like '%'||datafel||'%';
select max(id) into n_id from banki_ugyfelek;
s_1 := instr(felh,'#',1,1);
s_2 := instr(felh,'#',1,2);
s_3 := instr(felh,'#',1,3);
s_4 := instr(felh,'#',1,4);
s_5 := instr(felh,'#',1,5);
s_6 := instr(felh,'#',1,6);
  n1:= substr(felh,1,s_1-1);
  n2:= substr(felh,s_1+1,s_2-s_1-1);
  n3:= substr(felh,s_2+1,s_3-s_2-1);
  n4:= substr(felh,s_3+1,s_4-s_3-1);
  n5:= substr(felh,s_4+1,s_5-s_4-1);
  n6:= substr(felh,s_5+1,s_6-s_5-1);
  n7:= substr(felh,s_6+1,1);
insert into banki_ugyfelek values(n_id+1,n2,n3,n4,n5,n6,n7);
END IF;
end;	

begin 
FelhBackUp('Harding');
end;
select * from banki_ugyfelek;
----------------------------------------------------------------------

create or replace trigger Banklog
after insert or delete or update on Bank
for each row
DECLARE
dat char(70);
idd number;
idd2 number;
x varchar2(3):='#';
begin
if inserting then
dat:= :new.id||x||:new.nev||x||:new.cim||x||:new.alapitasev||x||:new.ertek;
logger('insert',dat);
else if deleting then
dat:= :old.id||x||:old.nev||x||:old.cim||x||:old.alapitasev||x||:old.ertek;
logger('delete',dat);
else 
dat:= :new.id||x||:new.nev||x||:new.cim||x||:new.alapitasev||x||:new.ertek;
logger('update',dat);
end if;
end if;
end;
----------------------------------------------------------------------

create or replace procedure BankBackUp(datafel in varchar2) as
felh varchar2(150);
n_pc number;
n1 varchar2(70);
n2 varchar2(70);
n3 varchar2(70);
n4 varchar2(70);
n5 varchar2(70);

s_1 number;
s_2 number;
s_3 number;
s_4 number;
n_id number;
begin
select count(*) into n_pc from emplog where data LIKE '%'||datafel||'%';
if n_pc = 0 then
dbms_output.put_line('Hibás paraméterezés,vagy nincs ilyen adat');
ELSe
select data into felh from emplog where data like '%'||datafel||'%';
select max(id) into n_id from bank;
s_1 := instr(felh,'#',1,1);
s_2 := instr(felh,'#',1,2);
s_3 := instr(felh,'#',1,3);
s_4 := instr(felh,'#',1,4);
  n1:= substr(felh,1,s_1-1);
  n2:= substr(felh,s_1+1,s_2-s_1-1);
  n3:= substr(felh,s_2+1,s_3-s_2-1);
  n4:= substr(felh,s_3+1,s_4-s_3-1);
  n5:= substr(felh,s_4+1,1);
insert into bank values(n_id+1,n2,n3,n4,n5);
END IF;
end;

begin
FelhBackUp('OTP2');
end;
select * from bank;

begin 
BankBackUp('otp2');
end;
select * from bank;
----------------------------------------------------------------------

create or replace TRIGGER bankid
	Before insert on Bank
	For each row
Begin
	select bankid_sequence.nextval
	into :new.id
	from dual;
end;
----------------------------------------------------------------------

create or replace trigger ertek_kontroll
before update on bank
for each row
BEGIN
if (:new.ertek<0) then
:new.ertek := 1;
else if (:new.ertek>100) then
:new.ertek := 100;
end if;
end if;
end;
----------------------------------------------------------------------

create or replace procedure Logger(inoperation in varchar2, indata in varchar2) as
newid number;
begin 
select max(id) into newid from Emplog;
if newid > 0 then
newid:= newid+1;
else
newid:= 1;
end if;
insert into emplog (id,operation,data) values (newid,inoperation,indata);
end;
----------------------------------------------------------------------

declare
JobNo number;
JobNoBankiugyfelek number;
begin
DBMS_JOB.SUBMIT(JobNo, 'kiirbanki_ugyfelek;', (SYSDATE+1/24), 'SYSDATE+1');
DBMS_JOB.SUBMIT(JobNo, 'kiirbank;', (SYSDATE+1/24), 'SYSDATE+1');
commit;
dbms_output.put_line('A job száma: || jobno');
end;
----------------------------------------------------------------------

create or replace procedure bankokinsert as
TYPE bank_rec_type IS RECORD(id number,name varchar2(20), cim varchar2(60), alapev date, ertek number);
TYPE bank_array_type IS VARRAY (3) of bank_rec_type;
bank_rec bank_array_type := bank_array_type();

Begin
bank_rec.extend;
bank_rec(1).id := BANKID_SEQUENCE.nextval;
bank_rec(1).name := 'otp3';
bank_rec(1).cim := 'Petőfi utca 3';
bank_rec(1).alapev := '1995-január-20';
bank_rec.extend;
bank_rec(1).id := BANKID_SEQUENCE.nextval;
bank_rec(2).name := 'KNH';
bank_rec(2).cim := 'Arany Janos 10';
bank_rec(2).alapev := '1950-December-08';
bank_rec.extend;
bank_rec(1).id := BANKID_SEQUENCE.nextval;
bank_rec(3).name := 'GBH';
bank_rec(3).cim := 'Damjanich ut 10/2';
bank_rec(3).alapev := '2010-December-03';
FOR i in 1 .. 3 LOOP
bank_rec(i).ertek := round(dbms_random.value(1,99));
DBMS_Output.PUT_LINE('Name: '||bank_rec(i).name||' Cim is: '||bank_rec(i).cim||' Alapitasev: '||bank_rec(3).alapev);
insert into bank values bank_rec(i);
end loop;
end;



