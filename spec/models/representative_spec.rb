# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id         :integer          not null, primary key
#  city       :string
#  name       :string
#  ocdid      :string
#  party      :string
#  photo_url  :string
#  state      :string
#  street     :string
#  title      :string
#  zip        :string
#  created_at :datetime         not null

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Representative do
  describe '.civic_api_to_representative_params' do
    subject(:process_official_twice) do
      2.times do
        described_class.civic_api_to_representative_params(
          geocodio_response
        )
      end
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
                        'current_legislators' => [
                          {
                            'bio' => {
                              'first_name' => 'Jane',
                              'last_name'  => 'Doe'
                            },
                            'type'        => 'representative',
                            'govtrack_id' => '412345',
                            'party'       => 'Democrat',
                            'photo_url'   => 'https://example.com/photo.jpg'
                          }
                        ]
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

    let(:expected_attributes) do
      {
        name:  'Jane Doe',
      ocdid: '412345',
      title: 'representative'
      }
    end

    it 'does not create a duplicate when the same official is processed twice' do
      expect { process_official_twice }.to change(described_class, :count).by(1)
      expect(described_class.find_by(ocdid: '412345')).to have_attributes(expected_attributes)
    end
  end
end