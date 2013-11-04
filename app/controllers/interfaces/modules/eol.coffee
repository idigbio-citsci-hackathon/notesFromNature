Controller = require 'zooniverse/controllers/base-controller'

Eol = require 'lib/eol'
Modal = require 'lib/modal'

class EolModule extends Controller
  className: 'eol-widget'
  template: require 'views/widgets/eol'

  attachPoint: 'body'
  id: 'eol-widget'

  data: null

  events:
    'click img': 'onClickImage'

  constructor: ->
    super
    @el.attr 'id', @id
    @el.appendTo @attachPoint

  query: (species) =>
    Eol.getSpeciesImages species, ({ @data }) =>
      @renderTemplate()
        
  onClickImage: ({ currentTarget }) ->
    new Modal $(currentTarget).data('standard')

module.exports = EolModule
