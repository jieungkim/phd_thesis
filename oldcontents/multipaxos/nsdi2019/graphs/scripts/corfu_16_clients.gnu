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

#set term postscript eps enhanced size 3in,2in font "Helvetica,14"
set term postscript eps enhanced size 2.1in,1.3in font "Helvetica,14"

#set style data filledcurves 
#set style data histogram 
set style data linespoints
#set style data lines

# KEY (LEGEND)
#set key
set key center top
#set nokey
#set key box

# X LABEL AND TICS
set xlabel "Throughput (Kops/second)"
set xtics nomirror
set xrange[0:]
#set xtics nomirror out rotate by -40 ("16KB" 0, "256KB" 4, "4MB" 8, "64MB" 12, "1GB" 16, "16GB" 20, "256GB" 24)

# Y LABEL AND TICS
set ylabel "Latency ({/Symbol m} seconds)"
set ytics nomirror
set yrange[0:3300]
#set ytic("0" 0, "100" 100, "200" 200, "300" 300, "400" 400, "500" 500, "600" 600)
#set y2label "Ks of TXes/sec"
#unset y2label
#set y2range[0:25.6]
#set y2tics 5
#set y2tic("" 5, "" 10, "" 15, "" 20, "" 25)

# OUTPUT FILE
set output file_out

# ACTUAL PLOTTING
plot "../data/corfu_16_clients.txt" using ($1/1000):2 title 'Paxos-WOR' pt 6 lt 1, \
     "../data/corfu_cr_16_clients.txt" using ($1/1000):2 title 'Chain-WOR' pt 8 lt 2,\
     "../data/real_corfu_cr.txt" using ($1/1000):2 title 'CorfuDB' pt 11 lt 3
