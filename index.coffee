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
        setInterval ->
            fs.writeFile file, JSON.stringify obj, null, 2, (err) ->
                console.log err if err
        , saveEverySecs * 1000
        created_db[file] = obj

    return created_db[file]
