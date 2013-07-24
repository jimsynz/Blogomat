#= require vendor

describe 'jQuery', ->
  it 'is the expected version', ->
    expect(jQuery.fn.jquery).toEqual('1.10.2')

describe 'Handlebars.js', ->
  it 'is the expected version', ->
    expect(Handlebars.VERSION).toEqual('1.0.0')

describe 'Ember.js', ->
  it 'is the expected version', ->
    expect(Ember.VERSION).toEqual('1.0.0-rc.6')

describe 'EPF', ->
  it 'is present', ->
    expect(Ep).toBeDefined()
