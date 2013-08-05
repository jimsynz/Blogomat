Em.Handlebars.helper 'fromNow', (value)->
  m = moment(value)
  "<span title=\"#{m.format('LLLL')}\">#{m.fromNow()}</span>".htmlSafe()

Em.Handlebars.helper 'calendar', (value)->
  m = moment(value)
  "<span title=\"#{m.format('LLLL')}\">#{m.calendar()}</span>".htmlSafe()
