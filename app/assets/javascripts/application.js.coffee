#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router

this.App = Ember.Application.create
  ready: ->
    App.set('sessionToken', App.ApiToken.acquire())
