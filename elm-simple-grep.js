const fs = require('fs');
const query = process.argv[2];
const filename = process.argv[3];
const text = fs.readFileSync(filename, "utf-8");
const Elm = require('./Main.js');
var app = Elm.Elm.Main.init({flags: [query, filename]});
app.ports.getArgs.send([query, text]);
app.ports.returnResult.subscribe(function(result) {
  console.log(result);
});
