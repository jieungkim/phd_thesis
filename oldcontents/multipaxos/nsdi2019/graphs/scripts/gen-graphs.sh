#!/bin/bash
gnuplot -e "file_in='../data/single_leader_paxos.txt'; file_out='../single_leader_paxos.ps';" single_leader_paxos.gnu
gnuplot -e "file_in='../data/corfu_16_clients.txt'; file_out='../corfu_16_clients.ps';" corfu_16_clients.gnu
gnuplot -e "file_in='../data/2pc_latency.txt'; file_out='../2pc_latency.ps';" 2pc_latency.gnu
gnuplot -e "file_in='../data/micro_wos_init.txt'; file_out='../micro_wos_init.ps';" micro_wos_init.gnu
gnuplot -e "file_in='../data/micro_read.txt'; file_out='../micro_read.ps';" micro_read.gnu
gnuplot -e "file_in='../data/micro_write.txt'; file_out='../micro_write.ps';" micro_write.gnu
gnuplot -e "file_in='../data/paxos_persist_tput.txt'; file_out='../paxos_persist_tput.ps';" paxos_persist_tput.gnu
gnuplot -e "file_in='../data/certikos_micro.txt'; file_out='../certikos_micro.ps';" certikos_micro.gnu
gnuplot -e "file_in='../data/certikos_app.txt'; file_out='../certikos_app.ps';" certikos_app.gnu
gnuplot -e "file_in='../data/veri_wormspace_micro.txt'; file_out='../veri_wormspace_micro.ps';" veri_wormspace_micro.gnu
gnuplot -e "file_in='../data/veri_wormspace_corfu.txt'; file_out='../veri_wormspace_corfu.ps';" veri_wormspace_corfu.gnu
gnuplot -e "file_in='../data/veri_wormspace_paxos.txt'; file_out='../veri_wormspace_paxos.ps';" veri_wormspace_paxos.gnu
gnuplot -e "file_in='../data/certikos_micro.txt'; file_out='../certikos_allinone.ps';" certikos_allinone.gnu
#gnuplot -e "file_in='../data/veri_wormspace_paxos.txt'; file_out='../test.ps';" test.gnu
gnuplot log_latency_dist.gnu
gnuplot log_latency_cdf.gnu

eps="ps"
pdf="pdf"
for epsfile in $(ls ../*.ps)
do
     ps2pdf -dEPSCrop $epsfile ${epsfile//$eps/$pdf}
done


