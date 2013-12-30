require File.expand_path('../../test_helper', __FILE__)

class CallbacksTest < Test::Unit::TestCase
  module MyExtension
    mattr_accessor :history
    self.history ||= []

    def my_callback(model)
      self.history << :called_after
    end
  end

  def setup
    Globalize.extend(MyExtension)
    Globalize.callbacks << :my_callback
  end

  def teardown
    Globalize.callbacks = []
  end

  test 'translates callbacks' do
    class MyPost < ActiveRecord::Base
      self.table_name = :posts
      translates :title
    end
    assert_equal [:called_after], Globalize.history
  end
end
