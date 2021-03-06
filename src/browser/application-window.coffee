BrowserWindow = require 'browser-window'
app = require 'app'

module.exports =
class ApplicationWindow
  window: null

  constructor: (path, options) ->
    @window = new BrowserWindow(options)
    @window.loadUrl(path)
    # @menu = Menu.buildFromTemplate(require("./menu-#{process.platform}")(app, @window))
    # Menu.setApplicationMenu(@menu)

  on: (args...) ->
    @window.on(args...)
