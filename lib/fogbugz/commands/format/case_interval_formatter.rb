require 'date'
require 'terminal-table'

module Fogbugz
  module Commands
    # Formats interval data for a single case.
    class CaseIntervalFormatter < IntervalFormatter
      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        if intervals.empty?
          puts 'No intervals found.'
          return
        end

        case_number = intervals.first[KEY_CASE]
        title = intervals.first[KEY_TITLE]
        tables = {}
        by_person = intervals_by_key(intervals, KEY_PERSON)
        by_person.each do |person_id, person_intervals|
          person = api.get_person_name(person_id)
          days = summarize_per_day(person_intervals)
          tables[person] = table_body(days)
        end

        title = "Case #{case_number} - #{title}"
        print_tables(title, tables)
      end
    end
  end
end
