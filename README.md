# Ruby on Rails Tutorial: sample application

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
