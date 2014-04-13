express = require 'express'
minimist = require 'minimist'
path = require 'path'
port = 8000

# 处理 argv
argv = minimist process.argv.slice(2)
isInProduction = argv.production ? false


# 初始化应用
app = express()

app.set 'views', path.join(__dirname, 'templates')
app.set 'view engine', 'jade'

# 公共参数
app.locals.DEBUG_LIVERELOAD = !isInProduction

# 中间件
app.use express.logger()
app.use '/static', express.static('static')

# 视图
app.get '/', (req, res) ->
  res.render 'home'

app.get '/register', (req, res) ->
  res.render 'controller/register'

app.listen port


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
