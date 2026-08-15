# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'GET index' do
    it 'loads all representatives' do
      representative = Representative.create!(
        name: 'Jane Doe',
        ocdid: '412345',
        title: 'Representative'
      )

      get :index

      expect(response).to be_successful
      expect(assigns(:representatives)).to include(representative)
    end
  end

  describe 'GET show' do
    it 'loads the requested representative' do
      representative = Representative.create!(
        name: 'Jane Doe',
        ocdid: '412345',
        title: 'Representative'
      )

      get :show, params: { id: representative.id }

      expect(response).to be_successful
      expect(assigns(:representative)).to eq(representative)
    end
  end
end
