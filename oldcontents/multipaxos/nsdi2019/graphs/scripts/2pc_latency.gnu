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

set term postscript eps enhanced size 1.7in,1.3in font "Helvetica,14"

#set style data filledcurves 
set style histogram cluster gap 1
#set style data histogram 
#set style data linespoints
#set style data lines

# KEY (LEGEND)
set key
#set key right top
#set nokey
#set key box

# X LABEL AND TICS
#unset xlabel "Throughput (Kops/s)"
set xtics nomirror
set xrange[0:6]
set xtics nomirror out rotate by 0 ("A8" 1, "B6" 2, "C5" 3, "D4" 4, "E3" 5)

# Y LABEL AND TICS
set ylabel "Latency ({/Symbol m}s)"
set ytics nomirror
set yrange[0:]
#set ytic("0" 0, "100" 100, "200" 200, "300" 300, "400" 400, "500" 500, "600" 600)
#set y2label "Ks of TXes/sec"
#unset y2label
set y2range[0:]
#set y2tics 5
#set y2tic("" 5, "" 10, "" 15, "" 20, "" 25)

# OUTPUT FILE
set output file_out

# ACTUAL PLOTTING
set boxwidth 0.4
plot file_in using 1:2:3 with boxerror lt 1 title ""
