require 'rest-client'
require 'models/campaign'

module Campaign
  module Discrepancies
    class Identify
      EXTERNAL_URL = ENV.fetch('EXTERNAL_URL', 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df')

      def initialize
      end

      def self.call
        new.identify_descrepancies
      end

      def identify_descrepancies
        response = RestClient.get(EXTERNAL_URL)
        puts response.body
      end
    end
  end
end
