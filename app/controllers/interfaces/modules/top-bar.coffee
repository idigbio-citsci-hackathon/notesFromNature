Controller = require 'zooniverse/controllers/base-controller'

class TopBarModule extends Controller
  className: 'top-bar-widget'
  template: require 'views/widgets/top-bar'

  attachPoint: 'body'
  id: 'top-bar-widget'

  events:
    'click .exit': 'onClickExit'

  constructor: ->
    super
    @el.attr 'id', @id
    @el.appendTo @attachPoint   

module.exports = TopBarModule
