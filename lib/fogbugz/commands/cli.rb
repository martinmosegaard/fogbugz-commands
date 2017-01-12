require 'terminal-table'
require 'thor'

module Fogbugz
  module Commands
    # Command line interface.
    class Cli < Thor
      attr_accessor :server

      desc 'report', 'Get a time report'
      long_desc <<-EOH
      Get a time report for a particular case.
      EOH
      method_option :case, type: :numeric, required: true, desc: 'Case number'
      method_option :user, type: :string, required: true, desc: 'Username'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def report
        @server = options[:server]
        token = logon(options[:user])

        body = { cmd: 'listIntervals', token: token, ixPerson: 1, ixBug: options[:case] }
        data = http.request(body)
        intervals = data['intervals']

        rows = []
        intervals.each { |record| rows << record.values }
        puts Terminal::Table.new headings: intervals.first.keys, rows: rows
      end

      private

      def logon(user)
        pass = ask('Password:', echo: false)
        puts '' # because not echoing above

        body = { cmd: 'logon', email: user, password: pass }
        data = http.request(body)
        data['token']
      end

      def http
        @http ||= Http.new(server)
      end
    end
  end
end
