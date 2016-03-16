require 'spec_helper'

describe Api::V1::OrdersController do

  describe 'GET #index' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times {
        FactoryGirl.create :order, user: current_user
      }
      get :index, user_id: current_user.id
    end

    it 'returns 4 orders from the user' do
      order_response = json_response[:orders]
      expect(order_response.size).to eq 4
    end

    it { should respond_with(200) }
  end

  describe 'GET #show' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user
      get :show, user_id: current_user.id, id: @order.id
    end

    it 'returns the user order record matching the id' do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql @order.id
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      product_1 = FactoryGirl.create :product
      product_2 = FactoryGirl.create :product
      order_params = { product_ids: [product_1.id, product_2.id] }
      post :create, { user_id: current_user.id, order: order_params }
    end

    it 'returns the user\s order record' do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end

    it { should respond_with 201 }

  end

end
