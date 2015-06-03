require 'net/http'
require 'json'
require 'openssl'

module XcodeServer
  class Server
    module Networking

      def get(endpoint)
        http.request(Net::HTTP::Get.new(path_to(endpoint)))
      end

      def post(endpoint, params)
        puts params.to_json
        req = Net::HTTP::Post.new(path_to(endpoint))
        req['Content-Type'] = 'application/json'
        http.request(req, params.to_json)
      end

      def get_json(endpoint)
        JSON.load(get(endpoint).body)
      end

      def delete(endpoint)
        http.request(Net::HTTP::Delete.new(path_to(endpoint)))
      end

      private

      def path_to(endpoint)
        "/xcode/api/#{endpoint}"
      end

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
