# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id           :integer          not null, primary key
#  address      :string
#  name         :string
#  ocdid        :string
#  party        :string
#  phone_number :string
#  photo_url    :string
#  title        :string
#  website_url  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Representative, type: :model do
  let(:official) do
    {
      'type' => 'representative',
      'bio' => {
        'first_name' => 'Jane',
        'last_name' => 'Doe',
        'party' => 'Democrat'
      },
      'contact' => {
        'url' => 'https://doe.house.gov',
        'address' => '1234 Longworth House Office Building; Washington DC 20515',
        'phone' => '202-225-0000'
      },
      'references' => {
        'bioguide_id' => 'D000000',
        'govtrack_id' => '412345'
      }
    }
  end

  let(:geocodio_response) do
    {
      'results' => [
        {
          'response' => {
            'results' => [
              {
                'fields' => {
                  'congressional_districts' => [
                    {
                      'current_legislators' => [official]
                    }
                  ]
                }
              }
            ]
          }
        }
      ]
    }
  end

  describe '.civic_api_to_representative_params' do
    it 'creates a representative from Geocodio data' do
      representatives =
        described_class.civic_api_to_representative_params(
          geocodio_response
        )

      representative = representatives.first

      expect(representative.name).to eq('Jane Doe')
      expect(representative.ocdid).to eq('412345')
      expect(representative.title).to eq('representative')
      expect(representative.party).to eq('Democrat')
    end

    it 'does not create a duplicate representative when called twice' do
      described_class.civic_api_to_representative_params(
        geocodio_response
      )

      expect do
        described_class.civic_api_to_representative_params(
          geocodio_response
        )
      end.not_to change(described_class, :count)

      expect(described_class.count).to eq(1)
    end

    it 'stores contact information from Geocodio' do
      representative =
        described_class.civic_api_to_representative_params(
          geocodio_response
        ).first

      expect(representative.address)
        .to eq('1234 Longworth House Office Building; Washington DC 20515')
      expect(representative.phone_number).to eq('202-225-0000')
      expect(representative.website_url).to eq('https://doe.house.gov')
    end

    it 'constructs a portrait URL from the bioguide id' do
      representative =
        described_class.civic_api_to_representative_params(
          geocodio_response
        ).first

      expect(representative.photo_url).to include('D000000')
    end

    it 'handles missing optional fields' do
      official['contact'] = {}
      official['references'] = {
        'govtrack_id' => '412345'
      }

      representative =
        described_class.civic_api_to_representative_params(
          geocodio_response
        ).first

      expect(representative).to be_persisted
      expect(representative.phone_number).to be_nil
      expect(representative.website_url).to be_nil
      expect(representative.photo_url).to be_nil
    end
  end
end
