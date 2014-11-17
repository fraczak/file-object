file-db
=======

A mockup of a db - periodically storing a "JSON"-able object in a file so it can be recover after restart.

For example:

    var file_db = require("file_db");
    var my_object = file_db({}, {file:"./my_db.json", saveEverySecs: 15});
    // The object is saved to the file every 15 secs. If the file exists, the object is initialized
    // with the JSON content of the file
    
    
