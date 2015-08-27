(* Uses the results of bc-pos-dump.m to find conjunction candidates *)

outfile = "/home/barrycarter/SPICE/KERNELS/mseps"<>"-"<>
 ToString[Round[info[jstart]]]<>"-"<>ToString[Round[info[jend]]]<>".mx";

planets={mercury,venus,mars,jupiter,saturn,uranus};

(* Given a commutative function and a list, find the maximum of the
function when applied pairwise to members of the list *)

maxflist[f_,list_] := Max[Table[Apply[f,x],
 {x,Flatten[Table[{list[[i]],list[[j]]}, 
 {i,1,Length[list]-1},{j,i+1,Length[list]}],1]}]];

(* angular separation as viewed from Earth, two planets *)

angsep[p1_,p2_] := VectorAngle[earthvector2[jd,p1],earthvector2[jd,p2]];

(* daily separations for a list of planets (ie, max distance of any 2) *)

(****** TODO: 7 is just a test below !!! ****)

dailysep[list_] := Table[maxflist[angsep,list],
{jd,info[jstart],info[jstart]+7}]

planpairs = Flatten[Table[{planets[[i]],planets[[j]]},
{i,1,Length[planets]-1},{j,i+1,Length[planets]}],1];

seps[{p1_,p2_}] := seps[{p1,p2}] = Table[{jd,VectorAngle[
earthvector2[jd,p1],earthvector2[jd,p2]]}, {jd,info[jstart],info[jend]}];

(* this just assigns the 15 pairs of p1,p2, return value ignored *)

Table[seps[i],{i,planpairs}];

(* Given a table of separations, find local minima, sorted *)

minseps[tab_] := Sort[Table[{i,tab[[i]]}, {i,Select[Range[2,Length[tab]-1], 
tab[[#,2]] <= Min[tab[[#-1,2]],tab[[#+1,2]]] &]}],#1[[2,2]] < #2[[2,2]] &];

mseps[{p1_,p2_}] := mseps[{p1,p2}] = minseps[seps[{p1,p2}]];

Table[mseps[i],{i,planpairs}];

DumpSave[outfile,{mseps,info}];

