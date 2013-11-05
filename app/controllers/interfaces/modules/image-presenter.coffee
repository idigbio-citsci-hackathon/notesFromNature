Controller = require 'zooniverse/controllers/base-controller'

class ImagePresenter extends Controller
  template: require 'views/widgets/image-presenter'
  className: 'image-presenter'

  attachPoint: 'body'
  image: null
  id: 'image-presenter'

  elements:
    '.image-container': 'imageContainer'

  constructor: ->
    super

    @el.attr 'id', @id
    @el.appendTo @attachPoint

  present: (image) =>
    img = new Image
    img.onload = =>
      @imageContainer.append img
      @imageContainer.panzoom()
    img.src = image

module.exports = ImagePresenter
