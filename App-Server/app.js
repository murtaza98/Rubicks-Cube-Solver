const express = require('express');
const bodyParser = require('body-parser');
const Cube = require('cubejs');

// express
const app = express();

// This takes 4-5 seconds on a modern computer
Cube.initSolver();

// to handle CORS
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader(
      'Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept'
    );
    res.setHeader(
      'Access-Control-Allow-Methods',
      'GET, POST, OPTIONS, DELETE, PATCH, PUT'
    );
    next();
  });

// to parser post request data
app.use(bodyParser.json());

app.post('/api/solve', (req, res, next) => {
    // console.log(req.body.scramleSequence);    

    const scramleSequence = req.body.scramleSequence;

    // Create a new solved cube instance
    const cube = new Cube();
    // Apply an algorithm or randomize the cube state
    cube.move(scramleSequence);

    const solution = cube.solve();
    res.status(200).json({
        message: 'Success',
        sequence: solution
      });
  });

// export this app
module.exports = app;