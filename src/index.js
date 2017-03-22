'use strict';


// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var app = Elm.Main.fullscreen();

/*
app.ports.store.subscribe(function(data) {
    store(data);
});

app.ports.retrieve.subscribe(function(key) {
    var value = retrieve(key);
    app.ports.value.send(value);
});
*/