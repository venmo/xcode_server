require 'net/http'
require 'json'

module XcodeServer
  class Server
    module Networking

      def get(path)
        path = "/xcode/api/#{path}"
        http.request(Net::HTTP::Get.new(path))
      end

      def get_json(path)
        JSON.load(get(path).body)
      end

      def delete(path)
        path = "/xcode/api/#{path}"
        http.request(Net::HTTP::Delete.new(path))
      end

      private

      def http
        @_http ||= begin
          http = Net::HTTP.new(host, 443)
          http.use_ssl = true

          # By default, Xcode Server uses a self-signed certificate
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          http
        end
      end
    end
  end
end
