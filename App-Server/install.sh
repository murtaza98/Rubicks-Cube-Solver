# install node modules for 3x3
# modules -> http, express, cubejs
echo "Installing Node Modules for 3x3 server"
cd ./3x3_Solver
npm install http express cubejs
if [ $? -eq 0 ]; then
    echo "Node server -> Installation success"
else
    echo "Error while installing node modules for 3x3 server"
fi
cd ../


# compile java server file
cd ./4x4_Solver
javac JavaHTTPServer.java
if [ $? -eq 0 ]; then
    echo "Java Server -> Installation success"
else
    echo "Error while compiling java files for 4x4 server"
fi
cd ../


# install for nxn cube
