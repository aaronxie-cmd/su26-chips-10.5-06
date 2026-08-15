# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItemsController, type: :controller do
  let(:representative) do
    Representative.create!(
      name: 'Jane Doe',
      ocdid: '412345',
      title: 'Representative'
    )
  end

  let!(:news_item) do
    representative.news_items.create!(
      title: 'Example Article',
      link: 'https://example.com/article',
      description: 'Example description'
    )
  end

  describe 'GET index' do
    it 'loads the representative and their news items' do
      get :index,
          params: {
            representative_id: representative.id
          }

      expect(response).to be_successful
      expect(assigns(:representative)).to eq(representative)
      expect(assigns(:news_items)).to contain_exactly(news_item)
    end
  end

  describe 'GET show' do
    it 'loads the requested news item' do
      get :show,
          params: {
            representative_id: representative.id,
            id: news_item.id
          }

      expect(response).to be_successful
      expect(assigns(:news_item)).to eq(news_item)
    end
  end
end
