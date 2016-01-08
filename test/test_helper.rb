ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
    # order.
    fixtures :all
    include ApplicationHelper

    # Returns true if a test user is logged in.
    def logged_in?
      !session[:user_id].nil?
    end

    # Logs in a test user.
    def log_in_as(user, options = {})
      if integration_test?
        password    = options[:password] || 'password'
        remember_me = options[:remember_me] || '1'
        post login_path, session: { email:       user.email,
                                    password:    password,
                                    remember_me: remember_me }
      else
        session[:user_id] = user.id
      end
    end

    private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

    # assert that a flash message shows up in unit tests
    def assert_flash_unit(options)
      type = options[:type]
      expected = options[:expected]

      if expected.nil?
        assert flash[type] && flash[type] != '',
               "Should see a #{type} flash"
      else
        if expected
          assert_equal expected, flash[type],
                       "Should see a #{type} flash with '#{expected}'"
        else
          assert_not flash[type], "Should not see a #{type} flash"
        end
      end
    end

    # assert that a flash message shows up in integration tests
    def assert_flash_integration(options)
      type = options[:type]
      expected = options[:expected]

      selector = '.alert'
      selector += "-#{type}" if type
      message_object = type ? "#{type} flash" : 'flash'

      if expected.nil?
        message = "Should see a #{message_object}"
        assert_select selector, true, message
      else
        # rubocop:disable Style/MultilineTernaryOperator
        message = expected ?
          "Should see a #{message_object}, expecting: <#{expected}>" :
          "Should not see a #{message_object}"
        # rubocop:enable Style/MultilineTernaryOperator

        assert_select selector, expected, message
      end
    end

    # assert that a flash message shows up
    def assert_flash(options)
      options ||= { expected: false }

      if integration_test?
        assert_flash_integration options if options
      else
        assert_flash_unit options
      end
    end

    # assert that some input fields are highlighted
    def assert_highlights(highlights)
      if highlights == false
        assert_select 'field_with_errors', false,
                      'No fields should be highlighted'
      else
        highlights.each do |selector|
          assert_select ".field_with_errors #{selector}", 1,
                        "$('#{selector}') should be highlighted"
        end
      end
    end

    # assert that some error explanations exist
    def assert_explanations(explanations)
      if explanations == false
        assert_select '#error_explanation', false,
                      'Should not see any explanations'
      else
        explanations.each do |explanation|
          assert_select '#error_explanation li', explanation,
                        "Should see an explanation saying '#{explanation}'"
        end
      end
    end

    # abstract wrapper for flash, highlights, explanations assertions
    # rubocop:disable Style/GuardClause
    def assert_error_messages(options)
      assert_highlights(options[:highlights]) unless options[:highlights].nil?

      unless options[:flash].nil?
        assert_flash(type: 'danger', expected: options[:flash])
      end

      unless options[:explanations].nil?
        assert_explanations(options[:explanations])
      end
    end
    # rubocop:enable Style/GuardClause

    # assert that no error messages are rendered
    def assert_no_error_messages
      assert_highlights(false)
      assert_flash(type: 'danger', expected: false)
      assert_explanations(false)
    end

    # helper to extract a token from an email object
    def get_token_from_email(message)
      token_regex = %r/\/([a-zA-Z0-9\-_]{22})\//

      text_body = message.text_part.body.raw_source

      matches = token_regex.match(text_body)
      matches.captures[0]
    end

    ## ** assertions to check for specific scenarios ** ##
    def assert_permission_denied(template = 'static_pages/home')
      assert_response :unauthorized,
                      'Should get a 401 UNAUTHORIZED status header'
      assert_template template, "Should see '#{template}' rendered"
      assert_flash type: :danger,
                   expected: 'Sorry, you don\'t have permission to do that'
    end

    def assert_401_not_logged_in
      assert_response :unauthorized, 'Should get a 401 unauthorized error'
      assert_template 'sessions/new',
                      'Should be redirected to login when not logged in'
      assert_error_messages(flash: 'Please log in first')
    end

    ## ** assertions to check for partials ** ##
    def assert_rendered_user_info(user)
      # assert_template 'shared/_user_info', 'Should see user info'
      assert_select 'h1', { text: user.name },
                    'User\'s name should appear in a header'
      assert_select 'img.gravatar', true,
                    'User\'s gravatar should appear'
      assert_select '.microposts-count', user.feed.count.to_s,
                    'Should see the user\'s micropost count badge'
    end

    def assert_rendered_micropost_form
      assert_template 'shared/_micropost_form',
                      'Micropost form partial should be rendered'
      assert_select 'textarea#micropost_content', true,
                    'Should see the micropost text box'
      assert_select 'input.btn.btn-primary[value=?]', 'Post', true,
                    'Should see the post button'
    end

    def assert_rendered_feed
      assert_template 'shared/_feed', 'Should see the microposts feed'
    end
  end
end
