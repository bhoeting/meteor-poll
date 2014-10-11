Meteor.startup ->
  Meteor.methods
    clear: ->
      Votes.remove({})
      Polls.remove({})
      Options.remove({})