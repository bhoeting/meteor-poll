@Polls = new Meteor.Collection 'polls'

Polls.allow
  # No client inserts
  'insert': (title, ip, text) -> false

  # Only allow poll owner to update
  'update': (ip, poll, fields, modifier) ->
    ip is poll.ip

  # Only allow owner to remove
  'remove': (ip, poll) ->
    ip is poll.ip

@createPoll = (options) ->
  id = Random.id()
  Meteor.call 'createPoll', _.extend({_id: id}, options)
  return id

@hasVotedInPoll = (pollId, ip) ->
  query = Options.find 'pollId': pollId, 'ips': ip
  query.count() > 0

@optionHasVotedInPoll = (_id, pollId, ip) ->
  query = Options.find '_id': _id, 'pollId': pollId, 'ips': ip
  query.count() > 0

Meteor.methods
  'createPoll': (options) ->
    Polls.insert
      'ip': options.ip
      '_id': options._id
      'text': options.text
      'title': options.title

  'removeVoteFromPoll': (pollId, ip) ->
    Options.update {'pollId': pollId, 'ips': ip},
      $inc: {'votes': -1}, $pull: {'ips': ip}
