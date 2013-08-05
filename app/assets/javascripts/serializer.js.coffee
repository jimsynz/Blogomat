App.Serializer = Ep.JsonSerializer.extend
  keyForAttributeName: (type,name)->
    name.underscore()
