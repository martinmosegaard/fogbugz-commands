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

      TABLE_HEADINGS = %w(Date Hours).freeze

      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        puts "Case #{intervals.first[KEY_CASE]} : #{intervals.first[KEY_TITLE]}"

        by_person = intervals_by_person(intervals)
        by_person.each { |person_id, person_intervals| table_by_person(person_id, person_intervals) }
      end

      private

      def table_by_person(person_id, person_intervals)
        puts "\nPerson: #{person_id}"
        rows = []
        person_intervals.each do |json|
          rows << [to_weekday(json[KEY_INTERVAL_START]),
                   to_hours_string(json)]
        end
        puts Terminal::Table.new headings: TABLE_HEADINGS, rows: rows
      end

      def intervals_by_person(intervals)
        hash = {}
        intervals.each do |json|
          person_id = json[KEY_PERSON]
          if hash.key?(person_id)
            hash[person_id].push(json)
          else
            hash[person_id] = [json]
          end
        end
        hash
      end

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

      def to_weekday(iso8601_str)
        date_time = to_date_time(iso8601_str)
        day_name = date_time.strftime('%A').ljust(9) # Longest day name is Wednesday
        day_and_month = date_time.strftime('%d-%m')
        "#{day_name} #{day_and_month}"
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
