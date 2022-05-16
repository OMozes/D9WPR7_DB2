set serveroutput on;
declare 
    vezeteknev VARCHAR2(300);
    keresztnev VARCHAR2(300);
begin
    keresztnev:=:keresztnev;
    vezeteknev:=:vezeteknev;
    
    for i in 1..3 loop
        if keresztnev like 'sín' THEN
            dbms_output.put_line('Ez nem is név');
        else 
            dbms_output.put_line(vezeteknev ||' '|| keresztnev);  
        end if;
        
    end loop;
end;


select * from car

alter table car add(kor number(2));

alter table car modify(year number(10));


declare 
    new_year number(2);
    color varchar2(10);
begin
    update car set year=:new_year where color=:color;
end;

declare 

begin
    update car set kor=to_char(sysdate,'yyyy')-year;
end;

select * from car;

select * from car;

declare
    c constant car.color%type:='white';
begin
    update car set manufacturer='Suzuki' where color=c;
end;

select * from car;

declare
    c constant car.color%type:='white';
begin
    update car set manufacturer='Suzuki' where color=c;
end;



declare 
    new_row car%rowtype;
begin
    new_row.id:=13;
    new_row.manufacturer:='Seat';
    new_row.color:='white';
    new_row.price:=100;
    insert into car(id,manufacturer,color,price) values(new_row.id,new_row.manufacturer,new_row.color,new_row.price);
end;


select * from car