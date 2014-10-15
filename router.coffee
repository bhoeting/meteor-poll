Router.map ->
  @route 'index',
    path: '/'
    template: 'index'

  @route 'pollShow',
    path: '/:_id',
    data: ->
      Polls.findOne(@.params._id)
    onRun: ->
      Session.set 'pollId', @params._id
    template: 'pollShow'

