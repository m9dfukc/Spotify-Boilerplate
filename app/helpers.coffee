class Loader
  constructor: ->
    @sections_loaded = []

  loadCovers = (section) ->
    $(section + " .cover").each (i, item) ->
      loadCover $(item).attr("rel"),
        size: "medium"
      , (elm, target) ->
        $(item).html elm

  loadSection = (ctxt, id, tplFile, dataFile, cb) ->
    unless sections_loaded[id]
      if dataFile
        ctxt.load(dataFile).then (data) ->
          ctxt.render tplFile, data, (rendered) ->
            $("<div/>",
              id: id
              class: "section"
              html: rendered
            ).appendTo "#content"

            # Spotify hooks
            loadCovers "#" + id
            # Mark as done
            sections_loaded[id] = true
      else
        ctxt.render tplFile, (rendered) ->
          $("<div/>",
            id: id
            class: "section"
            html: rendered
          ).appendTo "#content"
          
          # Spotify hooks
          loadCovers "#" + id
          # Mark as done
          sections_loaded[id] = true
    else
      $("#content #" + id).show()

    cb() if cb

module.exports.Loader = Loader