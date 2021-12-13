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

# echo 'data size: 40GB, 20 tables, each 8M rows. Two storage shards, each containing 10 tables. Kunlun-mysql Innodb buffer pool size: 16GB' >>  sb-kunlun-out-$port.txt
# echo '======================== 500 conns ======================== '  >>  sb-kunlun-out-$port.txt

echo `date` >>  sb-kunlun-out-$port.txt
echo 'oltp.lua, read only, to warm up buffer' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=10 $action >> sb-kunlun-out-$port.txt


sleep 15
echo `date` >>  sb-kunlun-out-$port.txt
echo 'oltp.lua, read&write ' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=10 $action >> sb-kunlun-out-$port.txt

sleep 15
echo `date` >>  sb-kunlun-out-$port.txt
echo 'oltp.lua, write only' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=10 $action >> sb-kunlun-out-$port.txt

sleep 15

echo `date` >>  sb-kunlun-out-$port.txt
echo 'update_non_index' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=600 --test=tests/db/update_non_index.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=10 $action >> sb-kunlun-out-$port.txt


sleep 15

echo `date` >>  sb-kunlun-out-$port.txt
echo 'update_index' >>  sb-kunlun-out-$port.txt
./sysbench --max-time=600 --test=tests/db/update_index.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=$thrcnt  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password=$pass  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=10 $action >> sb-kunlun-out-$port.txt
