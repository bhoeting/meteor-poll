Meteor.publish 'Poll', ->
  Polls.find({})

Meteor.publish 'Options', ->
  Options.find {}

Meteor.startup ->
  Meteor.methods
    clear: ->
      Votes.remove({})
      Polls.remove({})
      Options.remove({})