option MIP = Cplex ;
option optcr = 0;
option intvarUp = 0;

set
* j is for number of "S" classes that we have
    j,c,p,d,h,sca;

alias(c,cp)
alias(d,dp)
alias(h,hp)


Parameter
* note: we just need k(1) to define our "number of classes" parameter
    s(j,c)
    k(sca)
* since we are going to use h bar as an index we can not define it as a parameter here
    hbar(sca)
    dlast(sca)
    n(c)
* T means TADAKHOl (this word is in Persian) in English means "Conflict" or "opposition"
    t(h,hp)
    a(c,p)
    b(p,d,h);

$GDXIN %gdxincname%
$LOAD j, c, p, d, h, sca, s, k, hbar, dlast, n, t, a, b
$GDXIN


* display a , b;



* defining variables
free variable z;
binary variable x(c, d, h);
positive variable w ;
positive variable v(c,d);
binary variable y(c);
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
const10,
const11,
obj;

const1(c)..
         sum( (d,h), x(c,d,h) ) =e= n(c);
const2(d,h,hp)..
         sum((c)$(t(h,hp)=1 or t(hp,h)=1), x(c,d,hp)) + sum((c),x(c,d,h)) =l= k('1');
const3(d,h,p,hp)..
         sum((c)$(a(c,p) =1 and(t(h,hp)=1 or t(hp,h)=1)), x(c,d,hp)) + sum((c)$(a(c,p)=1),x(c,d,h)) =l= 1;
const4(d,h,j,hp)..
         sum((c)$(s(j,c)=1 and(t(h,hp)=1  or t(hp,h)=1)), x(c,d,hp)) + sum((c)$(s(j,c)=1),x(c,d,h)) =l= 1;
const5(d,h,c,p)$(a(c,p)=1)..
         x(c,d,h) =l= b(p,d,h);
const6(c,d)$(n(c)>1)..
         sum(h, x(c,d,h)) =l= 1;
const7(h)$(h.val = hbar('1'))..
         sum((c,d), x(c,d,h))- w =l= 0;
const8(c,d)$( n(c)>1 and d.val < dlast('1'))..
         sum(h, x(c,d,h)) + sum(h, x(c,d+1,h))-v(c,d) =l= 1;
const9(c,d,h)$(n(c)>1)..
         sum((dp,hp)$(d.val <> dp.val and h.val <> hp.val), x(c,dp,hp)) -1*(n(c)-1)*y(c) =l= 21*(1-x(c,d,h));


************** Note: for data_01 put const10 = 6 and const11 = 1 ***************
************** Note: for data_02 put const10 = 7 and const11 = 0 ***************
const10..
         w =e= 7  ;
const11..
         sum((c,d)$(n(c)>1 and d.val < dlast('1')), v(c,d) ) =e= 0 ;

obj..
    z =e= sum( (c)$(n(c)>1),y(c) )  ;


* 6) introducing the model
model mod/const1,
const2,
const3,
const4,
const5,
const6,
const7,
const8,
const9,
const10,
const11
obj/;


*  7) solve command
solve mod using MIP minimizing z;
Display z.l,x.l,k,j, c, p, d, h, sca, s, k, hbar, dlast, n, t, a, b     ;



