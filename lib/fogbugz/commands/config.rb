require 'yaml'

module Fogbugz
  module Commands
    # Configuration reader
    class Config
      ENV_EMAIL = 'FOGBUGZ_EMAIL'.freeze
      ENV_SERVER = 'FOGBUGZ_SERVER'.freeze
      ENV_PASS = 'FOGBUGZ_PASSWORD'.freeze
      PROPS = '.fogbugz.yml'.freeze

      attr_reader :email, :file, :server, :pass

      def initialize
        @email = ENV[ENV_EMAIL]
        @server = ENV[ENV_SERVER]
        @pass = ENV[ENV_PASS]

        read_file unless @email && @server
      end

      private

      def read_file
        @file = File.join(Dir.home, PROPS)
        abort error_message unless File.exist?(file)

        config = YAML.load_file(file) || abort(error_message)

        @email ||= config['email'] || abort(error_message)
        @server ||= config['server'] || abort(error_message)
      end

      def error_message
        %(
        Incomplete configuration.

        Either set environment variables:

        #{ENV_EMAIL}=you@company.com
        #{ENV_SERVER}=company.fogbugz.com

        Or create the file #{@file} with this content:

        email: you@company.com
        server: company.fogbugz.com
      )
      end
    end
  end
end
