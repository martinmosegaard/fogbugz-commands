require 'yaml'

module Fogbugz
  module Commands
    # Configuration reader
    class Config
      PROPS = '.fogbugz.yml'.freeze

      attr_reader :email, :file, :server

      def initialize
        @file = File.join(Dir.home, PROPS)
        abort error_message unless File.exist?(file)

        config = YAML.load_file(file) or abort error_message

        @email = config['email'] or abort error_message
        @server = config['server'] or abort error_message
      end

      private

      def error_message
        %{
        Incomplete configuration file #{@file}

        Create the file with this content:

        email: you@company.com
        server: company.fogbugz.com
      }
      end
    end
  end
end
