require 'date'

module Fogbugz
  module Commands
    # Working with date ranges.
    class DateRange
      # Return an array of two date-time strings denoting the start and end of last week.
      def self.last_week
        this_monday = DateRange.monday_this_week
        [DateRange.monday_last_week(this_monday), DateRange.sunday_last_week(this_monday)]
      end

      # Return an array of two date-time strings denoting the start and end of this week (until now).
      def self.this_week
        now = DateTime.now.iso8601
        this_monday = DateRange.monday_this_week
        [DateRange.sunday_last_week(this_monday), now]
      end

      def self.monday_this_week
        day = Date.today
        day = day.prev_day until day.monday?
        day
      end

      # 12 midnight Monday last week.
      def self.monday_last_week(this_monday)
        this_monday.prev_day(7).to_datetime.iso8601
      end

      # Well, technically 12 midnight between Sunday last week and Monday this week.
      def self.sunday_last_week(this_monday)
        this_monday.to_datetime.iso8601
      end
    end
  end
end
