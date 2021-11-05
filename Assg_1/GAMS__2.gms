Binary Variable d1,d2,d3,d4,d5,d6,d7;
Integer Variable x1,x2,x3,x4,x5,x6,x7;
Free Variable z;

Equations

Con1,
Con2,
Con3,
Con4,
Con5,
Con6,
Con7,
Con8,
Con9,
Con10,
Con11,
Con12,
Con13,
Con14,
Obj ;

Con1.. x1 =G= 400;
Con2.. x2 + x1 =G= 700;
Con3.. x3 + x2 + x1 =G= 1200;
Con4.. x4 + x3 + x2 + x1 =G= 1900;
Con5.. x5 + x4 + x3 + x2 + x1 =G= 2100;
Con6.. x6 + x5 + x4 + x3 + x2 + x1 =G= 2500;
Con7.. x7 + x6 + x5 + x4 + x3 + x2 + x1 =G= 2700;
Con8.. x1 - 2700*d1 =L= 0;
Con9.. x2  - 2700*d2 =L= 0;
Con10.. x3  - 2700*d3 =L= 0;
Con11.. x4  - 2700*d4 =L= 0;
Con12.. x5  - 2700*d5 =L= 0;
Con13.. x6  - 2700*d6 =L= 0;
Con14.. x7  - 2700*d7 =L= 0;
Obj.. 33*x1 + 30*x2 + 26*x3 + 24*x4 + 19*x5 + 18*x6 + 17*x7 + 1000*d1 + 1000*d2 + 1000*d3 + 1000*d4 + 1000*d5 + 1000*d6 + 1000*d7 =E= z;

Model SampleProblem2/
Con1,
Con2,
Con3,
Con4,
Con5,
Con6,
Con7,
Con8,
Con9,
Con10,
Con11,
Con12,
Con13,
Con14,
Obj/ ;

options MIP = cbc ;

option intVarUp = 0 ;

Solve SampleProblem2 using MIP minimizing z;

Display x1.L, x2.L, x3.L, x4.L, x5.L, x6.L, x7.L, d1.L, d2.L, d3.L, d4.L, d5.L, d6.L, d7.L, z.L ;
