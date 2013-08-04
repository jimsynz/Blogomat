App.User = Ep.Model.extend
  posts:    Ep.hasMany('post')

  name:     Ep.attr('string')
  email:    Ep.attr('string')
  username: Ep.attr('string')

  password: null
  isAuthenticated: false

  authenticated: ->
    @set('password', null)
    @set('isAuthenticated', true)
