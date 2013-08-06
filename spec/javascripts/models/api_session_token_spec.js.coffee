#= require test

run = Em.run

describe 'App.ApiSessionToken', ->
  token = null

  it 'should exist', ->
    expect(App.ApiSessionToken).toBeDefined()

  describe '#decrementTtl', ->
    beforeEach ->
      run ->
        token = App.ApiSessionToken.create(ttl: 10)

    it 'decrements the ttl', ->
      run -> token.decrementTtl()
      expect(token.get('ttl')).toEqual(9)

  describe '#isAlive', ->
    beforeEach ->
      token = App.ApiSessionToken.create()

    it 'is true when the TTL is greater than zero', ->
      run -> token.set('ttl', 10)
      expect(token.get('isAlive')).toEqual(true)

    it 'is false when the TTL is zero', ->
      run -> token.set('ttl', 0)
      expect(token.get('isAlive')).toEqual(false)

    it 'is false when the TTL is unset', ->
      expect(token.get('isAlive')).toEqual(false)

  describe '#hasToken', ->
    beforeEach ->
      run ->
        token = App.ApiSessionToken.create()

    describe 'when the token is set', ->
      beforeEach ->
        run -> token.set('token', 'a fake token')

      it 'is true', ->
        expect(token.get('hasToken')).toEqual(true)

    describe 'when the token is not set', ->
      it 'is false', ->
        expect(token.get('hasToken')).toEqual(false)


  describe '#isValid', ->
    beforeEach ->
      run ->
        token = App.ApiSessionToken.create()

    describe 'when the ttl is alive', ->
      beforeEach ->
        run -> token.set('ttl', 10)

      describe 'when the token is set', ->
        beforeEach ->
          run -> token.set('token', 'a fake token')

        it 'is true', ->
          expect(token.get('isValid')).toEqual(true)

      describe 'when the token is not set', ->
        it 'is false', ->
          expect(token.get('isValid')).toEqual(false)

    describe 'when the ttl is not set', ->
      describe 'when the token is set', ->
        beforeEach ->
          run -> token.set('token', 'a fake token')

        it 'is false', ->
          expect(token.get('isValid')).toEqual(false)

      describe 'when the token is not set', ->
        it 'is false', ->
          expect(token.get('isValid')).toEqual(false)

  describe '#needsRefresh', ->
    beforeEach ->
      run ->
        token = App.ApiSessionToken.create()

    describe 'when the ttl is greater than 10', ->
      beforeEach ->
        run -> token.set('ttl', 11)

      it 'is false', ->
        expect(token.get('needsRefresh')).toEqual(false)

    describe 'when the ttl is 10', ->
      beforeEach ->
        run -> token.set('ttl', 10)

      it 'is true', ->
        expect(token.get('needsRefresh')).toEqual(true)

    describe 'when the ttl is less than 10', ->
      beforeEach ->
        run -> token.set('ttl', 9)

      it 'is true', ->
        expect(token.get('needsRefresh')).toEqual(true)

  describe '#refresh', ->
    token = null

    beforeEach ->
      spyOn App.ApiSessionToken, 'acquire'
      run ->
        token = App.ApiSessionToken.create()
        token.refresh()

    it 'calls ApiSessionToken.acquire', ->
      expect(App.ApiSessionToken.acquire).toHaveBeenCalled()

    it 'passes itself as an argument', ->
      expect(App.ApiSessionToken.acquire.mostRecentCall.args[0]).toEqual(token)

  describe '.acquire', ->
    beforeEach ->
      spyOn $, 'ajax'

    describe 'AJAX request', ->
      token     = null
      old_token = null
      user      = null

      beforeEach ->
        user      = Em.Object.create
          username: null
          password: null
          authenticated: -> console.log "Authenticated"
        run ->
          old_token = App.ApiSessionToken.create(user: user, token: 'foo bar')
          token     = App.ApiSessionToken.acquire(old_token)

      it 'is sent', ->
        expect($.ajax).toHaveBeenCalled()

      it 'is sent as JSON', ->
        expect($.ajax.mostRecentCall.args[0].dataType).toEqual('json')

      it 'is sent to /api/sessions', ->
        expect($.ajax.mostRecentCall.args[0].url).toEqual('/api/sessions')

      it 'is sent as a POST', ->
        expect($.ajax.mostRecentCall.args[0].type).toEqual('POST')

      it 'sends the old token', ->
        expect($.ajax.mostRecentCall.args[0].data.token).toEqual('foo bar')

      describe 'when the old token has a user', ->
        describe 'with a username and password', ->
          beforeEach ->
            run ->
              user.set('username', 'test username')
              user.set('password', 'test password')
              token     = App.ApiSessionToken.acquire(old_token)

          it 'sends the username', ->
            expect($.ajax.mostRecentCall.args[0].data.username).toEqual('test username')

          it 'sends the password', ->
            expect($.ajax.mostRecentCall.args[0].data.password).toEqual('test password')

        describe 'without a username and password', ->
          it 'doesn\'t send the username', ->
            expect($.ajax.mostRecentCall.args[0].data.username).not.toBeDefined()

          it 'doesn\'t send the password', ->
            expect($.ajax.mostRecentCall.args[0].data.password).not.toBeDefined()

      describe 'on success', ->
        the_token  = 'abcdefg'
        the_ttl    = 30
        data       = { 'api_session_token': { 'token': the_token, 'ttl': the_ttl } }

        beforeEach ->
          run ->
            $.ajax.mostRecentCall.args[0].success(data, null, null)

        it 'sets the token', ->
          expect(token.get('token')).toEqual(the_token)

        it 'sets the ttl', ->
          expect(token.get('ttl')).toEqual(the_ttl)

        describe 'with a username and password', ->
          beforeEach ->
            run ->
              user.set('username', 'test username')
              user.set('password', 'test password')
              spyOn user, 'authenticated'
              token     = App.ApiSessionToken.acquire(old_token)
              $.ajax.mostRecentCall.args[0].success(data, null, null)

          it 'calls authenticated on the user', ->
            expect(user.authenticated).toHaveBeenCalled()

      describe 'on error', ->
        status = 'lawsOfPhysicsException'
        error  = 'I canne give \'er more power, Jim.'

        beforeEach ->
          run ->
            $.ajax.mostRecentCall.args[0].error(null, status, error)

        it 'sets the error', ->
          expect(token.get('error')).toEqual('lawsOfPhysicsException: I canne give \'er more power, Jim.')

    it 'returns an ApiSessionToken', ->
      expect(App.ApiSessionToken.acquire().constructor).toEqual(App.ApiSessionToken)
