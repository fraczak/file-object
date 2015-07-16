file-object
===========

A mockup of a db for a single "JSON"-able object, periodically stored
in a file so it can be recover after restart.

For example:

    var my_obj = require("file-object")();

The variable `my_obj` is saved to the file `file_object.json` every 5
secs.  If the file exists, the object is initialized with the JSON
parsed content of the file, if not it is initialized to `{}`.

The above defaults (for file name, interval, or initial value) can be
specified by the parameters passed to the constructor function
returned by `file_object = require("file-object")`. I.e.,
`file_object()` really means:

* `file_object({}, {file: "file_object.json", saveEverySecs: 5, forceNew: false})`

If flag `forceNew` is set, the old content of the file is ignored and the initial value of the returned object is set by the first argument.

The generator function returned by `require("file-object")`, called
here `file_object`, has following methods:

* `file_object.stop(obj)` - stops recording `obj` to its file
* `file_object.stopAll()` - stops all recordings
* `file_object.erase(obj)` - stops recording `obj` and erases the corresponding file
* `file_object.eraseAll()` - stops all recordings and erases all corresponding files

Warning!
-------
You ___can not___ reassign a new reference to `my_obj` and hope that the new value will be persisted. For example, if you do

    my_obj = ["Hey"];

the old reference kept by `my_obj` is lost, so any change to `my_obj`, such as

    my_obj.push("Ho");

will not be persisted (because the value under the old reference is being persisted). The logic here is somehow similar to `exports` and  `module.exports`.
