# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id         :integer          not null, primary key
#  name       :string
#  ocdid      :string
#  party      :string
#  photo_url  :string
#  title      :string
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
  it 'does not create duplicate records when importing the same representative twice' do
    # create representative

    official_data = {
      'name' => 'name',
      'party' => 'party',
      'photo_url' => 'photo_url'
    }

    Representative.find_rep(official_data, ocdid: 't', title: 't') # replace with the actual method name in your codebase


    expect do
      Representative.find_rep(official_data, ocdid: 't', title: 't') # replace with the actual method name in your codebase
    end.not_to change(Representative, :count)
  end
end
