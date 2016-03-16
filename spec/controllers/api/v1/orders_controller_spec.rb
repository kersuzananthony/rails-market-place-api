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

end
