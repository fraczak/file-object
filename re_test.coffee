file_object = require("./")

my_obj  = file_object {}, {file: "test.json"}


console.log "\n Running 're_test' ...\n"
console.log "Value of 'my_obj': #{JSON.stringify my_obj}"

setTimeout ->
    file_object.stop(my_obj)
, 10000

console.log "The program will end in seconds, once we `stop` backing up ..."
   
