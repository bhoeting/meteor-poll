Meteor.publish 'Poll', ->
  Polls.find({})

Meteor.publish 'Options', ->
  Options.find {}

Meteor.startup ->
  Polls.remove({})
  Options.remove({})

  valuePollId = Random.id()
  valuePoll = {
    '_id': valuePollId,
    'title': 'WHY DID YOU CHOOSE TO PURSUE A COLLEGE EDUCATION?',
    'text': 'Many believe the value of a college education is in how well rounded the student becomes, how much they learn, and how critically they start thinking. Others believe the value is in career prospects and increased income. The latter, as you might expect, is held by college students, while the former is typically preached by universities. In fact, 87.9% of college students interviewed in a study said they were attending "to be able to get a better job.'
    'ip': '134.53.244.142'
  }
  valueOptions = [{
    '_id': Random.id(),
    'text': 'To increase broad knowledge and critical thinking skills',
    'votes': 0,
    'pollId': valuePoll._id,
    'ips': []
  }, {
    '_id': Random.id(),
    'text': 'To have better career prospects',
    'votes': 0,
    'pollId': valuePollId
    'ips': []
  }]

  pricePollId = Random.id()
  pricePoll = {
    '_id': pricePollId,
    'title': 'what should this extra money we\'re paying be funding?',
    'text': 'Miami tution was $1,310/semester in 1980.  Now it\'s $13,533/semester.  That\'s an <i>inflation adjusted</i> increase of <b>$9,769.36 per semester</b>, or <b>$78,154.88 for all four years</b>.'
    'ip': '134.53.244.142'
  }
  priceOptions = [{
    '_id': Random.id(),
    'text': 'Better facilities, dorms, and infastructure',
    'votes': 0,
    'pollId': pricePollId
    'ips': []
  }, {
    '_id': Random.id(),
    'text': 'An improved curriculum that better prepares students for their professional careers',
    'votes': 0,
    'pollId': pricePollId
    'ips': []
  }, {
    '_id': Random.id(),
    'text': 'More administrators to facilitate campus events, organizations, and operations',
    'votes': 0,
    'pollId': pricePollId
    'ips': []
  }, {
    '_id': Random.id(),
    'text': 'A better class registration system',
    'votes': 0,
    'pollId': pricePollId
    'ips': []
  }]

  Meteor.call 'createPoll', valuePoll
  for option in valueOptions
    Meteor.call 'createOption', option

  Meteor.call 'createPoll', pricePoll
  for option in priceOptions
    Meteor.call 'createOption', option

  Meteor.methods
    clear: ->
      Polls.remove({})
      Options.remove({})
