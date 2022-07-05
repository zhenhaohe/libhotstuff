#!/bin/bash
#$1 number of replicas
#$2 number of clients

replica=(10)
client=(24)
for r in "${replica[@]}"  
do
    for c in "${client[@]}"  
    do
        ip_num=`sed -n '$=' ip_list.txt`
        echo "Total IP: ${ip_num}"

        python3 gen_host_list.py --num_replica ${r} --num_clients ${c}

        ./gen_all.sh

        echo "setup"

        ./run.sh setup

        echo "run replicas"

        ./run.sh new myrun_replica_rep_${r}_cli_${c}

        sleep 5

        for x in `seq 1 $r`
        do
            host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            echo "Run dstat on replica server ${host}"
            (ssh zhe@$host "dstat --output /tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt 1 30" > /dev/null & )
        done

        ind=$(($r+1))
        for x in `seq $ind ${ip_num}`
        do
            host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            echo "Run dstat on client server ${host}"
            (ssh zhe@$host "dstat --output /tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt 1 30" > /dev/null & )
        done

        echo "run clients"

        ./run_cli.sh new myrun_client_rep_${r}_cli_${c}

        sleep 20

        echo "stop clients"

        ./run_cli.sh stop myrun_client_rep_${r}_cli_${c}

        ./run_cli.sh fetch myrun_client_rep_${r}_cli_${c}

        mkdir -p myrun_perf_rep_${r}_cli_${c}

        cat myrun_client_rep_${r}_cli_${c}/remote/*/log/stderr | python3 ../thr_hist.py | tee myrun_perf_rep_${r}_cli_${c}/perf.txt

        echo "stop replicas"

        ./run.sh stop myrun_replica_rep_${r}_cli_${c}

        ./run.sh fetch myrun_replica_rep_${r}_cli_${c}

        for x in `seq 1 $r`
        do
            host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            (scp zhe@$host:/tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt ./myrun_perf_rep_${r}_cli_${c} )
            (ssh zhe@$host "rm /tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt" )
            sed -i '1,5d' ./myrun_perf_rep_${r}_cli_${c}/dstat_server_${x}_rep_${r}_cli_${c}.txt
            python3 dstat_proc.py --input ./myrun_perf_rep_${r}_cli_${c}/dstat_server_${x}_rep_${r}_cli_${c}.txt --index ${x} --replica 1 >> myrun_perf_rep_${r}_cli_${c}/perf.txt
        done

        for x in `seq $ind ${ip_num}`
        do
            host=`sed -n ${x}p ip_list.txt | cut -d " " -f1`
            (scp zhe@$host:/tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt ./myrun_perf_rep_${r}_cli_${c} )
            (ssh zhe@$host "rm /tmp/dstat_server_${x}_rep_${r}_cli_${c}.txt" )
            sed -i '1,5d' ./myrun_perf_rep_${r}_cli_${c}/dstat_server_${x}_rep_${r}_cli_${c}.txt
            python3 dstat_proc.py --input ./myrun_perf_rep_${r}_cli_${c}/dstat_server_${x}_rep_${r}_cli_${c}.txt --index ${x} --replica 0 >> myrun_perf_rep_${r}_cli_${c}/perf.txt
        done

    done
done

