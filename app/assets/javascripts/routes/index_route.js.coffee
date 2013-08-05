App.IndexRoute = Em.Route.extend
  model: ->
    @session.find('post', {})
