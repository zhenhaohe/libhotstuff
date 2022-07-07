#!/bin/bash
#$1 number of replicas
#$2 number of clients

replica=(10 7 4)
client=(32 24 16)
msgSize=(4096 2048 1024 0)
for r in "${replica[@]}"  
do
    for c in "${client[@]}"  
    do
        for s in "${msgSize[@]}"  
        do
            ip_num=`sed -n '$=' ip_list.txt`
            echo "Total IP: ${ip_num}"
            ind=$(($r+1))

            # echo "Msg size: ${s}"
            # sed -i "/define HOTSTUFF_CMD_RESPSIZE/c #define HOTSTUFF_CMD_RESPSIZE ${s}" ../../include/hotstuff/client.h
            # sed -i "/define HOTSTUFF_CMD_REQSIZE/c #define HOTSTUFF_CMD_REQSIZE ${s}" ../../include/hotstuff/client.h

            # python3 gen_host_list.py --num_replica ${r} --num_clients ${c}

            # ./gen_all.sh

            # echo "setup"

            # ./run.sh setup

            # echo "run replicas"

            # ./run.sh new myrun_replica_rep_${r}_cli_${c}_size_${s}

            # sleep 5

            # for x in `seq 1 $r`
            # do
            #     host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            #     echo "Run dstat on replica server ${host}"
            #     (ssh zhe@$host "dstat --output /tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt 1 30" > /dev/null & )
            # done

            # for x in `seq $ind ${ip_num}`
            # do
            #     host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            #     echo "Run dstat on client server ${host}"
            #     (ssh zhe@$host "dstat --output /tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt 1 30" > /dev/null & )
            # done

            # echo "run clients"

            # ./run_cli.sh new myrun_client_rep_${r}_cli_${c}_size_${s}

            # sleep 20

            # echo "stop clients"

            # ./run_cli.sh stop myrun_client_rep_${r}_cli_${c}_size_${s}

            # ./run_cli.sh fetch myrun_client_rep_${r}_cli_${c}_size_${s} 
            
            # mv ./myrun_client_rep_${r}_cli_${c}_size_${s} ./log

            # mkdir -p ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}

            # echo "stop replicas"

            # ./run.sh stop myrun_replica_rep_${r}_cli_${c}_size_${s}

            # ./run.sh fetch myrun_replica_rep_${r}_cli_${c}_size_${s}

            # mv ./myrun_replica_rep_${r}_cli_${c}_size_${s} ./log

            # for x in `seq 1 $r`
            # do
            #     host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            #     (scp zhe@$host:/tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt ./log/myrun_perf_rep_${r}_cli_${c}_size_${s} )
            #     (ssh zhe@$host "rm /tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt" )
            #     sed -i '1,5d' ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt
            # done

            # for x in `seq $ind ${ip_num}`
            # do
            #     host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            #     (scp zhe@$host:/tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt ./log/myrun_perf_rep_${r}_cli_${c}_size_${s} )
            #     (ssh zhe@$host "rm /tmp/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt" )
            #     sed -i '1,5d' ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt
            # done

            # echo "process data"
            # cat ./log/myrun_client_rep_${r}_cli_${c}_size_${s}/remote/*/log/stderr | python3 ../thr_hist.py | tee ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/perf_rep_${r}_cli_${c}_size_${s}.txt

            for x in `seq 1 $r`
            do
                # python3 dstat_proc.py --input ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt --index ${x} --replica 1 >> ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/perf_rep_${r}_cli_${c}_size_${s}.txt
                if [ ${x} == 1 ]
                then 
                    cat ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt > ./tmp.txt
                else 
                    sed '1d' ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt >> ./tmp.txt
                fi
            done

            python3 dstat_proc.py --input ./tmp.txt --index ${x} --replica 1 --overall 1 >> ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/perf_rep_${r}_cli_${c}_size_${s}.txt

            rm ./tmp.txt

            for x in `seq $ind ${ip_num}`
            do
                # python3 dstat_proc.py --input ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt --index ${x} --replica 0 >> ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/perf_rep_${r}_cli_${c}_size_${s}.txt
                if [ ${x} == $ind ]
                then 
                    cat ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt > ./tmp.txt
                else 
                    sed '1d' ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/dstat_server_${x}_rep_${r}_cli_${c}_size_${s}.txt >> ./tmp.txt
                fi
            done

            python3 dstat_proc.py --input ./tmp.txt --index ${x} --replica 0 --overall 1 >> ./log/myrun_perf_rep_${r}_cli_${c}_size_${s}/perf_rep_${r}_cli_${c}_size_${s}.txt

            rm ./tmp.txt

        done
    done
done

