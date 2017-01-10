require 'json'
require 'net/http'
require 'thor'
require 'uri'

module Fogbugz
  module Commands
    # Command line interface.
    class Cli < Thor
      attr_accessor :server

      desc 'time_report', 'Get a time report'
      long_desc <<-EOH
      Get a time report for a particular case.
      EOH
      method_option :case, type: :numeric, required: true, desc: 'Case number'
      method_option :user, type: :string, required: true, desc: 'Username'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def time_report
        @server = options[:server]
        token = logon(options[:user])

        body = { cmd: 'listIntervals', token: token, ixPerson: 1, ixBug: options[:case] }
        response = request(body: body)
        puts JSON.pretty_generate(JSON.parse(response.body))
      end

      private

      def logon(user)
        pass = ask('Password:', echo: false)
        puts '' # because not echoing above

        body = { cmd: 'logon', email: user, password: pass }
        response = request(body: body)
        json = JSON.parse(response.body)

        abort json['errors'].map { |e| e['message'] }.join('\n') unless json['errors'].empty?
        json['data']['token']
      end

      # Make a JSON request.
      # @param body Request body.
      # @return The response.
      def request(body:)
        uri_string = "https://#{@server}/f/api/0/jsonapi"
        uri = URI.parse(uri_string)

        header = {}
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = body.to_json

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.request(request)
      end
    end
  end
end
