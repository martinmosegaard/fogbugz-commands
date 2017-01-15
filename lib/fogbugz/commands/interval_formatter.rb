require 'terminal-table'

module Fogbugz
  module Commands
    # Formats interval data.
    class IntervalFormatter
      # Prints a table of intervals.
      # @param intervals Interval JSON data.
      def format(intervals)
        rows = []
        intervals.each { |record| rows << record.values }
        puts Terminal::Table.new headings: intervals.first.keys, rows: rows
      end
    end
  end
end
