## Rails Base

This is Mike's rails base application. It includes a user authentication system
and extensive tests

## Requirements
* git
* Ruby
* Rails
* Bundler
* imagemaagick
* poltergeist

## Installation
* `git clone` this repository
* make install
* make migrate

## Running / Development
* `make server`

## Setting up a production server on Heroku
* provision a heroku app
* set up postgresql (TODO: more details)
* Add the SendGrid addon to heroku
* You need an AWS account, with an S3 bucket, and an AWS user with access to said bucket
* put the user's access key in the `S3_ACCESS_KEY` ENV variable
* put the user's secret key in the `S3_SECRET_KEY` ENV variable
* put the aws bucket's name in `S3_BUCKET` ENV variable
* put the aws bucket's region on the `S3_REGION` ENV variable

## Running tests
* `make test` to run the unit and functional tests
* `make integration-tests` to run integration tests
* `make smoke` to run smoke test suite
* `make test-all` to run all tests

This is the sample application for the
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

todo: add an 'assert\_permission\_denied' helper for tests
todo: Why not just get the @micropost and @feed\_items  in the  template?
todo: add messages to all `assert(_no)?_difference` calls
todo: implement soft-delete for users
todo: create a default admin user, and a workflow to replace it with a new admin user.  that workflow should ONLY be available if the default admin is present/active, and completing it should delete the default admin.
todo: redirect user to own profile page on login if email is not verified
todo: add a 'resend verification' link to profile pages.
todo: invalidate current password on password reset, and log user out elsewhere.
todo: allow admins to promote other users to admins
todo: force users to re-verify when changing email
todo: obfuscate user ids with a configurable, unique slug (with a database index)
todo: make all of the response codes correct (DELETE should not give 3xx, for instance)
