App.Post = Ep.Model.extend
  user:        Ep.belongsTo('user')

  subject:     Ep.attr('string')
  body:        Ep.attr('string')
  publishedAt: Ep.attr('date')
