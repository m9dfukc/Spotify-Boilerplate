exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  files:
    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'js/app.js': /^app/
        'js/vendor/spotify.js': /^vendor\/scripts\/spotify/
        'js/vendor/common.js': /^vendor\/scripts\/common/
      before: [
        'vendor/scripts/common/jquery-1.8.1.min.js',
        'vendor/scripts/common/mustache.js',
        'vendor/scripts/common/sammy-0.7.1.js',
        'vendor/scripts/common/sammy.mustache.js'
      ]
    stylesheets:
      defaultExtension: 'styl'
      joinTo: 'css/main.css'
      order:
        before: ['vendor/styles/helpers.css']