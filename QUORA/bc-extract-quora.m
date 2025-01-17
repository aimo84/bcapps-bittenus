(*

Graphs quora log stuff; to use "math -initfile quora-times.m"

Subject: Quora log stats

[[image1.gif]]

The graph above shows the number of quora log entries over time.

A log entry occurs whenever anyone posts or edits anything.

You can see your own log entries at https://www.quora.com/Barry-Carter/log substituting your own profile id for "Barry-Carter". If you don't know your profile id, you can click on your name at the top right corner of most pages, choose "Profile" and to get to https://www.quora.com/profile/Barry-Carter and then click on "Edits" on the left-hand bar to get to your log page.

You can see the details of a log entry by visiting https://www.quora.com/log/revision/149368232, substituting the log id number for 149368232. Note that you can view any log entry, not just your own, and the page requires no authentication: you don't even have to be logged into quora.

As the graph above shows, log entry growth is exponential, so let's look at a log plot instead:

[[image2.gif]]

If we quantify, using a numerical x scale, where x = the number of days since 1 Jan 1970 (in other words, the Unix time divided by 86400), and use numerical techniques, we find that [math]e^{0.00200361 x-15.1483}[/math] is a fairly good approximation to the number of log entries:

[[image3.gif]]

On a log scale plot:

[[image4.gif]]

Taking the derivative of this approximation, [math]0.00200361 e^{0.00200361 x-15.1483}[/math], and substituting x = 16957 (start of 5 Jun 2016), we see the log entries grow at a rate of approximately 301,000 entries per day or about 3.5 new entries per second.

In theory, it should be possible to download all new log entries as they come in (to create a live feed of questions/answers for example), but it would require a little work as 3.5 entries per second isn't trivial.

Caveats:

  - This graph is primarily based on my own log entries. I've tended to use quora off and on over the past few years, so there are some gaps in the data.

  - The raw numbers and the scripts used to generate this information are available at: https://github.com/barrycarter/bcapps/blob/master/QUORA/ under the files "bc-extract-quora.pl", "bc-extract-quora.m", and "quora-times.m".

For more details/information, please contact me via the information in my profile.

*)

(* TODO: maybe put this in bclib.pl *)

unixToDate[time_] := ToDate[N[time+2208988800]]

(* this removes a large ~232 day gap which may skew the stats *)

qt2 = Select[quoratimes, #[[1]] > 1300000000000000 &];

list5 = Table[{unixToDate[i[[1]]/10^6], i[[2]]/10^6}, {i,qt2}];

style = PlotMarkers -> 
 Graphics[{RGBColor[1,0,0], PointSize -> 0.01,  Point[{0,0}]}]

p1 = DateListPlot[list5, 
 PlotLabel -> "Quora Log Entries (millions) vs time", style]


p2= DateListLogPlot[list5, 
 PlotLabel -> "Quora Log Entries (millions) vs time, log scale", style]

list2 = Table[{i[[1]]/10^6/86400, i[[2]]/10^6}, {i,qt2}];

p3 = ListLogPlot[list2, PlotLabel -> 
 "Quora Log Entries (millions), log scale, vs time in Unix days", style];

p6 = ListPlot[list2, PlotLabel -> 
 "Quora Log Entries (millions) vs time in Unix days", style];


list3 = N[Table[{i[[1]]/10^6/86400, Log[i[[2]]]}, {i,qt2}]];
Fit[list3,{1,x},x]

f[x_] = Exp[-15.1483 + 0.00200361*x]/10^6

p4 = LogPlot[f[x], {x,15257.6,16953}]

Show[{p3,p4}]

p5 = Plot[f[x], {x,15257.6,16953}]

Show[{p6,p5}]
