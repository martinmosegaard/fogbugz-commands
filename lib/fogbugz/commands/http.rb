require 'json'
require 'net/http'
require 'uri'

module Fogbugz
  module Commands
    # HTTP requests.
    class Http
      attr_accessor :uri
      attr_accessor :http

      # Constructor.
      # @param server FogBugz server.
      def initialize(server)
        uri_string = "https://#{server}/f/api/0/jsonapi"
        @uri = URI.parse(uri_string)
        @http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
      end

      # Make a FogBugz JSON request.
      # @param body Request body.
      # @return The data element from the JSON response.
      def request(body)
        header = {}
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = body.to_json

        response = http.request(request)
        json = JSON.parse(response.body)

        handle_errors_and_warnings(json)
        json['data']
      end

      private

      def handle_errors_and_warnings(json)
        unless json['warnings'].empty?
          warnings = json['warnings'].map { |w| w['message'] }.join('\n')
          puts "Warnings:\n#{warnings}"
        end

        abort json['errors'].map { |e| e['message'] }.join('\n') unless json['errors'].empty?
      end
    end
  end
end
