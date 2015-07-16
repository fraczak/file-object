ld          = require 'lodash'
file_object = require("./")

counter = 3
my_obj  = file_object {hey:"Start"}, {file: "test.json", saveEverySecs:1, forceNew:true}
test    = ->
    console.log counter, JSON.stringify my_obj
    my_obj[counter] = ld.clone my_obj
    if counter > 0
        counter--
        setTimeout test, 1000
    else
        require("./").stopAll()
        console.log "The file 'test.json' was created and contains the content of 'my_obj'"

do test
