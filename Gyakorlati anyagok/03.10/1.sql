/*apex belepes: apex.oracle.com*/
DECLARE
	r  number(2) := 12;
	pi CONSTANT number(3.2):= 3.14;
BEGIN
dbms_output.put_line(r|| 'sugarú kör területe || r*r*pi);
END
set serveroutput.on

/*új nyitas*/

DECLARE
   v_name varchar2(100);
BEGIN
    dbms_output.put_line(Upper(:v_name));
END;

/*új nyitasa*/
DECLARE
    szam integer;
BEGIN
 IF MOD(:szam,2)=0 THEN
    dbms_output.put_line('A szám páros');
 ELSIF szam=1 THEN
   dbms_output.put_line('A szám 1');
 ELSE
    dbms_output.put_line('A szám páratlan');
 END IF;
END;

/*új nyitása*/

DECLARE
 l_seed char(100);
 r number(4);
BEGIN
 l_seed:=to_char(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
 r := dbms_random.value(-100,100);
 r := :r;
 if r<0 then
    dbms_output.put_line(r||' negatív');
 elsif r=0 then
    dbms_output.put_line(r||' ez nulla');
 else
   dbms_output.put_line(r||' pozitív ');
 end if;
END;


/-új nyitása-*

DECLARE
 l_seed char(100);
 r number(4);
BEGIN
    l_seed := to_char(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
    dbms_random.seed(l_seed);
    r := dbms_random.value(0,8);
    dbms_output.put_line(r||'/4=');
    case mod(r,4)
        when 1 then dbms_output.put_line(trunc(r/4.0)||' 1 maradék ');
        when 2 then dbms_output.put_line(trunc(r/4.0)||' 2 maradék ');
        when 3 then dbms_output.put_line(trunc(r/4.0)||' 3 maradék ');
        else
         dbms_output.put_line(trunc(r/4.0)||' 0 maradék');
    end case;
END;

/*új*/

DECLARE 
 db INTEGER := 0;
 pi number(6,5):= 1;
 denominator integer:=1;
 
BEGIN
    while db<=100000 loop
        denominator:=denominator+2;
        if mod(db,2)=0 then
            pi:=pi-1/denominator;
        else
            pi:=pi+1/denominator;
        end if;
        db:=db+1;
    end loop;
    
    dbms_output.put_line('Pi= '||pi*4);
END;

/*uj*/
DECLARE
 loopmax number(2);
 summa number(4);
BEGIN
    summa:=0;
    loopmax := :loopmax;
    for i in 1..loopmax loop
        summa:=summa+i;
    end loop;
    
    dbms_output.put_line('1-től '||loopmax||'-ig a számok összege: '|| summa);
END;

/*új*/

DECLARE
    k number(4);
    oszto integer:=2;
    prim boolean:=true;

BEGIN
    dbms_output.put(:k);
    loop
        if mod(:k,oszto)=0 then
            prim:=false;
        end if;
        oszto:=oszto+1;
        exit when prim=false or oszto>sqrt(:k);
    end loop;
    
    dbms_output.put_line('prímszam: '||case when prim = true then 'igen' else 'nem' end);

END;
