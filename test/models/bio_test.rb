require 'test_helper'

class BioTest < ActiveSupport::TestCase
  test 'should return formatted name' do
    assert 'Edward A Adams', bios(:one).formatted_name
  end
end
