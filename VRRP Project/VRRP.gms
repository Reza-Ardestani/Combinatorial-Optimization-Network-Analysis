* 1) defining the type of problem
option MIP = GUROBI;
option optcr=0;
option optca=0;
option reslim = 3000;

* 2) defining SETs AND PARAMETERs

set
         i/0*10/,
         f/11,12/;
alias(i,j)
parameter
         t(i,j),
         t_f(f,i),
         v,
         k,
         q,
         tmax,
         d(i,j),
         d_f(f,i),
         i_len,
         r,
         sc(i),
         sf(f);


$onecho > task.txt
par=d cdim=1 rdim=1  rng=Sheet1!A1:N12
par=d_f cdim= 1 rdim= 1 rng=Sheet1!A17:N19
$offecho
$call GDXXRW C:\Users\Mohamadreza.a\Music\vrrp_project\VRRP.xlsx @task.txt
$GDXIN VRRP.gdx
$LOAD d,d_f
$GDXIN

r = 1;
* initial fuel in the vehicle's tank = q/2
q = 40;
* number of vehicles
k = 2;
* service time for each Customer
sc(i) = 1;
sc("0") = 0;
* service time for each fuel station
sf(f) = 2;
*f_len = card(f);
i_len = card(i);
tmax = 60;
v = 1;
t(i,j) = d(i,j)/v;
t_f(f,i) = d_f(f,i)/v;


* 3) defining variables
free Variable z;
binary Variable delta(i,j), gamma(i,f, j);
positive variable w(i), x(i), u(i,j);

* 4) introducing equations
equation
         obj, const1, const2, const3, const4,
              const5, const6, const7, const8, const9, const10, const11, const12, const13, const14, const15;
* 5) defining variables


obj..
    z=e= sum((i,j)$(i.val <> j.val), delta(i, j)*d(i,j)*r)+sum((i,f,j)$(i.val<>j.val), gamma(i,f,j)*(d_f(f,i)+d_f(f,j))*r);



const1..
* number of vehicles which exit the center should be less than  K
    sum(i$(i.val <> 0), delta("0",i)) + sum((j,f)$(j.val<>0), gamma("0",f,j)) =l= k;

const2(i)..
* number of enteries to Customer nodes and Center node equals to number of exits from them
    sum(j$(i.val <> j.val), delta(j,i)) + sum((j,f)$(i.val <> j.val), gamma(j,f,i)) =e=    sum(j$(i.val <> j.val), delta(i,j)) + sum((j,f)$(i.val <> j.val), gamma(i,f,j));

const3(i)$(i.val <>0)..
* number of enteries to __Customer_NODES__ exactly has to be 1
    sum(j$(i.val <> j.val), delta(i,j)) + sum((j,f)$(i.val <> j.val), gamma(i,f,j)) =e= 1;



const4..
* initial fuel of every vehicle
    x("0") =e= q/2;

const5(j)$(j.val <>0)..
* Fuel of vehicle in node j is from one anncestor either a customer or a fuel station minus the amount of used fuel during the path
* notice this amount is always positive
    x(j) =e= sum(i$(i.val <> j.val), u(i,j)- delta(i,j)*(d(i,j)*r)) + sum((i,f)$(i.val <> j.val), gamma(i,f,j)*(Q-(d_f(f,j)*r)));

const6(i,f,j)$(i.val <> j.val)..
* We need enough fuel for reaching any fuel STATION from a Customer
    x(i)=g= d_f(f,j)*r*gamma(i,f,j);

const7(i)$(i.val<>0)..
* if we are going to reach the center, we must have enough fuel
    x(i) =g= d(i,"0")*r*delta(i,"0");


const8..
* center visit time
    w("0") =e= 0;

const9(i,j)$(i.val <> j.val and j.val<>0)..
* node j should have greater visit time from its previous node
    w(j) =g= w(i)+sc(i)+t(i,j) - 2*tmax*(1-delta(i,j));

const10(i,f,j)$(i.val <> j.val and j.val<>0)..
* node j should have greater visit time from its previous node (in this case we have also an intermediate node f)
    w(j) =g= w(i) + sc(i) + sf(f) + t_f(f,i) + t_f(f,j) - 2*tmax*(1-gamma(i,f,j));

const11(i,f)$(i.val<>0)..
* we should come back to the center sooner than Maximum travel time ( in this case we come back from fuel Station f)
    w(i) + sc(i) + sf(f) + t_f(f,i) + t_f(f,"0") =l= tmax + tmax*(1-gamma(i,f,"0"));

const12(i)$(i.val<>0)..
* we should come back to the center sooner than Maximum travel time ( in this case we come back from Customer node i)
    w(i) + sc(i) + t(i,"0") =l= tmax;

* the following constraints describe the relationship between x(i), delta(i,j) and u(i,j)
* u(i,j) is used for linearization of the term x(i)*delta(i,j) which was needed in const5

const13(i,j)$(i.val <> j.val)..
    u(i,j) =l= x(i);


const14(i,j)$(i.val <> j.val)..
    u(i,j) =g= x(i)-q*(1-delta(i,j));

const15(i,j)$(i.val <> j.val)..
    u(i,j) =l= q*delta(i,j);


* 6) introducing the model
model problem1/all/

*  7) solve command
solve problem1 using MIP minimizing z;
display z.l, delta.l, gamma.l,u.l, x.l;
