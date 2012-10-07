sp        = getSpotifyApi(1)
models    = sp.require("sp://import/scripts/api/models")
views     = sp.require("sp://import/scripts/api/views")
ui        = sp.require("sp://import/scripts/ui")
player    = models.player
library   = models.library

class Loader
  @sections_loaded = []

  @loadCover = (uri, options, callback) ->
    css_size = if options and options.size then "sp-image-" + options.size else ""
    cover = if options and options.size then "sp-image-" + options.cover else false
    if uri
      if uri.indexOf("spotify:track") >= 0
        target = new models.Track.fromURI uri, ->
          playlistArt = new views.Player()
          playlistArt.context = target
          playlistArt.image = cover or target.data.cover
          playlistArt.node.className = "sp-player sp-player-paused " + css_size
          callback playlistArt.node, target  if callback
      if uri.indexOf("spotify:album") >= 0
        target = new models.Album.fromURI uri, ->
          playlistArt = new views.Player()
          playlistArt.context = target
          playlistArt.image = cover or target.data.cover
          playlistArt.node.className = "sp-player sp-player-paused " + css_size
          callback playlistArt.node, target  if callback
      if uri.indexOf("spotify:user") >= 0
        target = new models.Playlist.fromURI uri
        playlistArt = new views.Player()
        
        # playlistArt.track = target.get(0);
        playlistArt.context = target
        playlistArt.image = cover or target.data.cover
        playlistArt.node.className = "sp-player sp-player-paused " + css_size
        callback playlistArt.node, target  if callback
    else
      ""

  @loadCovers = (section) ->
    $(section + " .cover").each (i, item) ->
      Loader.loadCover $(item).attr("rel"),
        size: "medium"
      , (elm, target) ->
        $(item).html elm

  @loadSection = (ctxt, id, tplFile, dataFile, cb) ->
    unless Loader.sections_loaded[id]
      if dataFile
        ctxt.load(dataFile).then (data) ->
          ctxt.render tplFile, data, (rendered) ->
            $("<div/>",
              id: id
              class: "section"
              html: rendered
            ).appendTo "#content"

            # Spotify hooks
            Loader.loadCovers "#" + id
            # Mark as done
            Loader.sections_loaded[id] = true
            cb(data) if cb
      else
        ctxt.render tplFile, (rendered) ->
          $("<div/>",
            id: id
            class: "section"
            html: rendered
          ).appendTo "#content"
          
          # Spotify hooks
          Loader.loadCovers "#" + id
          # Mark as done
          Loader.sections_loaded[id] = true
          cb() if cb
    else
      $("#content #" + id).show()
      cb() if cb

module.exports.Loader = Loader