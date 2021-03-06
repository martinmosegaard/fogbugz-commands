require 'thor'

module Fogbugz
  module Commands
    # Command line interface.
    class Cli < Thor
      attr_reader :config

      desc 'last_week', 'Get a time report for last week'
      long_desc <<-EOH
      Get a time report for the last week for a particular case.
      EOH
      method_option :case, type: :numeric, required: true, desc: 'Case number'
      def last_week
        @config = Config.new
        start_date, end_date = DateRange.last_week
        intervals = api.list_intervals(start_date: start_date, end_date: end_date, case_number: options[:case])
        CaseIntervalFormatter.new(api).format(intervals)
      end

      desc 'person', 'View person details'
      method_option :id, type: :numeric, required: true, desc: 'Person ID'
      def person
        @config = Config.new
        data = api.view_person(options[:id])
        puts data
      end

      desc 'report', 'Get a time report for a user or a case'
      long_desc <<-EOH
      Get a time report for a specific interval, either for a user
      or a case.

      The --from and --to dates must be formatted as YYYY-MM-DD.

      If --user is provided, include intervals logged for that user only.
      If --case is provided, include intervals logged for that case only.
      EOH
      method_option :case, type: :numeric, required: false, desc: 'Case number'
      method_option :from, type: :string, required: true, desc: 'From date in YYYY-MM-DD format'
      method_option :id, type: :numeric, required: true, desc: 'Person ID', default: 1
      method_option :to, type: :string, required: true, desc: 'To date in YYYY-MM-DD format'
      def report
        @config = Config.new
        intervals = api.list_intervals(start_date: DateRange.iso8601(options[:from]),
                                       end_date: DateRange.iso8601(options[:to]),
                                       case_number: options[:case],
                                       person_id: options[:id])
        if options[:case]
          CaseIntervalFormatter.new(api).format(intervals)
        else
          PersonIntervalFormatter.new(api).format(intervals)
        end
      end

      desc 'this_week', "Get a user's time report for this week"
      long_desc <<-EOH
      Get a time report for all cases worked on by a specific user this week.
      EOH
      method_option :id, type: :numeric, required: true, desc: 'Person ID'
      def this_week
        @config = Config.new
        start_date, end_date = DateRange.this_week
        intervals = api.list_intervals(start_date: start_date, end_date: end_date, person_id: options[:id])
        PersonIntervalFormatter.new(api).format(intervals)
      end

      private

      def api
        return @api if @api

        pass = config.pass || ask('Password:', echo: false)
        puts '' # because not echoing above

        @api = Api.new(config.server, config.email, pass)
      end
    end
  end
end
