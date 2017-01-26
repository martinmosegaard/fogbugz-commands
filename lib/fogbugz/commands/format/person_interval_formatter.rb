require 'date'
require 'terminal-table'

module Fogbugz
  module Commands
    # Formats interval data for a single person.
    class PersonIntervalFormatter < IntervalFormatter
      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        tables = {}
        by_case = intervals_by_key(intervals, KEY_CASE)
        by_case.each do |case_number, case_intervals|
          case_title = case_intervals.first[KEY_TITLE]
          case_key = "#{case_number} - #{case_title}"
          days = summarize_per_day(case_intervals)
          tables[case_key] = table_body(days)
        end

        title = api.get_person_name(intervals.first[KEY_PERSON])
        print_tables(title, tables)
      end
    end
  end
end
