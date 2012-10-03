Loader = require("./helpers").Loader

class App
  sp            = getSpotifyApi(1)
  models        = sp.require("sp://import/scripts/api/models")
  views         = sp.require("sp://import/scripts/api/views")
  ui            = sp.require("sp://import/scripts/ui")
  player        = models.player
  library       = models.library
  application   = models.application
  playerImage   = new views.Player()
  appname       = document.location.href.replace("sp://", "").split("/")[0]
  appBaseUrl    = "spotify:app:" + appname + ":"
  @loader       = new Loader()
  @sammy        = $.sammy "#content", App.routing

  constructor: ->
    application.observe models.EVENT.ARGUMENTSCHANGED, @tabChanged
    models.session.observe models.EVENT.STATECHANGED, @stateChanged


  @routing: ->
    @use "Mustache", "html"
    @get "home", (ctxt) ->
      App.loader.loadSection ctxt, "news", "/templates/home.html", "dummy_data/example_data.json", ->
        console.log "section home"

    @get "exampletab", (ctxt) ->
      App.loader.loadSection ctxt, "exampletab", "/templates/example_page.html", null, ->
        console.log "section exampletab"

    @get "exampletab/:deeplink", (ctxt) ->
      App.loader.loadSection ctxt, "exampletab_deeplink", "/templates/example_deeplink.html", null, ->
        console.log "section exampletab/:deeplink"

    @around hideAll


  stateChanged: =>
    switch models.session.state
      when 2
        offlineMode()
      else
        onlineMode()


  tabChanged: =>
    return  if models.session.state is 2
    args = ""

    for arg in models.application.arguments
      do (arg) ->
        args += "/" + arg

    console.log "Tabs changed", models.application.arguments, "Running route", args
    App.sammy.runRoute "get", args


  offlineMode = ->
    $("#content").fadeOut()
    $("#offline").fadeIn()


  onlineMode = ->
    $("#content").fadeIn()
    $("#offline").fadeOut()


  hideAll = (cb) ->
    $("#content .section").hide()
    cb()

module.exports = App