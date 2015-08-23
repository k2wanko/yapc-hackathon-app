ApplicationWindow = require './application-window'
app = require('app') # provided by electron

module.exports =
class Application
  window: null

  constructor: (options) ->
    global.application = this

    require('crash-reporter').start()

    app.on 'window-all-closed', -> app.quit()
    app.on 'ready', => @openWindow()
  openWindow: ->
    htmlURL = "file://#{__dirname}/../main-window/index.html"
    @window = new ApplicationWindow htmlURL,
      width: 1200,
      height: 800
