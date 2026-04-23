# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    users = [users(:alice), users(:bob)]
    assert_equal 'Alice', users[0].name_or_email
    assert_equal 'bobob@example.com', users[1].name_or_email
  end
end
