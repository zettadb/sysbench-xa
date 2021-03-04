#usage: perftest.sh run port

port=$2

echo 'data size: 20GB, 20 tables, each 4M rows. innodb buffer pool size: 16GB' >>  sb-out-$port.txt
echo '======================== 500 conns ======================== '  >>  sb-out-$port.txt

echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, read only, to warm up buffer' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt

sleep 15

echo `date` >>  sb-out-$port.txt
echo 'update_non_index_xa.lua' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/update_non_index_xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=100 --oltp_use_xa_2pc_pct=100  --report-interval=3 $1  >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, read&write ' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt

sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, write only' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt

sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp-xa.lua, read&write ' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt

sleep 15

echo `date` >>  sb-out-$port.txt
echo 'oltp-xa.lua, write only' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt



sleep 15

echo `date` >>  sb-out-$port.txt
echo 'update_non_index' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/update_non_index.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt

sleep 15
echo '======================== 1000 conns ======================== ' >>  sb-out-$port.txt
echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, read only, to warm up buffer' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'update_non_index_xa.lua' >>  sb-out-$port.txt

./sysbench --max-time=300 --test=tests/db/update_non_index_xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=100 --oltp_use_xa_2pc_pct=100  --report-interval=3 $1  >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, read&write ' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp.lua, write only' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp-xa.lua, read&write ' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'oltp-xa.lua, write only' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp-xa.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt


sleep 15
echo `date` >>  sb-out-$port.txt
echo 'update_non_index' >>  sb-out-$port.txt
./sysbench --max-time=300 --test=tests/db/update_non_index.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-read-only=off --init-rng=on --num-threads=1000  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=3 $1 >> sb-out-$port.txt



