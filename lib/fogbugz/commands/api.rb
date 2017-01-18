module Fogbugz
  module Commands
    # FogBugz API methods.
    class Api
      attr_reader :server, :token, :http

      KEY_PERSON_NAME = 'sFullName'.freeze

      def initialize(server, user, pass)
        @server = server
        body = { cmd: 'logon', email: user, password: pass }
        data = http.request(body)
        @token = data['token']
      end

      def list_intervals(case_number, start_date, end_date)
        body = { cmd: 'listIntervals', token: token, ixPerson: 1, ixBug: case_number,
                 dtStart: start_date, dtEnd: end_date }
        data = http.request(body)
        data['intervals']
      end

      def view_person(person_id)
        body = { cmd: 'viewPerson', token: token, ixPerson: person_id }
        data = http.request(body)
        data['person']
      end

      def get_person_name(person_id)
        json = view_person(person_id)
        json[KEY_PERSON_NAME]
      end

      private

      def http
        @http ||= Http.new(server)
      end
    end
  end
end
