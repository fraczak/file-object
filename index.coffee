fs = require 'fs'
_  = require 'lodash'

extend = (dst, src) ->
    if _.isArray dst
        dst.concat src
    else
        _.assign dst, src
    return dst

created_db = {}
module.exports = (obj, {file, saveEverySecs, forceNew } = {}) ->
    file ?= "undefined.json_db"
    saveEverySecs ?= 5
    forceNew ?= false

    if not created_db[file]
        if not forceNew
            try
                extend obj, JSON.parse fs.readFileSync file, 'utf8'
            catch error
                console.warn error
        interval = setInterval ->
            writeFile file, obj
        , saveEverySecs * 1000
        created_db[file] = {obj,interval}

    return created_db[file].obj

writeFile = (file,obj) ->
    fs.writeFile file, JSON.stringify obj, null, 2, (err) ->
        console.log err if err

module.exports.stop = (obj) ->
    file = find_file obj
    if file
        writeFile file, created_db[file]
        stop file

module.exports.stopAll = ->
    for file of created_db
        writeFile file, created_db[file]
        stop file

module.exports.erase = (obj) ->
    file = find_file obj
    erase file if file

module.exports.eraseAll = ->
    for file of created_db
        erase file

stop = (file) ->
    {interval} = created_db[file]
    clearInterval interval
    delete created_db[file]

erase = (file) ->
    stop file
    fs.unlinkSync file

find_file = (obj) ->
    for file, val of created_db when obj is val.obj
        return file
    undefined
