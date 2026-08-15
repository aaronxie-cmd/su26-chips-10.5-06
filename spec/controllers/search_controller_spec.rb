# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET search' do
    let(:api_response) do
      { 'results' => [] }
    end

    let(:representative) do
      Representative.new(
        name: 'Jane Doe',
        title: 'representative'
      )
    end

    before do
      allow(Representative).to receive(:geocodio_search)
        .and_return(api_response)

      allow(Representative)
        .to receive(:civic_api_to_representative_params)
        .and_return([representative])
    end

    it 'searches Geocodio using the supplied address' do
      get :search, params: { address: 'Los Angeles CA' }

      expect(Representative)
        .to have_received(:geocodio_search)
        .with('Los Angeles CA')
    end

    it 'assigns the representatives returned by the model' do
      get :search, params: { address: 'Los Angeles CA' }

      expect(assigns(:representatives)).to eq([representative])
    end

    it 'stores a readable search term' do
      get :search, params: { address: 'Los%20Angeles%20CA' }

      expect(assigns(:search_term)).to eq('Los Angeles CA')
    end
  end
end
