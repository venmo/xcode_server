require 'test_helper'

class ServerTest < Minitest::Test
  def test_initialize_with_host
    server = XcodeServer::Server.new('10.0.1.2')
    assert_equal '10.0.1.2', server.host
  end
end
