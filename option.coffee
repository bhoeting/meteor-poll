@Options = new Meteor.Collection 'options'

@createOption = (options) ->
  id = Random.id()
  Meteor.call 'createOption', _.extend({_id: id}, options)
  return id

Meteor.methods
  'createOption': (options) ->
    Options.insert
      '_id': options._id
      'text': options.text
      'votes': options.votes
      'pollId': options.pollId

  'updateOptionText': (optionId, ip, text) ->
    pollId = Options.findOne(optionId, fields: 'pollId': 1).pollId
    if Polls.findOne(pollId, fields: 'ip': 1).ip is ip
      Options.update optionId, $set: 'text': text

  'removeOption': (optionId) ->
    Meteor.call 'removeAllVotesFromOption', optionId
    Options.remove optionId

  'voteForOption': (optionId, pollId) ->
    if pollId is undefined
      pollId = Options.findOne(optionId, fields: pollId: 1).pollId
    Options.update optionId, $inc: 'votes': 1
    Votes.insert
      'ip': @connection.clientAddress
      'optionId': optionId,
      'pollId': pollId

  'removeVoteFromOption': (optionId) ->
    Options.update optionId, $inc: 'votes': -1
    Votes.remove
      'optionId': optionId,
      'ip': @.connection.clientAddress

  'removeAllVotesFromOption': (optionId) ->
    Options.update optionId, $set: 'votes': 0
    Votes.remove 'optionId': optionId
