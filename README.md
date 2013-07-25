# Baseline

![Codeship build status](https://www.codeship.io/projects/4b5ecae0-951d-0130-0d7e-0e9cd879eb4e/status)

Baseline is an empty Rails + Ember app ready for BDD.
It is set up with continuous deployment in mind, and as such [master](https://github.com/jamesotron/Baseline)
is set up to do continuous integration and deployment using [Codeship](http://codeship.io/).

You can see the latest deployment at [http://baseline-rails.herokuapp.com](http://baseline-rails.herokuapp.com/).

## Using as the baseline of your app.

If you're starting from scratch (that's a big if) then you can add Baseline
as a remote repository and merge changes from Baseline as they're needed.

Add the Baseline remote:

    $ git remote add baseline https://github.com/jamesotron/Baseline.git
    $ git fetch baseline

Merge Baseline's master branch to your master:

    $ git merge baseline/master master

Change the app name to your app:

    $ bundle exec rake baseline:rename APP_NAME=operation_pristine_dumpling
    Renaming Baseline => OperationPristineDumpling
    modified config/application.rb
    modified config/environment.rb
    modified config/environments/development.rb
    modified config/environments/production.rb
    modified config/environments/test.rb
    modified config/initializers/secret_token.rb
    modified config/initializers/session_store.rb
    modified config/routes.rb
    modified spec/baseline_spec.rb

Any time there's updates to Baseline that you'd like to include in your app:

    $ git fetch baseline
    $ git merge baseline/master master

* If you're not starting from scratch then I'll leave dealing with the merge
  conflicts as an exercise for the reader.

## Testing

You should be able to do everything by just running `bundle exec guard` which
will start the appropriate test runners and trigger them upon change.

You can also run the entire suite by running `bundle exec rake suite`.
