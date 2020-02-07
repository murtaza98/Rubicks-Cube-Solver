LOGS="./server_logs.txt"
currentDate=`date`
echo "---------------------------------------------------------------------------------" >> $LOGS
echo $currentDate >> $LOGS
# start 3x3 node server
cd ./3x3_Solver
nohup node server.js >> $LOGS 2>&1 &
echo "Node server PID --> $!" >> $LOGS
if [ $? -eq 0 ]; then
    echo "3x3 Cube Node server started."
else
    echo "Failed to start 3x3 Cube Node server."
fi
cd ../
# 
# start 4x4 java server
cd ./4x4_Solver
nohup java JavaHTTPServer >> $LOGS 2>&1 &
echo "Java server PID --> $!" >> $LOGS
if [ $? -eq 0 ]; then
    echo "4x4 Cube Java server started."
else
    echo "Failed to start 4x4 Cube Java server."
fi
cd ../
# 
# start 5x5 python server