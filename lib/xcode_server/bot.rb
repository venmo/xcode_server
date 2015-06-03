module XcodeServer
  class Bot
    attr_reader :id, :tinyID, :name

    def initialize(server, json)
      @server = server
      @id = json['_id']
      @tinyID = json['tinyID']
      @name = json['name']
    end

    def url
      "#{@server.scheme}://#{@server.host}/xcode/bots/latest/#{tinyID}"
    end
  end
end
