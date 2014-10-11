@Polls = new Meteor.Collection 'polls'

Polls.allow
  # No client inserts
  'insert': (title, ip) -> false

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

Meteor.methods
  'createPoll': (options) ->
    Polls.insert
      'ip': options.ip
      '_id': options._id
      'title': options.title