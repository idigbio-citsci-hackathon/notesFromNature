{ Controller } = require 'zooniverse/controllers/base-controller'

class ZoomInterface extends Controller
  template: require 'views/transcription/interfaces/zoom'

  modules: []
  fields: null

  elements:
    '.subject-image': 'subjectContainer'

  constructor: (params = {}) ->
    super
    @[property] = value for property, value of params when property of @
    @el.append module.el for module in @modules 

  loadSubject: (subject) =>
    subjectImage = subject.location.large
    subjectImage ||= subject.location.standard

    img = new Img
    img.onload = =>
      @subjectContainer.append img

    img.src subjectImage

    @subjectContainer.panzoom()

module.exports = ZoomInterface
