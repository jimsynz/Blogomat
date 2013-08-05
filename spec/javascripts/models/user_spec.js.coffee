#= require test

run = Em.run

describe 'App.User', ->
  it 'exists', ->
    expect(App.User).toBeDefined()

  describe '#authenticated', ->
    user = null

    beforeEach ->
      run ->
        user = App.User.create()
        user.set('password', 'fake password')
        expect(user.get('password')).toEqual('fake password')
        expect(user.get('isAuthenticated')).toEqual(false)
        user.authenticated()

    it 'removes the password property', ->
      expect(user.get('password')).toEqual(null)

    it 'sets the isAuthenticated property', ->
      expect(user.get('isAuthenticated')).toEqual(true)
