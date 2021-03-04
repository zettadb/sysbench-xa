export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`
bash ./perftest.sh run 6001
sleep 20
bash ./perftest.sh run 6002
