fs = require 'fs'

onWrite = {}
stopped = false
created_db = {}
module.exports = ({value = {}, file = "json_file_object.json", saveEverySecs = 5, forceNew = false} = {}) ->
  if created_db[file]
    throw new Error "File #{file} in use already"
  if not forceNew
    try
      value = JSON.parse fs.readFileSync file, 'utf8'
    catch error
      console.warn error
  return value if stopped
  interval = setInterval ->
    writeFile file, value
  , saveEverySecs * 1000
  created_db[file] = {obj:value, interval}

  created_db[file].obj

writeFile = (file,obj) ->
  fs.writeFile file, JSON.stringify(obj, null, 2), (err) ->
    console.warn err if err
    onWrite[file]?()

module.exports.stop = (obj) ->
  file = find_file obj
  if file
    onWrite[file] = ->
      stop file

module.exports.stopAll = ->
  return if stopped
  stopped = true
  for file of created_db
    onWrite[file] = ->
      stop file

module.exports.erase = (obj) ->
  file = find_file obj
  if file
    onWrite[file] = ->
      erase file

module.exports.eraseAll = ->
  stopped = true
  for file of created_db
    do (file = file) ->
      onWrite[file] = ->
        erase file

stop = (file) ->
  record = created_db[file]
  if record?
    clearInterval record.interval
    delete created_db[file]
  delete onWrite[file]

erase = (file) ->
  stop file
  fs.unlink file, (err) ->
    console.warn err if err

find_file = (obj) ->
  for file, val of created_db when obj is val.obj
    return file
  undefined
