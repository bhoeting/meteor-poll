@Votes = new Meteor.Collection 'votes'

###*
* Count the number of votes
* from a certain IP for
* a specific poll
###
@countVotesByIP = (pollId) ->
  Votes.find('pollId': pollId, 'ip': headers.getClientIP()).count()

###*
* Check if an option has been
* voted for by the current IP
###
@hasVotedForOption = (optionId) ->
  Votes.find('optionId': optionId, 'ip': headers.getClientIP()).count() > 0

###*
* Check if the poll has been
* voted on by the current IP
###
@hasVotedInPoll = (pollId) ->
  Votes.find('pollId': pollId, 'ip': headers.getClientIP()).count() > 0

Meteor.methods
  'removeVoteFromPoll': (id) ->
    optionId = (Votes.findOne 'pollId': id, 'ip': @connection.clientAddress).optionId
    Votes.remove Votes.findOne 'pollId': id, 'ip': @connection.clientAddress
    Options.update optionId, $inc: 'votes': -1

