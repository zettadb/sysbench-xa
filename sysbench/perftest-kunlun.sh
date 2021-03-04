#usage: perftest.sh run port

port=$2

echo 'data size: 40GB, 20 tables, each 8M rows. Two storage shards, each containing 10 tables. Kunlun-mysql Innodb buffer pool size: 16GB' >>  sb-kunlun-out-$port.txt
echo '======================== 500 conns ======================== '  >>  sb-kunlun-out-$port.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`

#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'oltp-randtabs.lua, read only, to warm up buffer' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp-randtabs.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#
#sleep 15
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'oltp-randtabs.lua, write only' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp-randtabs.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#
#
#sleep 15
echo `date` >>  sb-kunlun-out-$port.txt
echo 'oltp-randtabs.lua, read(point-selects only) &write ' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-randtabs.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --oltp_point_selects=10 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
##
#sleep 15
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'oltp.lua, write only' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
##
#sleep 15
##
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'update_non_index.lua' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/update_non_index.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#


#sleep 15
#echo '======================== 200 conns ======================== ' >>  sb-kunlun-out-$port.txt
#
#
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'oltp.lua, read&write ' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#
#
#sleep 15
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'oltp.lua, write only' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#
#
#sleep 15
#echo `date` >>  sb-kunlun-out-$port.txt
#echo 'update_non_index' >>  sb-kunlun-out-$port.txt
#./sysbench --max-time=300 --test=tests/db/update_non_index.lua  --pgsql-host=192.168.0.105  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=8000000 --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-kunlun-out-$port.txt
#
#
#
