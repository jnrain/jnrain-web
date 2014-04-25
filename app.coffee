#!/usr/bin/env coffee

express = require 'express'
minimist = require 'minimist'
path = require 'path'
gitRev = require 'git-rev'
morgan = require 'morgan'  # formerly express.logger
connectUAParser = require 'connect-ua-parser'
connectSlashes = require 'connect-slashes'
fs = require 'fs'
https = require 'https'
helmet = require 'helmet'


# 处理 argv
argv = minimist process.argv.slice(2)
isInProduction = argv.production ? false
port = argv.p ? 8000
deployChannelName = argv.channel ? 'localdebug'

# SSL 参数
# 生产环境下由 nginx 等组件负责 SSL, 强制关闭 Node.js 的 SSL 支持
sslEnabled = !(argv['disable-ssl'] or isInProduction)
keyFile = argv.keyfile
certFile = argv.certfile

if sslEnabled
  unless keyFile? and certFile?
    console.error 'error: SSL must be configured by passing --keyfile and --certfile!'
    process.exit 100

  sslOptions =
    key: fs.readFileSync keyFile
    cert: fs.readFileSync certFile


# 初始化应用
app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'


# 公共参数
app.locals.DEPLOY_CHANNEL_NAME = deployChannelName
app.locals.DEBUG_LIVERELOAD = !isInProduction
gitRev.short (short) ->
  app.locals.VER_GIT = short


# 基本安全设置
app.use helmet.xframe 'deny'
app.use helmet.hsts 31536000, true  # 31536000s = 365d
app.disable 'x-powered-by'


# 中间件
app.use morgan()
app.use '/static', express.static('static') unless isInProduction
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

app.get '/login', (req, res) ->
  res.render 'controller/login'

app.get '/logout', (req, res) ->
  res.render 'controller/logout'

app.get '/register', (req, res) ->
  res.render 'controller/register'

app.get /^\/verifymail\/([0-9A-Za-z_-]{32})$/, (req, res) ->
  res.render 'controller/verifymail',
    activationKey: req.params[0]


# Fire up JNRain!
server = if sslEnabled then https.createServer sslOptions, app else app
server.listen port, () ->
  if sslEnabled
    console.log 'Using SSL private key: ' + keyFile
    console.log 'Using SSL certificate: ' + certFile

  console.log 'Listening on port ' + port + '.'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
