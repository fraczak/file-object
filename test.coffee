json_file_object = require("./")

counter = 3
my_obj  = json_file_object
    value: {hey:"Start", q:[]}
    file: "test.json"
    saveEverySecs:1
    forceNew:true

test    = ->
    console.log counter, JSON.stringify my_obj
    my_obj.q.push counter
    if counter > 0
        counter--
        setTimeout test, 1000
    else
        json_file_object.stopAll()
        console.log "The file 'test.json' was created and contains the content of 'my_obj'"

do test
