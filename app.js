var express = require('express');
var logger = require('morgan');
var stylus = require('stylus');
var path = require('path');

var app = express();

app.set('port', 3000);
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(stylus.middleware(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
  res.render('index');
});

app.listen(app.get('port'), function() {
  console.log('app is listening on http://localhst:' + app.get('port'));
});
