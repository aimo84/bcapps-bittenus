(*

math -initfile ~/BCGIT/ASTRO/bc-astro-formulas.m

http://astronomy.stackexchange.com/questions/19619/how-to-make-motion-of-the-sun-more-apparent-at-seconds-scale

TODO: note when setting, asymptotic to infinity

TODO: note ra/dec fixed is reasonable

TODO: link to formulas

TODO: sid day length and fixed ra cancel each other out

decHaLat2azEl[dec,ha,lat]

decHaLat2azEl[dec,0,lat]

conds = {Element[{dec,ha,lat}, Reals]}
D[decHaLat2azEl[dec,ha,lat],ha]

FullSimplify[% /. ha -> 0]

{-(Cos[dec] Csc[dec - lat]), 0}

Solve[D[-Cos[dec]*Csc[dec-lat],dec]==0, dec]

decHaLat2azEl[dec,ha,lat]

decHaLat2azEl[0,ha,35*Degree]

ParametricPlot[decHaLat2azEl[0,ha,35*Degree], {ha,-Pi,Pi}]

ParametricPlot[decHaLat2azEl[0,ha,35*Degree]/Degree, {ha,-Pi,Pi}]

TODO: actually list parametric plot so we can see distances and stuff

helper function below makes az range 0-360 because we want center

fix[pair_] := {Mod[pair[[1]],2*Pi], pair[[2]]}

t = Table[N[fix[decHaLat2azEl[0,ha,35*Degree]]]/Degree,{ha,-Pi,Pi,2*Pi/48}]
ListPlot[t, PlotRange -> {{0,360}, {-55,55}}]
showit

t = Table[N[fix[decHaLat2azEl[0,ha,35*Degree]]]/Degree,{ha,-Pi,Pi,2*Pi/48}]
ListPlot[t, PlotRange -> {{0,360}, {-55,55}}]
showit

tab[dec_] = Table[N[fix[decHaLat2azEl[dec,ha,35*Degree]]]/Degree,
 {ha,-Pi,Pi,2*Pi/48}];

(* hours and degrees *)

fix[pair_] := {Mod[pair[[1]]/Pi*180,360], pair[[2]]/Degree}

tab[dec_] = Table[fix[decHaLat2azEl[dec,ha,35*Degree]], {ha,-Pi,Pi,2*Pi/48}];

pts[dec_] = Table[
 Text[ToString[Mod[ha/Pi*12+12,24]],
 fix[decHaLat2azEl[dec,ha,35*Degree]]], {ha,-Pi,Pi,2*Pi/24}];
Graphics[pts[0]]
showit

g1 = ListPlot[{tab[-23.5*Degree], tab[0*Degree], tab[23.5*Degree]}];
g2 = Graphics[{pts[-23.5*Degree], pts[0*Degree], pts[23.5*Degree]}];
Show[{g1,g2}]
showit




TODO: label points with hours!


*)

