# Subscriptions
pollSubHanlder = Meteor.subscribe 'Poll'
optionSubHandler = Meteor.subscribe 'Options'

# Create poll
Template.createPoll.events =
  'click #btn-create': (event, t) ->
    
    pollId = createPoll
      'ip': headers.getClientIP()
      'title': t.find('#input-title').value

    $('.input-option').each (index) ->
      if @value
        createOption 'text': @value, 'votes': 10, 'pollId': pollId
      if index != 0 then $(@).remove() else @value = ''

    Router.go 'pollShow', '_id': pollId

Template.createPoll.rendered = ->
  $(document).on('keyup', '.input-option', (e) ->
    if e.which is 13
      $('.input-option:last').clone().val('')
        .insertAfter $ '.input-option:last'
          .focus())

# List poll
Template.listPolls.polls = ->
  Polls.find()

# Poll show
Template.pollShow.events =
  'click #btn-remove-vote': (e, t) ->
    Meteor.call 'removeVoteFromPoll', @_id
    $('.btn-option').removeAttr 'disabled'

  'click #btn-add-option': (e, t) ->
    if @ip is headers.getClientIP()
      option = prompt('Add option:')
      if option
        createOption 'text': option, 'votes': 0, pollId: @_id

Template.pollShow.options = ->
  Options.find 'pollId': @_id

Template.pollShow.admin = ->
  @ip is headers.getClientIP()

Template.pollShow.hasVotedInPoll = ->
  hasVotedInPoll @_id

# Template.pollShow.dataReady = ->
#   if optionSubHandler.ready() and pollSubHanlder.ready()
#     Session.set 'pollId', @_id
#     console.log 'ready'

# Template.chart.rendered = ->
#   @drawChart Session.get 'pollId'

# Option show
Template.optionShow.events =
  'click .btn-option': (e, t) ->
    $('.btn-option').attr 'disabled', true
    if not hasVotedInPoll @pollId
      Meteor.call 'voteForOption', @_id, @pollId, headers.getClientIP()

  'contextmenu .option': (e, t) ->
    e.preventDefault()
    if confirm 'Do you want to delete this option'
      Meteor.call 'removeOption', @_id

  'click .option': (e, t) ->
    option = prompt('Edit option:')
    if option
      Meteor.call 'updateOptionText', @_id, headers.getClientIP(), option

Template.optionShow.hasVotedForOption = ->
  if hasVotedForOption @_id then 'true' else null

Template.optionShow.hasVotedInPoll = ->
  if hasVotedInPoll @pollId then 'true' else null
