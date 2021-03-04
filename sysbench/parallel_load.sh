
./sysbench --max-time=1800 --test=tests/db/parallel_prepare.lua  --mysql-host=127.0.0.1  --mysql-port=$port --mysql-db=test --oltp_tables_count=20 --oltp-table-size=4000000 --oltp-read-only=off --init-rng=on --num-threads=20  --max-requests=0 --oltp-dist-type=uniform --mysql-user='abc' --mysql-password='abc'  --oltp_auto_inc=off --db-driver=mysql --oltp_use_xa_pct=95 --oltp_use_xa_2pc_pct=80 $1
