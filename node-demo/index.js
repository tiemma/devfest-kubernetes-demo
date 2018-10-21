var app = require('express')();
var http = require('http').Server(app);
var port = process.env.PORT || 3000;
var io = require('socket.io')(http);
var randomNumber = Math.floor(Math.random() * 255);
var requestRandomNumber = null;

app.get('/', function (req, res) {
  requestRandomNumber = Math.floor(Math.random() * 255)
  if (requestRandomNumber > 150) {
    //Let's purposefully break our app
    res.send({ error: true, random: randomNumber }).status(500)
    process.emit('SIGINT');
  } else {
    res.send(`
    Random number for this pod is: + ${randomNumber}. 
    <br \>
    You env variable with property key is: ${process.env.KEY}
    `);
  }
});

app.get('/ready', function (req, res) {
  res.send({ success: true, data: process.env }).status(200);
});

app.get('/logs', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

http.listen(port, function () {
  console.log('listening on *:' + port);
});

io.on('connection', function (socket) {
  console.log(socket.id);

  socket.emit('acknowledge', true);

  // when socket disconnects, remove it from the list:
  socket.on("disconnect", function () {
    console.info(`Client gone [id=${socket.id}]`);
  });
});

process.on('SIGINT', function () {
  console.log("Caught interrupt signal, shutting down!");
  io.emit('consume', `Error occured on pod ${randomNumber} due to random number ${requestRandomNumber}`);
});

