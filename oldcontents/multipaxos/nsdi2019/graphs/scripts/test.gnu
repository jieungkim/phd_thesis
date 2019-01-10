#!/usr/bin/gnuplot
set print "-"
help_string="Usage: gnuplot -e \"file_in='<input path>'; file_out='<output path>'; row_start=<start row #>; row_end=<end row #>;\"";

if ((!exists("file_in")) || (!exists("file_out"))) \
	print "file_in or file_out undefined"; \
	print help_string; \
	exit;
 
#if ((!exists("row_start")) || (!exists("row_end"))) \
#	print "row_start or row_end undefined"; \
#	print help_string;

set term postscript eps enhanced size 2.1in,1.3in font "Helvetica,14"

#set style data filledcurves 
#set style data histogram 
set style data linespoints
#set style data lines

# KEY (LEGEND)
#set key
#set key right top
set nokey
#set key box

# X LABEL AND TICS
set xlabel "Throughput (Kops/second)"
set xtics nomirror
set xrange[0:]
#set xtics nomirror out rotate by -40 ("16KB" 0, "256KB" 4, "4MB" 8, "64MB" 12, "1GB" 16, "16GB" 20, "256GB" 24)

# Y LABEL AND TICS
set ylabel "Latency ({/Symbol m} seconds)"
set ytics nomirror
set yrange[0:2000]
#set ytic("0" 0, "100" 100, "200" 200, "300" 300, "400" 400, "500" 500, "600" 600)
#set y2label "Ks of TXes/sec"
#unset y2label
#set y2range[0:25.6]
#set y2tics 5
#set y2tic("" 5, "" 10, "" 15, "" 20, "" 25)

# OUTPUT FILE
set output file_out


set multiplot

# remove border and ytics from right hand side
set ytics 5000
set border 11
set xtics nomirror
# set top and bottom margins for both halves of the plot
bh_size = 0.2
th_size = 0.4
bm1 = 0.22
tm1 = bm1 + bh_size
lm1 = 0.3
rm1 = 0.96

lcut1_fx = lm1 - 0.02
lcut1_fy = tm1
lcut1_tx = lm1 + 0.02
lcut1_ty = tm1 + 0.02

lcut2_fx = lm1 - 0.02
lcut2_fy = tm1 - 0.01
lcut2_tx = lm1 + 0.02
lcut2_ty = tm1 + 0.01

rcut1_fx = rm1 - 0.02
rcut1_fy = tm1
rcut1_tx = rm1 + 0.02
rcut1_ty = tm1 + 0.02

rcut2_fx = rm1 - 0.02
rcut2_fy = tm1 - 0.01
rcut2_tx = rm1 + 0.02
rcut2_ty = tm1 + 0.01


set tmargin at screen tm1
set bmargin at screen bm1
# set left and right margins for left half of the plot
set lmargin at screen lm1
set rmargin at screen rm1
# set xrange for left half of the plot
set xrange [0:30]
set yrange [0:9500]
# set some lines to delimit transition from one half of the plot to next
#set arrow from screen 0.08,0.50 to screen 0.12,0.52 nohead
#set arrow from screen 0.08,0.49 to screen 0.12,0.51 nohead
#set arrow from screen 0.94,0.50 to screen 0.98,0.52 nohead
#set arrow from screen 0.94,0.49 to screen 0.98,0.51 nohead
set arrow from screen lcut1_fx,lcut1_fy to screen lcut1_tx,lcut1_ty nohead
set arrow from screen lcut2_fx,lcut2_fy to screen lcut2_tx,lcut2_ty nohead
set arrow from screen rcut1_fx,rcut1_fy to screen rcut1_tx,rcut1_ty nohead
set arrow from screen rcut2_fx,rcut2_fy to screen rcut2_tx,rcut2_ty nohead
# plot left half
plot "../data/veri_wormspace_paxos.txt" using ($1/1000):($2) title 'WormPaxos' pt 6 lt 1
# remove border from left hand side and set ytics on the right

set border 14
unset xtics
# set left and right margins for right half of the plot
bm2 = tm1 + 0.01
tm2 = bm2 + th_size
set bmargin at screen bm2
set tmargin at screen tm2
unset xlabel
unset ylabel
# set xrange for right half of the plot
set xrange [0:30]
set yrange [14500:35000]
# plot
plot "../data/ironfleet.txt" using ($1/1000):($2) title 'IronRSL' pt 11 lt 3
