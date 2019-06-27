require 'net/http'
require 'dotenv/load'

module Campaign
  module Discrepancies
    require_relative 'prepare_result'

    class Identify
      DEFAULT_URL = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'.freeze
      EXTERNAL_URL = ENV.fetch('EXTERNAL_URL', DEFAULT_URL)
      ERROR_MESSAGE = 'Sorry campaigns can not be synced at the moment, please try after some time'.freeze

      def initialize
      end

      def self.call
        new.detect
      end

      def detect
        response = fetch_response
        parsed_result = JSON.parse(response)
        return 'No campaigns found!' unless parsed_result['ads']

        PrepareResult.call(parsed_result['ads'])
      rescue => _e
        ERROR_MESSAGE
      end

      def fetch_response
        escaped_addr = URI.escape(EXTERNAL_URL)
        uri = URI.parse(escaped_addr)
        Net::HTTP.get(uri)
      end
    end
  end
end
