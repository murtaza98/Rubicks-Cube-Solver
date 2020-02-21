# Rubicks-Cube-Solver 

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

A cool Rubicks cube Simulation. SCRAMBLE -> SOLVE -> REPEAT


### Android App Demo

<div align="center">


<img src="./assets/3x3_demo.gif" width=245px>&emsp;&emsp;&emsp;
<img src="./assets/4x4_demo.gif" width=245px>&emsp;&emsp;&emsp;
<img src="./assets/5x5_demo.gif" width=245px>

</div>

### Installation

1. clone with all submodules </br>
`git clone https://github.com/murtaza98/Rubicks-Cube-Solver.git`

2. Download Processing from [here](https://processing.org/download/)

3. For Server Installation, </br>
  `cd Rubicks-Cube-Solver/App-Server` </br>
  `chmod a+x install.sh` </br>
  `chmod a+x run.sh` </br>
  `./install.sh`


### Usage
1. First start the servers </br>
`cd Rubicks-Cube-Solver/App-Server` </br>
`./run.sh`

2. Next start the GUI using Processing, so first start Processing and then click File -> Open, there goto App-Client directory and select Rubicks_Cube_Main.pde in Rubicks_Cube_Main folder

3. Then click on Play button

### Contributers

1. Murtaza Patrawala -- [@murtaza98](https://github.com/murtaza98)

### References
Following are a list of projects that I integrated over here
1. Daniel Shiffman aka The Coding Train his Rubick's Cube Coding Challenge [link](https://youtu.be/9PGfL4t-uqE)
2. [cubejs](https://github.com/ldez/cubejs) for implementation of Herbert Kociemba's two-phase algorithm for solving 3x3 cube
3. [cs0x7f](https://github.com/cs0x7f) for implementation of a modified Kociemba's algo for solving 4x4 and 5x5 cube.



