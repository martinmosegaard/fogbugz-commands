require 'date'

module Fogbugz
  module Commands
    # A time report interval
    class Interval
      attr_accessor :length_in_seconds

      def initialize(json)
        time_end = to_time(json['dtEnd'])
        time_start = to_time(json['dtStart'])
        @length_in_seconds = time_end - time_start
      end

      private

      def to_time(iso8601_str)
        date_time = DateTime.iso8601(iso8601_str)
        date_time.to_time
      end
    end
  end
end
