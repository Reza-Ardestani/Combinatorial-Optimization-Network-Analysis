* 1) defining the type of problem
option MIP = CPLEX;
option optcr=0;
option optca=0;
* 2) defining SETs AND PARAMETERs
set
         i;

alias(i,j);
parameter
         staff(i);
* 3) defining variables
$GDXIN C:\\Users\\Mohamadreza.a\\Downloads\\job\\job_data.gdx
$LOAD i, staff
$GDXIN
free Variable z;
integer Variable x(i);

* 4) introducing equations
equation
         obj, const1,const2;
* 5) defining variables

obj..
    z=e= sum(i,x(i));

const1(i)$(i.val<7)..
    x(i)+ sum((j)$((mod(j.val+5,7)<>i.val) and (mod(j.val+6,7)<>i.val)
                    and (j.val<>i.val) ),x(j)) =g= staff(i);
const2(i)$(i.val=7)..
    x(i)+ sum((j)$((1<>j.val) and (2<>j.val)
                    and (j.val<>i.val) ),x(j)) =g= staff(i);

* 6) introducing the model
model problem1/all/

*  7) solve command
solve problem1 using MIP minimizing z;
display z.l, x.l;






