require 'spec_helper'

RSpec.describe Campaign::Discrepancies::Identify do
  let!(:campaigns) do
    Models::Campaign.create!(job_id: 1,
      status: :active,
      external_reference: 1,
      ad_description: 'Java Developer')
    end

    let(:expected_response) do
      {
        ads:
        [
          {
            reference: "1",
            status: "enabled",
            description: "Description for campaign 11"
          },
          {
            reference: "2",
            status: "disabled",
            description: "Description for campaign 12"
          },
          {
            reference: "3",
            status: "enabled",
            description: "Description for campaign 13"
          }
        ]
      }.to_json
    end

    let(:discrepancy_result) do
      [
        {
          remote_reference: "1",
          discrepancies: [
            {
              status: {
                remote: "enabled",
                local: "active"
              },
              description: {
                remote: "Description for campaign 11",
                local:"Java Developer"
              }
            }
          ]
        },
        {
          remote_reference: "2",
          discrepancies: [
            {
              status: {
                remote: "disabled",
                local: "Not present"
              },
              description: {
                remote: "Description for campaign 12",
                local: "No description"
              }
            }
          ]
        },
        {
          remote_reference: "3",
          discrepancies: [
            {
              status: {
                remote: "enabled",
                local: "Not present"
              },
              description: {
                remote: "Description for campaign 13",
                local: "No description",
              }
            }
          ]
        }
      ]
    end

    context 'when we get successful response from third party' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(expected_response)
      end

      it 'finds out the discrepancies' do
        expect(described_class.call).to eq(discrepancy_result)
      end
    end

    context 'when third party does not return anything' do
      before do
        allow(Net::HTTP).to receive(:get).and_return({}.to_json)
      end

      it 'says nothing found to the user' do
        expect(described_class.call).to eq('No campaigns found!')
      end
    end

    context 'when somewhere something goes wrong' do
      before do
        allow(Net::HTTP).to receive(:get).and_raise(Net::ReadTimeout)
      end

      it 'says to try later not possible to sync at the moment' do
        expect(described_class.call).
          to eq('Sorry campaigns can not be synced at the moment, please try after some time')
      end
    end
  end
