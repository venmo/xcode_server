require 'xcode_server/version'
require 'xcode_server/server'
require 'xcode_server/bot'

module XcodeServer
  def self.new(host=@default_host)
    Server.new(host)
  end

  def self.default_host=(host)
    @default_host = host
  end

  def self.default_host
    @default_host
  end
end
