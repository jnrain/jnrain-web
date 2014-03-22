express = require 'express'
path = require 'path'
port = 8000

app = express()

app.set 'views', path.join(__dirname, 'templates')
app.set 'view engine', 'jade'

app.use express.static('static')
app.use express.logger()

app.get '/', (req, res) ->
  res.render 'skel'

app.listen port


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
