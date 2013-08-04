App.Adapter = Ep.RestAdapter.extend
  namespace: 'api'
  init: ->
    @_super()
    $.ajaxPrefilter (newOpts, oldOpts, xhr)->
      xhr.setRequestHeader('Authorization', App.get('sessionToken.token'))
