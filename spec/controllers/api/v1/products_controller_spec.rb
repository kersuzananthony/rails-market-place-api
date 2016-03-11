require 'spec_helper'

describe Api::V1::ProductsController do

  describe 'GET #show' do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it 'return the information of an article to a hash' do
      expect(json_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      4.times do
        FactoryGirl.create :product
      end
      get :index
    end

    it 'returns 4 records from the database' do
      expect(json_response[:products]).to have(4).items
    end

    it { should respond_with 200 }

  end

end
