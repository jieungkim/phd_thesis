#!/usr/bin/gnuplot
set term postscript eps enhanced size 3in,3in font "Helvetica,14"
set output "../log_latency_dist.ps"
set multiplot layout 2,1 rowsfirst
set label "Chain replication" center at screen 0.5,0.4 tc rgb"#cccccc" 
#set label "Server-driven chain replication" center at screen 0.5,0.6 tc rgb"#cccccc" 
set label "Paxos" center at screen 0.5,0.9 tc rgb"#cccccc" 
set yrange [0:30]
set xrange [0:1500]
set boxwidth 10
set ylabel " "
unset xtics
set xtics
set xlabel "Latency (microseconds)"
set ylabel "                                   % of operations                                    "
set key right center 
#set xtics nomirror out rotate by -90 
#set size 1,0.4
plot "../data/log_latency_dist.txt" using 1:($2/80) with boxes title "1 replica" lt rgbcolor "black" fs solid 0.3, \
"" using 1:($3/80)  with boxes title "2 replicas" lt rgbcolor "black" fs solid 0.6, \
"" using 1:($4/80) with boxes title "3 replicas" lt rgbcolor "black" fs solid 0.9

#plot "../data/log_latency_dist.txt" using 1:($5/80) with boxes title "1 replica" lt rgbcolor "black" fs solid 0.3, "" using 1:($6/80) with boxes title "2 replicas" lt rgbcolor "black" fs solid 0.6, "" using 1:($7/80) with boxes title "3 replicas" lt rgbcolor "black" fs solid 0.9
plot "../data/log_latency_dist.txt" using 1:($8/80) with boxes title "1 replica" lt rgbcolor "black" fs solid 0.3, \
"" using 1:($9/80) with boxes title "2 replicas" lt rgbcolor "black" fs solid 0.6, \
"" using 1:($10/80) with boxes title "3 replicas" lt rgbcolor "black" fs solid 0.9
