express = require('express')
app = express.createServer(express.logger())

app.get '/', (request, response) ->
  pg = require('pg')
  key = request.query['key']
  pg.connect 'postgres://zmoazeni:@localhost/test_node', (err, client) ->
    response.send("Something happened: #{err}") if err

    query = client.query("SELECT val FROM simple_store WHERE key = '#{key}'")
    query.on 'row', (row) ->
      response.send("Value for #{key} is #{JSON.stringify(JSON.parse(row['val']))}")

    query.on 'end', ->
      response.send("Nothing found for #{key}")

port = process.env.PORT || 5000
app.listen port, ->
  console.log("Listening on #{port}")