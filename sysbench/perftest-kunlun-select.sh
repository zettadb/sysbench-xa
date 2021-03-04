#usage: perftest.sh run port

port=$2

echo 'data size: 40GB, 20 tables, each 8M rows. Two storage shards, each containing 10 tables. Kunlun-mysql Innodb buffer pool size: 16GB' >>  sb-kunlun-out-select-$port.txt
echo '======================== 500 conns ======================== '  >>  sb-kunlun-out-select-$port.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`

echo `date` >>  sb-kunlun-out-select-$port.txt
echo 'oltp.lua, read only, 10 point selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=10 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=1 $1 >> sb-kunlun-out-select-$port.txt

echo 'oltp-randtabs.lua, read only, 10 point selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-randtabs.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=10 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=1 $1 >> sb-kunlun-out-select-$port.txt

# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
#echo 'oltp.lua, read only, 1 sum range selects' >>  sb-kunlun-out-select-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=0 --oltp_sum_ranges=1 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=1 $1 >> sb-kunlun-out-select-$port.txt


# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
#echo 'oltp.lua, read only, 1 order by range selects' >>  sb-kunlun-out-select-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=1 --oltp_distinct_ranges=0 --report-interval=1 $1 >> sb-kunlun-out-select-$port.txt
