require 'xcode_server/version'
require 'xcode_server/server'
require 'xcode_server/bot'

module XcodeServer
  def self.new(*args)
    Server.new(*args)
  end
end
