# Defines the matching rules for Guard.
guard :minitest, spring: true, all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch(%r{test/fixtures/*}) { 'test' }
  watch('config/routes.rb')    { integration_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    "test/models/#{matches[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    ["test/controllers/#{matches[1]}_controller_test.rb"] +
    integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch('app/views/layouts/application.html.erb') do
    integaration_tests
  end
  watch('app/helpers/sessions_helper.rb') do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end
  watch('app/helpers/acl_helper.rb') do
    integration_tests << 'test/helpers/acl_helper_test.rb' << controller_tests
  end
  watch('app/controllers/sessions_controller.rb') do
    ['test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb']
  end
  watch('app/controllers/email_verifications_controller.rb') do
    'test/integration/users_signup_test.rb'
  end
  watch(%r{app/views/users/*}) do
    resource_tests('users') +
    ['test/integration/microposts_interface_test.rb']
  end
  watch('app/controllers/password_resets_controller.rb') do
    'test/integration/users_reset_password_test.rb'
  end
end

# Returns the integration tests corresponding to the given resource.
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]
  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# Returns the controller tests corresponding to the given resource.
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

def controller_tests
  Dir["test/controllers/*_test.rb"]
end

# Returns all tests for the given resource.
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end

# general cucumber tests
cuke_flags = '--no-profile --color --format progress --strict --tags ~@skip --tags ~@not_implemented'
guard 'cucumber', cli: cuke_flags do
  # if a feature file changes, run it
  watch(%r{^features/(.+\.feature)$}) do |m|
    "features/#{m[1]}"
  end
  # if a steps file changes, run the matching integration features
  watch(%r{^features/step_definitions/(.*)_steps\.rb$}) do |matches|
    "features/integration/#{matches[1]}.feature"
  end
  # if a top-level steps file changes, run all integration tests for that feature
  watch(%r{^features/step_definitions/([a-zA-Z_]+)_steps\.rb$}) do |matches|
    "features/integration/#{matches[1]}"
  end
  # run all layout tests if layout.rb changes
  watch('features/step_definitions/layout.rb') do
    'features/layout'
  end

  # run smoke tests if common.rb or support files change
  watch('features/step_definitions/common.rb') do
    'features/smoke'
  end
  watch(%r{^features/support/.+$}) do
    ['features/tests.feature', 'features/smoke']
  end

  # meta tests
  watch('features/step_definitions/test_steps.rb') do
    'features/tests.feature'
  end
end
