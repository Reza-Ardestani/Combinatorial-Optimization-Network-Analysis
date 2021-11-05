* 1) defining the type of problem
option MIP = CPLEX;
option optcr=0;
option optca=0;
option intVarUp = 0;

* 2) defining SETs AND PARAMETERs
* e means EXISTS and c means COST

set
         room/1*4/,
         classes/1*7/,
         time/1*5/;

* n means number of nodes
* reminder: define a loop for setting e(i,j) = 0
Parameter
         a(classes, time)/1.1 0,1.2 1,1.3 1,1.4 1,1.5 0,
                2.1 0,2.2 1,2.3 1,2.4 1,2.5 0,
                3.1 0,3.2 1,3.3 1,3.4 1,3.5 0,
                4.1 1,4.2 1,4.3 0,4.4 0,4.5 0,
                5.1 0,5.2 0,5.3 0,5.4 0,5.5 1,
                6.1 1,6.2 1,6.3 0,6.4 0,6.5 0,
                7.1 1,7.2 1,7.3 0,7.4 0,7.5 0/

         cost(classes,room)/1.1 0,1.2 2,1.3 4,1.4 0,
                2.1 0,2.2 2,2.3 4,2.4 0,
                3.1 0,3.2 2,3.3 4,3.4 0,
                4.1 70,4.2 70,4.3 0,4.4 70,
                5.1 70,5.2 0,5.3 1,5.4 70,
                6.1 0,6.2 2,6.3 4,6.4 0,
                7.1 0,7.2 2,7.3 4,7.4 0/

         th(classes)/1 3,2 3,3 3,4 3,5 1,6 2,7 2/,

         p(classes)/1 50,2 50,3 50,4 150, 5 100,6 50, 7 50/,

         cap(room)/1 50,2 100,3 150,4 50/;

* 3) defining variables
Free Variable z;
binary Variable delta(classes);
binary Variable x(time, room, classes);


* 4) introducing Equations
equation
         obj,
         const1,
         const2,
         const3,
         const4,
         const5,
         const6;


* 5) defining Equations (constraints and objective func)

const1(time,room)..
         sum(classes,x(time,room,classes)) =l= 1;

const2(time,classes)..
         sum(room,x(time,room,classes)) =l= 1;


const3(classes,time)$(a(classes,time) = 0)..
         sum(room,x(time,room,classes)) =e= 0;

const4(classes)..
         0.1*(1-delta(classes)) =l= th(classes) - sum((time, room),x(time,room,classes));

const5(classes)..
         th(classes) - sum((time, room),x(time,room,classes)) =l= 3*(1-delta(classes));

const6(room,classes)$(p(classes)>cap(room))..
        sum(time,x(time,room,classes)) =e= 0;

obj..
         z =e= 601*sum(classes,(1-delta(classes))) + sum((time,room,classes),100*cost(classes,room)*x(time,room,classes));



* 6) introducing the model
model mod/all/;



*  7) solve command
solve mod using MIP minimizing z;

Display z.l , x.l , delta.l;