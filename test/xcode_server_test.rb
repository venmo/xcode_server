require 'test_helper'

class XcodeServerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::XcodeServer::VERSION
  end
end
