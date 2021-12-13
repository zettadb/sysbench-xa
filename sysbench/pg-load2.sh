#./sysbench --max-time=360 --test=tests/db/oltp.lua  --pgsql-host=192.168.1.2  --pgsql-port=5401 --pgsql-db=postgres --oltp_tables_count=20 --oltp-table-size=500000 --oltp-read-only=off --init-rng=on --num-threads=200  --max-requests=0 --oltp-dist-type=uniform --pgsql-user='zhaowei' --pgsql-password=''  --oltp_auto_inc=off --db-driver=pgsql --report-interval=1 $1

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`
host="${TESTHOST:-127.0.0.1}"
port="${TESTPORT:-5401}"
dbname="${TESTDB:-test}"
user="${TESTUSER:-abc}"
pass="${TESTPASS:-abc}"
tblcnt="${TESTCOUNT:-20}"
tblsize="${TESTSIZE:-4000000}"
action="${TESTACTION:-prepare}"

./sysbench --test=tests/db/oltp.lua  --pgsql-host=$host  --pgsql-port=$port --pgsql-db=$dbname --oltp_tables_count=$tblcnt --oltp-table-size=$tblsize --oltp-read-only=off --init-rng=on  --num-threads=100  --max-requests=0 --oltp-dist-type=uniform --pgsql-user=$user --pgsql-password="$pass" --oltp_auto_inc=off --db-driver=pgsql --report-interval=20 $action
