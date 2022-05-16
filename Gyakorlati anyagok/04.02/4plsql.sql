set serverput on;

declare 
	vezetkenev Varchar(300);
	keresztnev(300);
begin
	dbms.output.put_line('Add meg a keresztnevet: ');
	keresztnev:=: keresztnev;
dbms.output.put_line('Add meg a vezetknevet');
	vezeteknev:=: vezeteknev;

	for i in 1...3 loop
if keresztnev like 'sir' THEN
dbms_output.put_line('ez nem is név');
else
	dbms_output.put_line(vezeteknev || ' ' ||:keresztnev);
end if;
end loop;

end;


5. Írjon egy olya PL/SQL programot, amely a beosztás rövidítése alapján megadja, a dolgozó teljes beosztását. (vezerles4.sql) pl. beosztas= 'root', ez alaőján kiírja : Rendszergazda(UNIX/LINUX)

set serverput on;

declare

	beosztas Varchar(300);
	teljes Varchar(300);






6. 
set serverput on;
a int(10)
b
c
s


7.gyak_k00pdf-et csináld meg töltsd fel háziként





select * from car


alter table car add(kor number(2));

alter table car add(year number(2));


declare
	year number(2);
	color varchar(10);
begin
	year:=: year;
	update auto;
	color :=: color
	update car set year =new year where color=color;
end




declare

begin
	update car set kor = year -to_char(sysdate. 'yyyy')
end


declare
	c constant car.color%type := 'white';
begin
	update car set manufacturer ='Suzuki" where color=c;
end
declare
	c constant car.color%type := 'white';
begin
	update car set manufacturer ='Suzuki" where color=c;
end
alter table car add(temp number(2));
declare
stmt char (100):=
begin
	e
declare
	nev_row car%rowtype;
begin
	new_row.id:=13;
	new_row.manufacturer: ='Seat';
	new_row.color:='white';
	new_row.price:=100;
	new_row.owner_id:=1;
	insert into car(id.manufacturer.color.price) values(:new_row.id, :new_row.manufacturer, :nwe_row.color, :new_color.price);
end
select *from car;
declare
	c car%rowtype;
	c_id car.id%type;
begin
	select * into c from car where id =:c_id;
	dbms_output_line(c.id || ' ' || c.manufacturer................);
