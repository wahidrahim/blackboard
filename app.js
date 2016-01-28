var express = require('express');
var logger = require('morgan');
var path = require('path');

var app = express();

app.set('port', 3000);
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
  res.render('index');
});

app.listen(app.get('port'), function() {
  console.log('app is listening on http://localhst:' + app.get('port'));
});
