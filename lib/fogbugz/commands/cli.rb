require 'thor'

module Fogbugz
  module Commands
    # Command line interface.
    class Cli < Thor
      desc 'last_week', 'Get a time report for last week'
      long_desc <<-EOH
      Get a time report for the last week for a particular case.
      EOH
      method_option :case, type: :numeric, required: true, desc: 'Case number'
      method_option :user, type: :string, required: true, desc: 'Username'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def last_week
        start_date, end_date = DateRange.last_week
        intervals = api.list_intervals(options[:case], start_date, end_date)
        IntervalFormatter.new(api).format(intervals)
      end

      desc 'person', 'View person details'
      method_option :id, type: :numeric, required: true, desc: 'Person ID'
      method_option :user, type: :string, required: true, desc: 'Username'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def person
        data = api.view_person(options[:id])
        puts data
      end

      private

      def api
        return @api if @api

        pass = ask('Password:', echo: false)
        puts '' # because not echoing above

        @api = Api.new(options[:server], options[:user], pass)
      end
    end
  end
end
