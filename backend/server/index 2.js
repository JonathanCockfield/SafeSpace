import https from "https";
import fs from "fs";
import express from "express";
import logger from "morgan";
import cors from "cors";
import * as SocketIO from "socket.io";
// routes
import userRouter from "../routes/user.js";
import chatRoomRouter from "../routes/chatRoom.js";
import deleteRouter from "../routes/delete.js";
// mongo connection
import "../config/mongo.js";
// firebase connection
import firebaseAdmin from '../config/firebase.js';
// socket configuration
import WebSockets from "../utils/WebSockets.js";

const app = express();

/** Get port from environment and store in Express. */
const port = process.env.PORT || "3000";

const host = process.env.HOST || "localhost";

const options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem')
};

app.set("port", port);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/users", firebaseAdmin.checkIfAuthenticated, userRouter);
app.use("/room", firebaseAdmin.checkIfAuthenticated, chatRoomRouter);
app.use("/delete", firebaseAdmin.checkIfAuthenticated, deleteRouter);

/** catch 404 and forward to error handler */
app.use('*', (req, res) => {
  return res.status(404).json({
    success: false,
    message: 'API endpoint doesnt exist'
  })
});

/** Create HTTP server. */
const server = https.createServer(options, app);

/** Create socket connection */
const socketio = new SocketIO.Server(server);
global.io = socketio.listen(server);
global.io.on('connection', WebSockets.connection)
/** Listen on provided port, on all network interfaces. */
server.listen(port, host);
/** Event listener for HTTP server "listening" event. */
server.on("listening", () => {
  console.log(`Listening on port:: http://${host}:${port}/`)
});