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
      method_option :email, type: :string, required: true, desc: 'Login email'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def last_week
        start_date, end_date = DateRange.last_week
        intervals = api.list_intervals(start_date: start_date, end_date: end_date, case_number: options[:case])
        CaseIntervalFormatter.new(api).format(intervals)
      end

      desc 'person', 'View person details'
      method_option :email, type: :string, required: true, desc: 'Login email'
      method_option :id, type: :numeric, required: true, desc: 'Person ID'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def person
        data = api.view_person(options[:id])
        puts data
      end

      desc 'this_week', "Get a user's time report for this week"
      long_desc <<-EOH
      Get a time report for all cases worked on by a specific user this week.
      EOH
      method_option :email, type: :string, required: true, desc: 'Login email'
      method_option :id, type: :numeric, required: true, desc: 'Person ID'
      method_option :server, type: :string, required: true, desc: 'FogBugz server'
      def this_week
        start_date, end_date = DateRange.this_week
        intervals = api.list_intervals(start_date: start_date, end_date: end_date, person_id: options[:id])
        PersonIntervalFormatter.new(api).format(intervals)
      end

      private

      def api
        return @api if @api

        pass = ask('Password:', echo: false)
        puts '' # because not echoing above

        @api = Api.new(options[:server], options[:email], pass)
      end
    end
  end
end
