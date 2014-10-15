var express = require("express");
var logfmt = require("logfmt");
var mongo = require('mongodb');

var app = express();
app.use(logfmt.requestLogger());

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
 'mongodb://localhost/mydb';

var db = mongoskin.db(mongoUri, {safe:true})

app.param('collectionName', function(req,res,next, collectionName){
  req.collection = db.collection(collectionName)
  return next()
})

app.get('/', function(req, res) {
  res.send('anything')
})

var port = Number(process.env.PORT || 5000);
app.listen(port, function() {
  console.log("Listening on " + port);
});
