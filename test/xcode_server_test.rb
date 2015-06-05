require 'test_helper'

class XcodeServerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::XcodeServer::VERSION
  end

  def test_initialize_with_host
    server = XcodeServer.new('10.0.1.2')
    assert_equal '10.0.1.2', server.host
  end

  def test_initialize_with_default_host
    XcodeServer.default_host = '10.0.1.8'
    server = XcodeServer.new
    assert_equal '10.0.1.8', server.host
  end
end
