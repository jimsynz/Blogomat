# This model represents a limited use API token, assigned by the server.
# The reasons this isn't EPF-backed is because it only has the create
# (POST) action, and it would be overkill to use an ORM.

App.ApiSessionToken = Em.Object.extend
  token: null
  ttl:   0
  user:  null

  isAlive: (-> @get('ttl') > 0).property('ttl')

  hasToken: (->
    token = @get('token')
    if token && (typeof(token) == 'string') && (token.length > 0)
      true
    else
      false
  ).property('token')

  isValid: (->
    @get('hasToken') && @get('isAlive')
  ).property('hasToken', 'isAlive')

  needsRefresh: (->
    @get('ttl') <= 10
  ).property('ttl')

  init: ->
    @scheduleTtlDecrement()

  decrementTtl: ->
    @decrementProperty('ttl') if @get('isAlive')
    @scheduleTtlDecrement()

  scheduleTtlDecrement: ->
    Em.run.later(this, @decrementTtl, 1000)

  refresh: ->
    App.ApiSessionToken.acquire(@)

App.ApiSessionToken.reopenClass
  acquire: (token)->
    token     ||= App.ApiSessionToken.create()
    credentials = {}
    username    = token.get('user.username')
    password    = token.get('user.password')

    credentials.token = token.get('token') if token.get('hasToken')

    if username && password
      credentials.username = username
      credentials.password = password

    $.ajax
      dataType: 'json'
      data:     credentials
      url:      '/api/sessions'
      type:     'POST'

      success:  (data,status,xhr)->
        token.set('token', data.api_session_token.token)
        token.set('ttl', data.api_session_token.ttl)
        token.get('user').authenticated() if username && password

      error:    (xhr,status,error)->
        token.set('error', "#{status}: #{error}")

    token
