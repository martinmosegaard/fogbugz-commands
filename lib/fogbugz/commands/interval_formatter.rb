require 'date'
require 'terminal-table'

module Fogbugz
  module Commands
    # Formats interval data.
    class IntervalFormatter
      KEY_CASE = 'ixBug'.freeze
      KEY_INTERVAL_END = 'dtEnd'.freeze
      KEY_INTERVAL_START = 'dtStart'.freeze
      KEY_PERSON = 'ixPerson'.freeze
      KEY_TITLE = 'sTitle'.freeze

      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        headings = %w(Person Date Hours)
        rows = []
        intervals.each do |json|
          rows << [json[KEY_PERSON],
                   to_date_time(json[KEY_INTERVAL_START]).to_date,
                   to_hours_string(json)]
        end

        puts "Case #{intervals.first[KEY_CASE]} : #{intervals.first[KEY_TITLE]}"
        puts Terminal::Table.new headings: headings, rows: rows
      end

      private

      def to_hours_string(json)
        length_in_seconds = to_range(json)
        format_length(length_in_seconds)
      end

      def to_range(json)
        time_end = to_time(json[KEY_INTERVAL_END])
        time_start = to_time(json[KEY_INTERVAL_START])
        time_end - time_start
      end

      def to_date_time(iso8601_str)
        DateTime.iso8601(iso8601_str)
      end

      def to_time(iso8601_str)
        date_time = to_date_time(iso8601_str)
        date_time.to_time
      end

      # Formats a length in seconds to a human readable string of hours with 2 decimal places.
      def format_length(seconds)
        mm, _ss = seconds.divmod(60)
        hh, mm = mm.divmod(60)
        hours = hh + (mm / 60.0)
        Kernel.format('%.2f', hours)
      end
    end
  end
end
