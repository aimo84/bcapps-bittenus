(*

https://www.reddit.com/r/geography/comments/8qzl3p/if_we_redrew_us_state_lines_by_voronoi_of_the_top/

*)

<oneoff>

(* run these commands first to build caches *)

metrosAll = EntityList["MetropolitanArea"];

tab = Table[{i, i["Name"], i["Population"], i["Position"], i["Country"]},
 {i, metrosAll}]

tab >> ~/BCGIT/REDDIT/metro-area-data.m

</oneoff>

<formulas>

(* Mathematica is being cocksucky w/ forced updates *)

$AllowInternet = False;

(* end run these commands first *)

(* find US metro areas *)

metrosAll = << ~/BCGIT/REDDIT/metro-area-data.m;

metrosUSA = Select[metrosAll, 
 #[[5]] == Entity["Country", "UnitedStates"]&];

(* top 50 by pop *)

metrosUSASorted = Sort[metrosUSA, #1[[3]] > #2[[3]] &]

metrosUSATop = Take[metrosUSASorted, 50];

(* form usable to Mathematica *)

geopos = Table[i[[4]] -> i, {i, metrosUSATop}];

closestMetroTab = Table[{i, Nearest[geopos, i[[4]]]}, {i, metrosUSASorted}];

(* this is just for printing *)

printTab = Table[{i[[1,2]], i[[2,1,2]]}, {i, closestMetroTab}]

closestMetros = Gather[closestMetroTab, #1[[2]] == #2[[2]] &];

Nearest[Take[geopos, 50], geopos[[66]]]

</formulas>

(* reallow Internet after Mathematica stops being stupid *)

$AllowInternet = True;



example:

closestMetros[[7,2]]

closestMetros[[7,2,1,3]] gives population of includer

Transpose[Transpose[closestMetros[[7]]][[1]]][[3]] is just pops

NOTE: can't use census blockgroups -- for 2017, their data only goes
down to cities + micro/metro politans, not blockgroups


In[50]:= Nearest[Table[i[[4]] -> i[[1]], {i, metrosUSATop}], metrosUSASorted[[55
5,4]]]                                                                          
above works

(* table of important values, including XYZ pos for distance *)

(* this assumes ellipsoidal Earth, shiny! *)

(* the Print[i] is just to track progress, not used for anything *)

metrosTable = Table[
 {i["Name"], i["Population"], i["Latitude"], i["Longitude"], 
  GeoPositionXYZ[i], Print[i]},
 {i, metrosUSA}];








(* Avoid long delays *)

EntityList["MetropolitanArea"] lists all

a2311 = Entity["MetropolitanArea"]["Properties"]                           

a2256 = EntityList["MetropolitanArea"];

a2257 = Entity["Country", "UnitedStates"]

a2258 = Select[a2256, #["Country"] == a2257 &];

a2259 = Select[a2256, #["Country"][[2]] == "UnitedStates" &];

a2303 = Table[{i, i["Country"][[2]], Print[i]}, {i, a2256}];

a2309 = Select[a2303, #[[2]] == "UnitedStates" &]

a2309[[5,1]]["Population"]
a2309[[5,1]]["Latitude"]
a2309[[5,1]]["Longitude"]


a2312 = Transpose[a2309][[1]]

a2313 = Table[
 {i["Name"], i["Population"], i["Latitude"], i["Longitude"], Print[i]},
 {i, a2312}];

a2328 = Table[
 {i["Name"], i["Population"], i["Latitude"], i["Longitude"], Print[i]},
 {i, a2258}];

Total[Transpose[a2328][[2]]]

292138739 people

That brings the country's total urban population to 249,253,271, a number attained via a growth rate of 12.1 percent between 2000 and 2010, outpacing the nation as a whole, which grew at 9.7 percent.

from https://www.citylab.com/equity/2012/03/us-urban-population-what-does-urban-really-mean/1589/

292138739/328122776. 

is 89% so quasi-reasonable

https://mathematica.stackexchange.com/questions/56172/speed-of-curated-data-calls-in-version-10
optimization (do NOT set `$AllowInternet = False`, that breaks stuff)

Take[Sort[a2328, #1[[2]] > #2[[2]] &],10]

working thru mathematica example

data = Table[
   Reverse[CityData[c, "Coordinates"]] -> CityData[c, "Name"], {c, 
    CityData[{Large, "Italy"}]}];

city = Nearest[data];

approach of 20180809 (and using Entity not CityData)

top 50 cities

t1323 = Take[Entity["Country", "UnitedStates"]["LargestCities"], 50];

t1330 = Table[GeoPosition[i] -> i, {i, t1323}]

(* just the positions for Voronoi mesh.. *)

t1336 = Table[GeoPosition[i], {i, t1323}];

(* this is in lat, lon format *)

t1324 = Nearest[t1330];

t1334 = VoronoiMesh[t1330];


pts = RandomReal[{-1, 1}, {50, 2}];

test = VoronoiMesh[pts];

RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1324[GeoPosition[{34, 105}]], {lon, -120, 70}, {lat, 30, 50}]

RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1330[[5,2]], {lon, -120, 70}, {lat, 30, 50}]

t1418 = RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1324[t1330[[5,1]]], {lon, -120, -70}, {lat, 30, 50}]

t1418 = RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1324[t1330[[5,1]]], {lon, -120, -70}, {lat, 30, 50}, PlotStyle -> Red]

t1418 = RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1324[t1330[[5,1]]], {lon, -120, -70}, {lat, 30, 50}, PlotStyle -> Red,
 ImageSize -> {8192, 4096}]

t1418 = RegionPlot[t1324[GeoPosition[{lat, lon}]] == 
 t1324[t1330[[10,1]]], {lon, -120, -70}, {lat, 30, 50}, PlotStyle -> Red,
 ImageSize -> {8192, 4096}]

rc = RandomColor[50];

Show[{Graphics[rc[[1]]], t1418}];















