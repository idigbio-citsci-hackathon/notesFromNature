Archive = require 'models/Archive'
Institute = require 'models/Institute'
Subject = require 'zooniverse/models/subject'

# BugsTranscriptionController = require 'controllers/interfaces/bugs'
# SernacTranscriptionController = require 'controllers/interfaces/plants'
# Fungi = require 'controllers/interfaces/fungi'
Interface = require 'controllers/interfaces'
Birds = require 'controllers/interfaces/birds' # Legacy

# Fill in
definitions =
  'macrofungi': {}

class Transcribe extends Spine.Site
  className: 'TranscriptionController'

  active: (params) =>
    super
  
    # What archive are we looking at?
    @archive = Archive.findBySlug(params.id)
    unless @archive then return

    # Adjust page attributes for archive.
    $('body').addClass("transcribingScreen #{ @archive.slug() }")
    document.title = "Notes From Nature - #{ @archive.institute().name } - #{ @archive.name } - Transcribe"
    Subject.group = @archive.id

    # This is temporary. Probably.
    newInterface = ['calbug', 'sernec', 'macrofungi']
    if newInterface.indexOf @archive.slug() != -1
      @interface = new Interface
        definitions: definitions[newInterface]
        archive: @archive
    else
      @interface = new Birds()
      $(document).on 'keydown.nfn keypress.nfn', ({ which, target, preventDefault }) ->
        if which is 8 and not (target.tagName is 'INPUT')
          preventDefault()

  deactivate: =>
    super
    @interface?.cleanup()
    if @archive? then $('body').removeClass("transcribingScreen #{ @archive.slug() }")
    
    # $('.transcriber').remove()
    # Subject.destroyAll()
    # Spine.unbind 'finishedTranscription'
    # Spine.unbind 'skipTranscription'

    # Legacy, for now.
    $(document).off 'keydown.nfn keypress.nfn'

module.exports = Transcribe
