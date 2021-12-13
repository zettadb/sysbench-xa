#usage: perftest.sh run port

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`
action="${1:-run}"
host="${TESTHOST:-127.0.0.1}"
port="${TESTPORT:-5401}"
dbname="${TESTDB:-test}"
user="${TESTUSER:-abc}"
pass="${TESTPASS:-abc}"
tblcnt="${TESTCOUNT:-20}"
tblsize="${TESTSIZE:-4000000}"
thrcnt="${TESTTHREAD:-500}"

# echo 'data size: 40GB, 20 tables, each 8M rows. Two storage shards, each containing 10 tables. Kunlun-mysql Innodb buffer pool size: 16GB' >>  sb-kunlun-out-select-$port.txt
# echo '======================== 500 conns ======================== '  >>  sb-kunlun-out-select-$port.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`

echo `date` >>  sb-kunlun-out-select-$port.txt
echo 'oltp.lua, read only, 10 point selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=10 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=30 $action >> sb-kunlun-out-select-$port.txt

sleep 15

# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
echo 'oltp.lua, read only, 1 simple range selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=1 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=30 $action >> sb-kunlun-out-select-$port.txt

sleep 15

# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
echo 'oltp.lua, read only, 1 sum range selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=0 --oltp_sum_ranges=1 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --report-interval=30 $action >> sb-kunlun-out-select-$port.txt

sleep 15

# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
echo 'oltp.lua, read only, 1 order by range selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=1 --oltp_distinct_ranges=0 --report-interval=30 $action >> sb-kunlun-out-select-$port.txt

sleep 15

# this one takes up all 100M network bandwidth, so performance is restricted by network bandwidth
echo 'oltp.lua, read only, 1 distinct range selects' >>  sb-kunlun-out-select-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --oltp_point_selects=0 --oltp_simple_ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=1 --report-interval=30 $action >> sb-kunlun-out-select-$port.txt

