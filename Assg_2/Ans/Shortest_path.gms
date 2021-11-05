* 1) defining the type of problem
option MIP = CPLEX;
option optcr=0;
option optca=0;

* 2) defining SETs AND PARAMETERs
* e means EXISTS and c means COST

set
         i/1*6/;
alias (i,j);

* n means number of nodes
* reminder: define a loop for setting e(i,j) = 0
Parameter
         n /6/
         ed(i,j)/1.1 0,1.2 1,1.3 1,1.4 0,1.5 0,1.6 0,
                2.1 0,2.2 0,2.3 0,2.4 0,2.5 0,2.6 1,
                3.1 0,3.2 0,3.3 0,3.4 1,3.5 0,3.6 1,
                4.1 0,4.2 0,4.3 0,4.4 0,4.5 1,4.6 0,
                5.1 0,5.2 0,5.3 1,5.4 0,5.5 0,5.6 0,
                6.1 0,6.2 0,6.3 0,6.4 0,6.5 0,6.6 0/

         c(i,j)/1.1 70,1.2 1,1.3 0,1.4 70,1.5 70,1.6 70,
                2.1 70,2.2 70,2.3 70,2.4 70,2.5 70,2.6 1,
                3.1 70,3.2 70,3.3 70,3.4 -5,3.5 70,3.6 1,
                4.1 70,4.2 70,4.3 70,4.4 70,4.5 -5,4.6 70,
                5.1 70,5.2 70,5.3 -5,5.4 70,5.5 70,5.6 70,
                6.1 70,6.2 70,6.3 70,6.4 70,6.5 70,6.6 70/;



* 3) defining variables
Free Variable z;
Integer Variable t(i);
binary Variable x(i, j);


* 4) introducing Equations
equation
         obj,
         const1,
         const2,
         const3,
         const4,
         const5;


* 5) defining Equations (constraints and objective func)
const1..
         sum(i$(ed('1',i)=1),x('1',i)) - sum(j$(ed(j,'1')=1),x(j,'1')) =e= 1;

const2..
         sum(i$(ed(i,'6')=1),x(i,'6')) - sum(j$(ed('6',j)=1),x('6',j)) =e= 1;

const3(j)$(j.val>1 and j.val < 6)..
         sum(i$(ed(i,j)=1), x(i,j)) - sum(i$(ed(j,i)=1), x(j,i)) =e= 0;

const4..
         t('1')=e= 0;

const5(i,j)$( (i.val>j.val or i.val<j.val) and (j.val >1) )..
         t(i) - t(j) + n*x(i,j)=l= n-1;

obj..
         z =e= sum((i,j)$(ed(i, j)= 1),c(i,j)*x(i,j) )



* 6) introducing the model
model mod/all/;



*  7) solve command
solve mod using MIP minimizing z;
Display z.l , x.l;

