# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:state) do
    State.create!(
      name: 'California',
      symbol: 'CA',
      fips_code: 6,
      is_territory: 0,
      lat_min: 32.30,
      lat_max: 42.00,
      long_min: -124.48,
      long_max: -114.13
    )
  end

  let(:county) do
    state.counties.create!(
      name: 'Alameda',
      fips_code: 1,
      fips_class: 'H1'
    )
  end

  let!(:event) do
    Event.create!(
      name: 'Community Meeting',
      description: 'Local event',
      county: county,
      start_time: 1.day.from_now,
      end_time: 2.days.from_now
    )
  end

  describe 'GET index' do
    it 'loads all events without a filter' do
      get :index

      expect(response).to be_successful
      expect(assigns(:events)).to include(event)
    end

    it 'filters events by state' do
      get :index,
          params: {
            'filter-by' => 'state-only',
            'state' => 'CA'
          }

      expect(assigns(:events)).to include(event)
    end

    it 'filters events by county' do
      get :index,
          params: {
            'filter-by' => 'county',
            'state' => 'CA',
            'county' => county.fips_code
          }

      expect(assigns(:events)).to include(event)
    end
  end

  describe 'GET show' do
    it 'loads the requested event' do
      get :show, params: { id: event.id }

      expect(response).to be_successful
      expect(assigns(:event)).to eq(event)
    end
  end
end
