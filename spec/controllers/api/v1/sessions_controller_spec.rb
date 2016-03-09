require 'spec_helper'

describe Api::V1::SessionsController do

  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context 'When the credentials are correct' do
      before(:each) do
        credentials = { email: @user.email, password: '12345678'}
        post :create, { session: credentials }

      end

      it 'should return the correct user according to the credentials' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with(200) }

    end

    context 'When the credentials are incorrect' do
      before(:each) do
        credentials = { email: @user.email, password: 'invalidpassword'}
        post :create, { session: credentials }
      end

      it 'should return errors due to invalid credentials' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with(422) }

    end
  end

  describe 'DELETE#destroy' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
      delete :destroy, id: @user.auth_token
    end

    it 'should change the user auth_token' do
      old_token = @user.auth_token
      @user.reload
      new_token = @user.auth_token
      expect(old_token).not_to eql new_token
    end

    it { should respond_with(204) }
  end

end
