# frozen_string_literal: true

Given 'a representative exists with complete profile information' do
  @representative = Representative.create!(
    name: 'Jane Doe',
    ocdid: '412345',
    title: 'Representative',
    party: 'Democrat',
    address: '123 Main Street',
    phone_number: '202-225-0000',
    website_url: 'https://doe.house.gov',
    photo_url: nil
  )
end

Given 'a representative exists with missing profile information' do
  @representative = Representative.create!(
    name: 'John Smith',
    ocdid: '987654',
    title: 'Representative'
  )
end

When "I visit that representative's profile" do
  visit representative_path(@representative)
end
