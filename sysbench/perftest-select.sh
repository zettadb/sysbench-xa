
#usage: perftest.sh run port

port=$2

echo 'data size: 20GB, 20 tables, each 4M rows. innodb buffer pool size: 16GB' >>  sb-mysql-select-$port.txt
echo '======================== 500 conns ======================== '  >>  sb-mysql-select-$port.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`
echo `date` >>  sb-mysql-select-$port.txt
echo 'oltp.lua, read only, 10 point selects' >>  sb-mysql-select-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=192.168.0.105  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --oltp_point_selects=10 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0  --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-mysql-select-$port.txt
