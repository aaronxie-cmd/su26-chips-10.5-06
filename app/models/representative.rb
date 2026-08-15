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
class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.geocodio_search(query)
    geocodio_api_key = ENV.fetch(
      'GEOCODIO_API_KEY',
      Rails.application.credentials[:GEOCODIO_API_KEY]
    )

    raise ArgumentError, 'Missing GEOCODIO_API_KEY' if geocodio_api_key.blank?

    geocodio = Geocodio::Gem.new(geocodio_api_key)
    geocodio.geocode(query, ['cd'])
  end

  def self.civic_api_to_representative_params(rep_info)
    districts = rep_info.dig(
      'results', 0,
      'response', 'results', 0,
      'fields', 'congressional_districts'
    ) || []

    legislators = districts.flat_map do |district|
      district['current_legislators'] || []
    end

    legislators.map do |official|
      title = official['type'].to_s
      govtrack_id = official.dig('references', 'govtrack_id').to_s

      find_rep(
        official,
        title: title,
        ocdid: govtrack_id
      )
    end
  end

  def self.find_rep(official, title: '', ocdid: '')
    name = representative_name(official)

    rep =
      if ocdid.present?
        Representative.find_or_initialize_by(ocdid: ocdid)
      else
        Representative.find_or_initialize_by(
          name: name,
          title: title
        )
      end

    rep.update_from_geocodio(
      official,
      title: title,
      ocdid: ocdid
    )
  end

  def update_from_geocodio(official, title: '', ocdid: '')
    bio = official['bio'] || {}
    contact = official['contact'] || {}
    references = official['references'] || {}

    bioguide_id = references['bioguide_id']

    assign_attributes(
      name: self.class.representative_name(official),
      title: title.presence || official['type'],
      ocdid: ocdid.presence || references['govtrack_id'].to_s,
      party: bio['party'],
      address: contact['address'],
      phone_number: contact['phone'],
      website_url: contact['url'],
      photo_url: self.class.photo_url_for(bioguide_id)
    )

    save!
    self
  end

  def self.representative_name(official)
    first_name = official.dig('bio', 'first_name')
    last_name = official.dig('bio', 'last_name')

    [first_name, last_name].compact.join(' ').presence || official['name']
  end

  def self.photo_url_for(bioguide_id)
    return nil if bioguide_id.blank?

    "https://bioguide.congress.gov/bioguide/photo/#{bioguide_id.first}/#{bioguide_id}.jpg"
  end
end
