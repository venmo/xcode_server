require 'xcode_server/version'
require 'xcode_server/server'
require 'xcode_server/bot'

module XcodeServer
  def self.new(host)
    Server.new(host)
  end
end
