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
phantom = require 'node-phantom'
raven = require 'raven'


# 处理 argv
argv = minimist process.argv.slice(2)
isDebug = argv.debug ? false
hostName = argv.bind ? '::1'  # 你说你系统不支持 IPv6?!
port = argv.p ? 8000
deployChannelName = argv.channel ? 'localdebug'
isSnapshotsEnabled = !(argv['disable-snapshots'] ? false)


# SSL 参数
# 非调试环境下由 nginx 等组件负责 SSL, 强制关闭 Node.js 的 SSL 支持
sslEnabled = !(argv['disable-ssl'] or !isDebug)
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
app.locals.DEBUG_LIVERELOAD = isDebug
gitRev.short (short) ->
  app.locals.VER_GIT = short


# 基本安全设置
app.use helmet.xframe 'deny'
app.use helmet.hsts 31536000, true  # 31536000s = 365d
app.disable 'x-powered-by'


# 中间件
app.use morgan()
app.use '/static', express.static('static') if isDebug
app.use connectSlashes(false)  # 标准化 URL, 去掉末尾的 /


# 干掉 oldIE
isOldIE = (uaObj) ->
  uaObj.ua.family == 'IE' and parseInt(uaObj.ua.major) < 11


app.use connectUAParser()
app.use (req, res, next) ->
  if isOldIE req.useragent then res.render 'misc/no-ie' else next()


# SEO -- 对爬虫生成 HTML 快照
isSpider = (uaObj) ->
  uaObj.device.family == 'Spider'

fullUrlFromRequest = (req) ->
  # XXX 这里最好应该像落花一样, 用配置明确指定自己的部署位置,
  # 不过先拿这个凑合一下
  https = req.protocol == 'https'
  isPortStandard = https and port == 443 or port == 80
  portFrag = if isPortStandard then '' else ':' + port

  req.protocol + '://' + req.host + portFrag + req.originalUrl

phantomCallbackFactory = (req, res) ->
  (err, ph) ->
    ph.createPage (err, page) ->
      fullUrl = fullUrlFromRequest req
      # console.log fullUrl
      page.open fullUrl, (status) ->
        page.evaluate(
          (() ->
            # NOTE: 这个函数会执行在页面上下文...
            document.getElementsByTagName('html')[0].innerHTML
          ), ((err, result) ->
            # innerHTML 的输出显然没有 doctype 和 html 标签自己...
            # hack: 自己拼上一个
            # 而且因为 #appmount 是附着在 html 元素上的, 所以得到的 HTML 快照
            # 在浏览器里不会初始化 AngularJS... 非常不错
            res.send '<!DOCTYPE html><html lang="cmn">' + result + '</html>'
            ph.exit()
          ))

generateHTMLSnapshot = (req, res) ->
  # TODO: 缓存生成的快照!
  phantom.create phantomCallbackFactory(req, res),
    parameters:
      # 因为是 self-signed SSL 证书, 这个选项很有必要, 否则会抓回空页面
      'ignore-ssl-errors': 'yes'


# 视图
entryView = (req, res) ->
  # SEO
  if isSnapshotsEnabled and isSpider req.useragent
    generateHTMLSnapshot req, res
  else
    res.render 'skel'


# 单页应用 (SPA) 部分
# 这一部分需要和前端代码保持一致
app.get '/', entryView
app.get '/admin', entryView
app.get '/admin/vtp/:vtpid', entryView
app.get '/admin/vtp/:vtpid/vtag', entryView
app.get '/admin/vtp/:vtpid/vtag/creat', entryView
app.get '/login', entryView
app.get '/logout', entryView
app.get '/register', entryView
app.get /^\/verifymail\/([0-9A-Za-z_-]{32})$/, entryView
app.get '/p/:vtpid', entryView
app.get '/p/:vtpid/t/:vtagid', entryView
app.get '/p/:vtpid/t/:vtagid/a/:vthid', entryView
app.get '/p/:vtpid/t/:vtagid/post', entryView


# Sentry
# NOTE: 必须出现在所有视图之后
sentryEnabled = process.env.SENTRY_DSN?
if sentryEnabled
  app.use raven.middleware.express new raven.Client()


# 日志辅助
onOff = (cond, onVal='on', offVal='off') ->
  if cond then onVal else offVal


# Fire up JNRain!
server = if sslEnabled then https.createServer sslOptions, app else app
server.listen port, hostName, () ->
  console.log   '  Serving over SSL: ' + onOff(sslEnabled)
  if sslEnabled
    console.log '   SSL private key: ' + keyFile
    console.log '   SSL certificate: ' + certFile + '\n'

  console.log   '    Deploy channel: ' + deployChannelName
  console.log   '    Debug settings: ' + onOff(isDebug)
  console.log   '      Bind address: ' + hostName
  console.log   '     SEO snapshots: ' + onOff(isSnapshotsEnabled)
  console.log   'Sentry integration: ' + onOff(sentryEnabled)
  console.log   'Listening on port ' + port + '.'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
