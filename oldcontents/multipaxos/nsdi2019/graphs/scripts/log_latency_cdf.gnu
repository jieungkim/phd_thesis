#!/usr/bin/gnuplot
set term postscript eps enhanced size 2.5in,1.3in font "Helvetica,14"
set output "../log_latency_cdf.ps"
set yrange [0:1]
#set xrange [0:2.5]
set xrange [0:2500]
set boxwidth 10
set ylabel " "
unset xtics
set xtics
set xlabel "Latency ({/Symbol m}s)"
#set xlabel "Latency (milliseconds)"
set ylabel "CDF"
set key right bottom 
set key font "Helvetica, 10"
set key spacing 0.7
set key samplen 2
#set xtics nomirror out rotate by -30
#set size 1,0.4
plot "../data/log_latency_cdf.txt" using ($1):($2) with lines title "Paxos-WOR-1" lt 1 lc rgbcolor "black" lw 3, \
"" using ($1):($3)  with lines title "Pax-WOR-2" lt 2 lc rgbcolor "black" lw 3, \
"" using ($1):($4) with lines title "Pax-WOR-3" lt 3 lc rgbcolor "black" lw 3, \
"" using ($1):($8) with lines title "Chain-WOR-1" lt 5 lc rgbcolor "red" lw 3, \
"" using ($1):($9) with lines title "Chain-WOR-2" lt 6 lc rgbcolor "red" lw 3, \
"" using ($1):($10) with lines title "Chain-WOR-3" lt 8 lc rgbcolor "red" lw 3, \
"../data/log_latency_cdf_corfu.txt" using ($1):($2) with lines title "CorfuDB-1" lt 4 lc rgbcolor "blue" lw 3, \
"" using ($1):($3) with lines title "CorfuDB-2" lt 7 lc rgbcolor "blue" lw 3, \
"" using ($1):($4) with lines title "CorfuDB-3" lt 9 lc rgbcolor "blue" lw 3 
