(*

Compares my dfq solutions to NASA's; to use: 

bc-header-values.pl > ! /tmp/math.txt

math -initfile ~/SPICE/KERNELS/ascp02000.431.bz2.* -initfile /tmp/math.txt
 -initfile ~/SPICE/KERNELS/ascp01000.431.bz2.*

*)

(*

This is one of many possible ways to solve these DFQs

(using easy solution for now for testing)

*)

planets = Table[planet[i],{i,0,9}]

(*

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500}, 
 MaxSteps->100000, AccuracyGoal -> 50]]

*)

start = 2440400.5;
years = 18;

sol = NDSolve[{posvel,accels},planets,{t,-366*years,366*years},
 AccuracyGoal -> 11, PrecisionGoal -> 11];

(* TODO: do the ascp files use ephermis time? if so, below is slightly wrong *)

Table[plan[i][t_] = planet[i][t-start]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,start-366*years,start+366*years}]
showit

Plot[Norm[plan[2][j]-posxyz[j,venus]], {j,start-366*years,start+366*years}]
Plot[Norm[plan[4][j]-posxyz[j,mars]], {j,start-366*years,start+366*years}]
Plot[Norm[plan[5][j]-posxyz[j,jupiter]], {j,start-366*years,start+366*years}]
Plot[Norm[plan[6][j]-posxyz[j,saturn]], {j,start-366*years,start+366*years}]
Plot[Norm[plan[7][j]-posxyz[j,uranus]], {j,start-366*years,start+366*years}]
Plot[Norm[plan[0][j]-posxyz[j,sun]], {j,start-366*years,start+366*years}]

ParametricPlot3D[plan[1][j]-posxyz[j,mercury],
 {j,start-20000, start+20000}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500}, 
 MaxSteps->100000, PrecisionGoal -> 50]]

Table[plan[i][t_] = planet[i][t-2440400.5]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-66467,2440400.5+66467}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500}, 
 MaxSteps->20000, AccuracyGoal -> Infinity]]

Table[plan[i][t_] = planet[i][t-2440400.5]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-13000,2440400.5+13000}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500}, 
 MaxSteps->20000, AccuracyGoal -> 20, WorkingPrecision -> 20]]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-8400,2440400.5+8400}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500}]]

Table[plan[i][t_] = planet[i][t-2440400.5]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-13000,2440400.5+13000}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500},
 WorkingPrecision -> 15]]

Table[plan[i][t_] = planet[i][t-2440400.5]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-13000,2440400.5+13000}]

AbsoluteTiming[sol = NDSolve[{posvel,accels},planets,{t,-366*500,366*500},
 WorkingPrecision -> 50]]

Table[plan[i][t_] = planet[i][t-2440400.5]*149597870.7 /. sol[[1]], {i,0,9}]

Plot[Norm[plan[1][j]-posxyz[j,mercury]], {j,2440400.5-650,2440400.5+650}]

(* above looks really good *)



