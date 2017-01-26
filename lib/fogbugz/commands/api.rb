module Fogbugz
  module Commands
    # FogBugz API methods.
    class Api
      attr_reader :server, :token, :http

      KEY_PERSON_NAME = 'sFullName'.freeze

      def initialize(server, email, pass)
        @server = server
        body = { cmd: 'logon', email: email, password: pass }
        data = http.request(body)
        @token = data['token']
      end

      def list_intervals(start_date:, end_date:, case_number: nil, person_id: 1)
        body = list_intervals_body(start_date, end_date, case_number, person_id)
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

      def list_intervals_body(start_date, end_date, case_number, person_id)
        body = { cmd: 'listIntervals', token: token }
        body['dtStart'] = start_date if start_date
        body['dtEnd'] = end_date if end_date
        body['ixBug'] = case_number if case_number
        body['ixPerson'] = person_id if person_id
        body
      end

      def http
        @http ||= Http.new(server)
      end
    end
  end
end
