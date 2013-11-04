ArchivesList = require 'controllers/archives/list'
ArchivesItem = require 'controllers/archives/item'
Transcribe = require 'controllers/transcribe'

class ArchivesStack extends Spine.Stack

  controllers:
    archivesList: ArchivesList
    archivesItem: ArchivesItem
    transcribe: Transcribe

  routes:
    '/archives': 'archivesList'
    '/archives/:id': 'archivesItem'
    '/archives/:id/transcribe': 'transcribe'

  default: 'archivesList'

module.exports = ArchivesStack