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

      attr_reader :api

      def initialize(api)
        @api = api
      end

      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        case_number = intervals.first[KEY_CASE]
        title = intervals.first[KEY_TITLE]
        tables = {}
        by_person = intervals_by_person(intervals)
        by_person.each do |person_id, person_intervals|
          person = api.get_person_name(person_id)
          days = summarize_by_person(person_intervals)
          tables[person] = table_by_person(days)
        end

        print_tables(case_number, title, tables)
      end

      private

      def print_tables(case_number, title, tables)
        puts "Case #{case_number} : #{title}"
        tables.each do |person, table|
          puts "\n#{person}"
          puts table
        end
      end

      def summarize_by_person(person_intervals)
        days = {}
        person_intervals.each do |json|
          day = to_weekday(json[KEY_INTERVAL_START])
          seconds = to_range(json)
          if days.key?(day)
            days[day] += seconds
          else
            days[day] = seconds
          end
        end
        days
      end

      def table_by_person(days)
        rows = []
        total_length = 0
        days.each do |day, seconds|
          rows << [day, format_length(seconds)]
          total_length += seconds
        end
        table = Terminal::Table.new headings: TABLE_HEADINGS, rows: rows
        table.add_separator
        table.add_row ['Total', format_length(total_length)]
        table
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
        Kernel.format('%.2f', hours).rjust(5) # 5 characters as in 12.34 hours
      end
    end
  end
end
