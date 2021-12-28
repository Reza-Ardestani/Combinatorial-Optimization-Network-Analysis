option MIP = Cplex ;
option optcr = 0;
option intvarUp = 0;

set
* j is for number of "S" classes that we have
    j/1*5/,
    c/1*18/,
    p/1*6/,
    d/1*5/,
    fd/5/,
    h/1*4/,
    hb/4/;


alias(d,dp)
alias(h,hp)


Parameter
* note: we just need k(1) to define our "number of classes" parameter
    s(j,c)/1.1 1, 1.2 1, 1.8 1, 1.9 1, 1.18 1,
           2.2 1, 2.3 1, 2.10 1, 2.11 1, 2.18 1,
           3.3 1, 3.4 1, 3.5 1, 3.12 1, 3.13 1, 3.14 1,
           4.7 1, 4.8 1, 4.16 1, 4.17 1,
           5.5 1, 5.12 1, 5.13 1, 5.14 1, 5.15 1, 5.17 1/
    k(c)/1 2/
* since we are going to use h bar as an index we can not define it as a parameter here
    hbar(c)/1 4/
    dlast(c)/1 5/
    n(c)/1 1,2 1,3 1,4 1,5 1,6 1,7 1,8 2,9 2,10 2,11 2,12 2,13 2,14 2,15 2,16 2,17 2,18 2/
    a(c,p)
    b(p,d,h);

$onecho > data.txt
par=a cdim=0 rdim=2  rng=Sheet1!A1:C19
par=b cdim=0 rdim=3  rng=Sheet2!A1:D72

$offecho

$call GDXXRW D:\MYFL\1_Ed\2_Ac\15_11S\2_Combinatorial_opt\Assg_3\assg_3.xlsx  @data.txt
$GDXIN assg_3.gdx

$LOAD a, b
$GDXIN


* display a , b;



* defining variables
free variable z;
binary variable x(c, d, h);

* defining constraights and objective
equations
const1,
const2,
const3,
const4,
const5,
const6,
const7,
const8,
const9,
* const10,
* const11,
* const12,
* const13,
* const14,
obj;

const1(c)..
         sum( (d,h), x(c,d,h) ) =e= n(c);
const2(d,h)..
         sum(c, x(c,d,h)) =l= k('1');
const3(d,h,p)..
         sum((c)$(a(c, p)= 1), x(c,d,h) )=l= 1 ;
const4(d,h,j)..
         sum((c)$(s(j,c)=1), x(c,d,h)) =l= 1;
const5(d,h,c,p)$(a(c,p)=1)..
         x(c,d,h) =l= b(p,d,h);
const6(c,d)$(n(c)>1)..
         sum(h, x(c,d,h)) =l= 1;
const7(h)$(h.val = hbar('1'))..
         sum((c,d), x(c,d,h)) =l= 0;
const8(c,d)$( n(c)>1 and d.val < dlast('1'))..
         sum(h, x(c,d,h)) + sum(h, x(c,d+1,h)) =l= 1;
const9(c,d,h)$(n(c)>1)..
         sum((dp,hp)$(d.val <> dp.val and h.val <> hp.val), x(c,dp,hp)) =l= 1000*(1-x(c,d,h));

obj..
     z =e= 0  ;


* 6) introducing the model
model mod/all/;


*  7) solve command
solve mod using MIP minimizing z;
Display z.l, n;



