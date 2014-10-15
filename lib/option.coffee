@Options = new Meteor.Collection 'options'

@createOption = (options) ->
  id = Random.id()
  Meteor.call 'createOption', _.extend({_id: id}, options)
  return id

@hasVotedForOption = (optionId, ip) ->
  query = Options.find '_id': optionId, 'ips': ip
  query.count() > 0

Meteor.methods
  'createOption': (options) ->
    Options.insert
      '_id': options._id
      'ips': options.ips
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

  'voteForOption': (optionId, pollId, ip) ->
    if pollId is undefined
      pollId = Options.findOne(optionId, fields: pollId: 1).pollId
    Options.update optionId, {$inc: {'votes': 1}, $push: {'ips': ip}}

  'removeVoteFromOption': (optionId) ->
    Options.update optionId, {$inc: {'votes': -1}, $pull: {'ips': ip}}

  'removeAllVotesFromOption': (optionId) ->
    Options.update optionId, $set: 'votes': 0, 'ips': []
