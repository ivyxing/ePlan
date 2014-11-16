var express = require("express");
var logfmt = require("logfmt");
var mongo = require("mongodb");
var bodyParser = require("body-parser");
var mongoskin = require("mongoskin");

var app = express();
app.use(bodyParser());

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
 'mongodb://localhost/mydb';

var db = mongoskin.db(mongoUri, {safe:true});

app.set('port',(process.env.PORT || 5000));

app.get('/', function(req, res) {
    res.send('test');
});

app.get('/events', function(req, res, next) {
	var eventsCollection = db.collection("events");
  	eventsCollection.find({} ,{limit:100, sort: [['_id', -1]]}).toArray(function(e, results){
    	if (e) return next(e)
    	res.send(results)
  })
})

app.get('/tasks', function(req, res, next) {
  var tasksCollection = db.collection("tasks");
    eventsCollection.find({} ,{limit:100, sort: [['_id', -1]]}).toArray(function(e, results){
      if (e) return next(e)
      res.send(results)
  })
})

app.post('/events', function(req, res, next) {
	var eventsCollection = db.collection("events")
	console.log(req.body)
	eventsCollection.insert(req.body, {}, function(e, results) {
		if (e) {
			return next(e)
		}
		res.send(results)
	})
})

app.post('/tasks', function(req, res, next) {
  var tasksCollection = db.collection("tasks")
  console.log(req.body)
  tasksCollection.insert(req.body, {}, function(e, results) {
    if (e) {
      return next(e)
    }
    res.send(results)
  })
})

app.get('/events/:id', function(req, res, next) {
	var eventsCollection = db.collection("events")
  	eventsCollection.findById(req.params.id, function(e, result){
    	if (e) return next(e)
    	res.send(result)
  })
})

app.get('/tasks/:id', function(req, res, next) {
  var tasksCollection = db.collection("tasks")
    tasksCollection.findById(req.params.id, function(e, result){
      if (e) return next(e)
      res.send(result)
  })
})

app.put('/events/:id', function(req, res, next) {
	var eventsCollection = db.collection("events")
  	eventsCollection.updateById(req.params.id, {$set:req.body}, {safe:true, multi:false}, function(e, result){
    if (e) return next(e)
    res.send((result===1)?{msg:'success'}:{msg:'error'})
  })
})

app.put('/tasks/:id', function(req, res, next) {
  var tasksCollection = db.collection("tasks")
    tasksCollection.updateById(req.params.id, {$set:req.body}, {safe:true, multi:false}, function(e, result){
    if (e) return next(e)
    res.send((result===1)?{msg:'success'}:{msg:'error'})
  })
})

app.del('/events/:id', function(req, res, next) {
	var eventsCollection = db.collection("events");
  	eventsCollection.removeById(req.params.id, function(e, result){
    	if (e) return next(e)
    	res.send((result===1)?{msg:'success'}:{msg:'error'})
  })
})

app.del('/tasks/:id', function(req, res, next) {
  var tasksCollection = db.collection("events");
    tasksCollection.removeById(req.params.id, function(e, result){
      if (e) return next(e)
      res.send((result===1)?{msg:'success'}:{msg:'error'})
  })
})

app.listen(app.get('port'), function() {
    console.log("Listening on " + app.get('port'));
});
