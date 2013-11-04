Controller = require 'zooniverse/controllers/base-controller'
Archive = require 'models/Archive'
Subject = require 'zooniverse/models/subject'
User = require 'zooniverse/models/user'

EolModule = require 'controllers/interfaces/modules/eol'
ImagePresenter = require 'controllers/interfaces/modules/image-presenter'

class Interface extends Controller
  className: 'interface'
  archive: null
  
  constructor: ->
    super

    # Spine.bind 'finishedTranscription', @saveClassification
    # Spine.bind 'skipTranscription', @skipClassification

    Subject.on 'select', @nextSubject

    # @eol = new EolModule({ attachPoint: @el }) if 'eol' in @modules
    @imagePresenter = new ImagePresenter
      attachPoint: @el

    @el.appendTo 'body'
    Subject.next()

  nextSubject: (subject) =>
    @imagePresenter.present Subject.current.location.standard

  startWorkflow: (@archive) =>


    # go = =>
    #   window.GOD = new nfn.ui.view.GOD
    #     model: new nfn.ui.model.GOD()

    #   transcriberModel = new nfn.ui.model[@widgetName]()
    #   @transcriber = new nfn.ui.view[@widgetName]
    #     model: transcriberModel
    #     Spine: Spine
    #     user: User.current
    #     archive: @archive

    #   $(".btn.close").attr("href", "#/archives/#{@archive.slug()}")

    #   Subject.next()
    #   window.transcriber = @transcriber

    # @delay go, 200

  saveClassification: (data) =>
    @classification.annotate({step: annotation.stepTitle, value: annotation.value}) for annotation in data.toJSON()

    # Sigh
    # done = =>
    #   unless User.current then return
    #   badges = User.current.badges
    #   userFetch = User.fetch()

    #   userFetch.done =>
    #     User.current.badges = badges
    #     @archive.checkBadges()
      
    @classification.send done
    Subject.next()

  skipClassification: =>
    @classification.annotate({skip: true})
    @classification.send()
    Subject.next()

  cleanup: =>
    @el.remove()

module.exports = Interface
