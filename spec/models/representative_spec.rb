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
#  updated_at :datetime         not null
#
require 'rails_helper'

# This file is a stub.
# You should add your own test cases.
# We recommend creating a file for each model in the database.

# RSpec.describe Representative do
# end

RSpec.describe Representative, type: :model do
  describe '.find_rep' do
    let(:sample_official) do
      {
        'name' => 'Jane Doe',
        'type' => 'representative',
        'govtrack_id' => '412345',
        'party' => 'Democrat',
        'photo_url' => 'https://example.com/photo.jpg'
      }
    end

    it 'does not create duplicate representatives when called multiple times for the same person' do
      # First call / creation
      rep1 = Representative.find_rep(sample_official, title: 'representative', ocdid: '412345')
      expect(Representative.count).to eq(1)

      # Second call with the same unique identifiers
      rep2 = Representative.find_rep(sample_official, title: 'representative', ocdid: '412345')
      
      # Assertions: Count should remain 1 and it should be the exact same database record ID
      expect(Representative.count).to eq(1)
      expect(rep1.id).to eq(rep2.id)
    end
  end
end