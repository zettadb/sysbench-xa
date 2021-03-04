#usage: perftest.sh run port

port=$2

echo 'data size: 20GB, 20 tables, each 4M rows. PostgreSQL buffer pool size: 16GB' >>  sb-pg-out-$port.txt
echo '======================== 500 conns ======================== '  >>  sb-pg-out-$port.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`

echo `date` >>  sb-pg-out-$port.txt
echo 'oltp.lua, read only, to warm up buffer' >>  sb-pg-out-$port.txt
./sysbench --max-time=300 --test=tests/db/oltp.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=on --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt



sleep 15
echo `date` >>  sb-pg-out-$port.txt
echo 'oltp.lua, read&write ' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt

sleep 15
echo `date` >>  sb-pg-out-$port.txt
echo 'oltp.lua, write only' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt

sleep 15

echo `date` >>  sb-pg-out-$port.txt
echo 'update_non_index' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/update_non_index.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=500  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt

sleep 15
echo '======================== 200 conns ======================== ' >>  sb-pg-out-$port.txt


echo `date` >>  sb-pg-out-$port.txt
echo 'oltp.lua, read&write ' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=off --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt


sleep 15
echo `date` >>  sb-pg-out-$port.txt
echo 'oltp.lua, write only' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/oltp.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-write-only=on --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=0 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt


sleep 15
echo `date` >>  sb-pg-out-$port.txt
echo 'update_non_index' >>  sb-pg-out-$port.txt
./sysbench --max-time=600 --test=tests/db/update_non_index.lua  --pgsql-host=127.0.0.1  --pgsql-port=$port --pgsql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='kunlun' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 --report-interval=1 $1 >> sb-pg-out-$port.txt



