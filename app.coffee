express = require 'express'
minimist = require 'minimist'
path = require 'path'
gitRev = require 'git-rev'
connectUAParser = require 'connect-ua-parser'
connectSlashes = require 'connect-slashes'


# 处理 argv
argv = minimist process.argv.slice(2)
isInProduction = argv.production ? false
port = if argv.p? then argv.p else 8000
console.log 'Listening on port ' + port + '.'


# 初始化应用
app = express()

app.set 'views', path.join(__dirname, 'templates')
app.set 'view engine', 'jade'


# 公共参数
app.locals.DEBUG_LIVERELOAD = !isInProduction
gitRev.short (short) ->
  app.locals.VER_GIT = short


# 中间件
app.use express.logger()
app.use '/static', express.static('static')
app.use connectSlashes(false)  # 标准化 URL, 去掉末尾的 /


# 干掉 oldIE
isOldIE = (uaObj) ->
  uaObj.ua.family == 'IE' and parseInt(uaObj.ua.major) < 11


app.use connectUAParser()
app.use (req, res, next) ->
  if isOldIE req.useragent then res.render 'misc/no-ie' else next()


# 视图
app.get '/', (req, res) ->
  res.render 'home'

app.get '/register', (req, res) ->
  res.render 'controller/register'


# Fire up JNRain!
app.listen port


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
