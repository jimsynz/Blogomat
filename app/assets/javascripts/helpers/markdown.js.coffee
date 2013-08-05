Em.Handlebars.helper 'markdown', (value)->
  marked(value).htmlSafe()
