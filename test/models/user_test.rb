# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    alice = users(:alice)
    bob = users(:bob)
    assert_equal 'Alice', alice.name_or_email
    assert_equal 'bobob@example.com', bob.name_or_email
  end
end
