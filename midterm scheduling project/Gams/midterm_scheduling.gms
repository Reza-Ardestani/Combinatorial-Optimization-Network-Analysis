option MIP = Cplex ;
option optcr = 0;
option intvarUp = 0;
set
    students_id,
    cources_id,
    exam_intervals/1*3/,
    exam_days/1*14/;

alias(exam_days,r)
 


Parameter
    student_cources(students_id, cources_id)
    penalty_coefficients(exam_intervals)/1 9,2 6,3 2/
    cource_classes(cources_id, exam_days)
    cources_code(cources_id)
    students_code(students_id);
    

$onecho > data.txt
set=students_id cdim=0 rdim=1  rng=students_id&code!A2:A139
set=cources_id cdim=0 rdim=1  rng=cources_id&code!A2:A56
par=student_cources cdim=1 rdim=1  rng=students_id&cources_id!A1:BD139
par=cource_classes cdim=0 rdim=2  rng=cources_id&day_2!A1:c221
par=cources_code cdim=0 rdim=1  rng=cources_id&code!A2:B56
par=students_code cdim=0 rdim=1  rng=students_id&code!A2:B139

$offecho

$call GDXXRW C:\Users\Lenovo\Documents\GAMSStudio\workspace\midterm_Data.xlsx  @data.txt
$GDXIN midterm_Data.gdx

$LOAD students_id,cources_id, student_cources, cource_classes, students_code, cources_code
$GDXIN

* defining variables
free variable z;
integer variable y(students_id, exam_days);
binary variable u(students_id, exam_days);
binary variable x(cources_id, exam_days);
binary variable n(students_id,exam_intervals,exam_days);
binary variable p(students_id,exam_intervals,exam_days);


* defining constraights and objective
equations
const1,
const2,
const3,
const4,
const5,
const6,
const7,
obj;

const1(students_id, exam_days)..

    sum(cources_id, student_cources(students_id,cources_id) * x(cources_id,exam_days))=e= y(students_id,exam_days);

const2(cources_id, exam_days)$(cource_classes(cources_id, exam_days) = 0)..

    x(cources_id, exam_days)=e= 0;

const3(cources_id)..

    sum(exam_days,x(cources_id, exam_days))=e= 1;

const4(students_id,exam_days)..

    y(students_id,exam_days) =g= 1-u(students_id,exam_days);

const5(students_id,exam_days)..

    y(students_id,exam_days) =l= card(exam_days)*(1-u(students_id,exam_days));

const6(students_id,exam_intervals,exam_days)$(exam_days.val <= card(exam_days)-exam_intervals.val)..

     (1-u(students_id,exam_days)) + (1-u(students_id,exam_days+exam_intervals.val)) - (sum(r$(r.val >= exam_days.val+1 and r.val<= exam_days.val + exam_intervals.val-1),1-u(students_id,r)))-1 =l= (1-n(students_id,exam_intervals,exam_days));

const7(students_id,exam_intervals,exam_days)..

    1-p(students_id,exam_intervals,exam_days) =l= 1*(n(students_id,exam_intervals,exam_days));

obj..

    z =e= 901 * sum((students_id,exam_days),u(students_id,exam_days)+ y(students_id,exam_days) - 1) + 100 * sum((exam_intervals,students_id,exam_days),p(students_id,exam_intervals,exam_days)*penalty_coefficients(exam_intervals));

model midterm_scheduling/const1,const2,const3,const4,const5,const6,const7,obj/;



*7) solve command
solve midterm_scheduling using MIP minimizing z;

parameter
    execution_time;
    execution_time = midterm_scheduling.etSolve; 


Execute_unload "C:\Users\Lenovo\Documents\GAMSStudio\workspace\midterm_exam_assigning_two_week.gdx" z, x, cources_code,  y, students_code, student_cources, execution_time, cource_classes;

$onecho > data.txt
var=z cdim=0 rdim=0  rng=objective_function&time!A1
par=execution_time cdim=0 rdim=0  rng=objective_function&time!A2
par=cources_code cdim=0 rdim=1 rng=x!A2
var=x rdim=1 cdim=1 rng=x!c1
par=students_code cdim=0 rdim=1 rng=y!A2
var=y rdim=1 cdim=1 rng=y!c1
par=student_cources cdim=1 rdim=1 rng=student_cources!A2
par=cource_classes cdim=1 rdim=1 rng=cource_classes!A2
$offecho

execute 'gdxxrw.exe C:\Users\Lenovo\Documents\GAMSStudio\workspace\midterm_exam_assigning_two_week.gdx o=C:\Users\Lenovo\Documents\GAMSStudio\workspace\midterm_exam_assigning_two_week.xlsx @data.txt'
