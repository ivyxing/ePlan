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

app.param('collectionName', function(req, res, next, collectionName) {
    req.collection = db.collection(collectionName);
    return next();
});

app.set('port',(process.env.PORT || 5000));

app.get('/', function(req, res) {
    res.send('test');
});

app.get('/events', function(req, res, next) {
    req.collection.find({}, {limit:1000, sort:[['_id, -1']]}.toArray(function(e, results) {
        if (e) {
        	return next(e);
        };
  	    res.send(results);
    });
});

app.post('/events', function(req, res, next) {
	var eventsCollection = db.collection("events");
	req.collection.insert(req.body, {}, function(e, results) {
		if (e) {
			return next(e);
		};
		res.send(results);
	});
});

app.put('/events/:id', function(req, res, next) {
	req.collection.updateById(req.params.id, {$set:req.body}, {safe:true, multi:false},
	function(e, result) {
		if (e) { 
			return next(e);
		};
		res.send((result === 1) ? {msg:'success'} : {msg:'error'});
	});
});

app.del('/events/:id', function(req, res, next) {
	req.collection.remove({_id: req.collection.id(req.params.id)}, function(e, result) {
		if (e) {
			return next(e);
		};
		res.send((result === 1) ? {msg:'success'} : {msg:'error'});
	});
    
});

app.listen(app.get('port'), function() {
    console.log("Listening on " + app.get('port'));
});
