require 'models/campaign'

module Campaign
  module Discrepancies
    class PrepareResult
      attr_reader :remote_list

      def initialize(remote_list)
        @remote_list = remote_list
      end

      def self.call(remote_list)
        new(remote_list).generate
      end

      def generate
        output = []
        remote_list.each do |remote_campaign|
          local_cpg = Models::Campaign.find_by(external_reference: remote_campaign['reference']&.to_i)
          if local_cpg && !local_cpg.deleted?
            next if synced?(local_cpg, remote_campaign)

            output << prepare_not_synced_discrepancy(local_cpg, remote_campaign)
          else
            output << prepare_not_present_discrepancy(remote_campaign)
          end
        end
        output
      end

      def synced?(local, remote)
        (local.status == remote_state(remote['status'])) &&
        (local.ad_description == remote['description'])
      end

      def remote_state(remote_status)
        return 'active' if remote_status == 'enabled'
        return 'paused'
      end

      def prepare_not_present_discrepancy(remote)
        {
          remote_reference: remote['reference'],
          discrepancies: [
            status: {
              remote: remote['status'],
              local: 'Not present',
            },
            description: {
              remote: remote['description'],
              local: 'No description',
            },
          ]
        }
      end

      def prepare_not_synced_discrepancy(local, remote)
        {
          remote_reference: remote['reference'],
          discrepancies: [
            status: {
              remote: remote['status'],
              local: local.status,
            },
            description: {
              remote: remote['description'],
              local: local.ad_description,
            },
          ]
        }
      end
    end
  end
end
