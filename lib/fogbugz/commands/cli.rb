require 'json'
require 'net/http'
require 'thor'
require 'uri'

module Fogbugz
  module Commands
    class CLI < Thor
      desc 'logon', 'Logon to a FogBugz server'
      long_desc <<-EOH
      Logon to a FogBugz server with username and password.
      This command returns a token for further commands.
      EOH
      method_option :user, type: :string, required: true, desc: 'Username'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def logon
        pass = ask('Password:', echo: false)
        puts '' # because not echoing above

        uri_string = "https://#{options[:server]}/f/api/0/jsonapi"
        uri = URI.parse(uri_string)

        header = {}
        body = { cmd: 'logon', email: options[:user], password: pass }

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = body.to_json

        response = http.request(request)
        puts response.body
      end
    end
  end
end
