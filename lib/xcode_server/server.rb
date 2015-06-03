require 'xcode_server/server/networking'

module XcodeServer
  class Server
    include Networking

    attr_reader :scheme
    attr_reader :host

    def initialize(host, scheme = 'https')
      @host = host
      @scheme = scheme
    end

    def bots
      get_json('bots')['results'].map { |result| Bot.new(self, result) }
    end

    def destroy_bot(id, rev = nil)
      rev ||= get_json("bots/#{id}")['_rev']
      delete("bots/#{id}/#{rev}").code.to_i == 204
    end
  end
end
