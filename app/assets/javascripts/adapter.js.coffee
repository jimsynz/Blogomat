App.Adapter = Ep.RestAdapter.extend
  namespace: 'api'
  init: ->
    @_super()
    $.ajaxPrefilter (newOpts, oldOpts, xhr)->
      xhr.setRequestHeader('Authorization', App.get('sessionToken.token'))

  _typeToString: (type)->
    if (typeof(type) == 'string')
      chunks = type.split('.')
      chunks[chunks.length-1].underscore()
    else
      @_super(type)
