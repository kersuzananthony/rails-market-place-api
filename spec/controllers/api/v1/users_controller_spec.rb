require 'spec_helper'

describe Api::V1::UsersController do

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id
    end

    it 'returns the information about a reporter on a hash' do
      user_response = json_response[:user]
      expect(user_response[:email]).to eql @user.email
    end

    it 'shoud return a response status equals to 200' do
      expect(response.status).to eql 200
    end

    it 'has products ids has embed object' do
      user_response = json_response[:user]
      expect(user_response[:product_ids]).to eql []
    end

  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        user_response  = json_response[:user]
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it 'should return a 201 response status' do
        expect(response.status).to eql 201
      end

    end

    context 'when is not created' do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: '12345678',
                                     password_confirmation: '12345678'}
        post :create, { user: @invalid_user_attributes }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include 'can\'t be blank'
      end

      it 'should return a 422 response status' do
        expect(response.status).to eql 422
      end
    end
  end

  describe 'PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      api_authorization_header @user.auth_token
    end

    context 'When user is successfully updated' do
      before(:each) do
        patch :update, { id: @user.id, user: { email: 'newemail@marketplace.com' } }
      end

      it 'renders the JSON representation of the updated user' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql 'newemail@marketplace.com'
      end

      it 'should return a 200 response status' do
        expect(response.status).to eql 200
      end

    end

    context 'When user is not updated' do
      before(:each) do
        patch :update, { id: @user.id, user: { email: 'bademail.com' }}
      end

      it 'renders an error json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the error json explaining why user was not created' do
        expect(json_response[:errors][:email]).to include 'is invalid'
      end

      it 'should return a 422 response status' do
        expect(response.status).to eql 422
      end

    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.auth_token }
    end

    it 'should return a 204 response status' do
      expect(response.status).to eql 204
    end
  end

end
