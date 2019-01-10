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

set term postscript eps enhanced size 2.7in,1.3in font "Helvetica,14"

#set style data filledcurves 
#set style data histogram 
set style data linespoints
#set style data lines

# KEY (LEGEND)
#set key
#set key right top
#set key out vert
#set key right 
set key at 7,5000
set key font "Helvetica, 11"
set key spacing 0.8
#set nokey
#set key box

# X LABEL AND TICS
set xlabel "Throughput (Kops/s)"
set xtics nomirror
set xrange[0:7]
#set xtics nomirror out rotate by -40 ("16KB" 0, "256KB" 4, "4MB" 8, "64MB" 12, "1GB" 16, "16GB" 20, "256GB" 24)

# Y LABEL AND TICS
set ylabel "Latency ({/Symbol m}s)"
set ytics nomirror
set yrange[0:5000]
#set ytic("0" 0, "100" 100, "200" 200, "300" 300, "400" 400, "500" 500, "600" 600)
#set y2label "Ks of TXes/sec"
#unset y2label
#set y2range[0:25.6]
#set y2tics 5
#set y2tic("" 5, "" 10, "" 15, "" 20, "" 25)

# OUTPUT FILE
set output file_out

# ACTUAL PLOTTING
plot "../data/certikos_micro.txt" every ::0::3  using ($1/1000):2 pt 6 lt 1 title 'read', \
	"../data/certikos_micro.txt" every ::4::7  using ($1/1000):2 pt 2 lt 2 title 'write', \
	"../data/certikos_micro.txt" every ::8::13  using ($1/1000):2 pt 10 lt 3 title 'capture \& write', \
	"../data/certikos_app.txt" every ::6::9  using ($1/1000):2 pt 7 lt 1 title 'WormPaxos', \
	"../data/certikos_app.txt" every ::0::5  using ($1/1000):2 pt 11 lt 2 title 'WormLog'
