* 1) defining the type of problem
option MIP = CPLEX;
option optcr=0;
option optca=0;
*option reslim = 3000;

* 2) defining SETs AND PARAMETERs

set
         i/1*9/,
         p/1*3/;

alias(i,j,k)
alias(p,q)

parameter
* since V is 1, we don't need t(i,j) (actually it is equal to d(i,j) )
         init(i,j,k);



$onecho > data.txt
par=init cdim=0 rdim=3  rng=Sheet1!A1:D25
$offecho

$call GDXXRW C:\Users\Mohamadreza.a\Music\sudoku_project\su_in.xlsx  @data.txt
$GDXIN su_in.gdx

$LOAD init
$GDXIN



* 3) defining variables
free Variable z;
binary Variable x(i,j,k);

* 4) introducing equations
equation
         obj, const1, const2, const3, const4, const5;
* 5) defining variables


obj..
    z=e= 1;


const1(j,k)..
* Checking COLUMN constraints
    sum(i,x(i,j,k)) =e= 1;

const2(i,k)..
* Checking ROW constraints
    sum(j, x(i,j,k)) =e= 1;

const3(k,p,q)..
* CHecking Cell Constraint
    sum((i,j)$( (i.val <=3*p.val) and (i.val>=3*p.val -2)
                 and (j.val<=3*q.val) and (j.val>=3*q.val -2)), x(i,j,k)) =e= 1;

const4(i,j)..
* each cell should have been assigned to EXACTLY ONE VALUE
    sum(k,x(i,j,k)) =e= 1;

const5(i,j,k)$( init(i,j,k) = 1 )..
* All the known cells
     x(i,j,k) =e= 1;

* 6) introducing the model
model problem1/all/

*  7) solve command
solve problem1 using MIP minimizing z;

parameter
    mstat;
    mstat = problem1.modelstat;


Execute_unload "C:\Users\Mohamadreza.a\Music\sudoku_project\su_out.gdx"  x, mstat;

$onecho > data.txt
var=x rdim=3 cdim=0 rng=Sheet2!A1
par=mstat cdim=0 rdim=0  rng=Sheet1!A1
$offecho

execute 'gdxxrw.exe C:\Users\Mohamadreza.a\Music\sudoku_project\su_out.gdx o=C:\Users\Mohamadreza.a\Music\sudoku_project\su_out.xlsx @data.txt'






