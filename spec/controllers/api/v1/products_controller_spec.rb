require 'spec_helper'

describe Api::V1::ProductsController do

  describe 'GET #show' do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it 'return the information of an article to a hash' do
      product_response = json_response[:product]
      expect(product_response[:title]).to eql @product.title
      expect(product_response[:user][:email]).to eql @product.user.email
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    context 'when is not receiving product_ids in parameter' do
      before(:each) do
        4.times do
          FactoryGirl.create :product
        end
        get :index
      end
      it 'returns 4 records from the database' do
        products_response = json_response[:products]
        expect(products_response).to have(4).items
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it 'returns the user object in each product' do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      # For the pagination
      it_behaves_like 'paginated list'

      it { should respond_with 200 }
    end

    context 'when is receiving product_ids in parameter' do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times do
          FactoryGirl.create :product,  user: @user
        end
        get :index, product_ids: @user.product_ids
      end

      it 'returns just the products that belong to the user' do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end
    end

  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        @product_attributes = FactoryGirl.attributes_for :product
        post :create, { user_id: @user.id, product: @product_attributes }
      end

      it 'renders the JSON representation of the created product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }

    end

    context 'when is not created because not valid' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        @invalid_product_attributes = { title: 'Good product', price: 'twenty dollars' }
        post :create, { user_id: @user.id, product: @invalid_product_attributes }
      end

      it 'renders an error JSON' do
        expect(json_response).to have_key :errors
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end

    context 'when is not created because no authorization header sent' do
      before(:each) do
        @user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        post :create, { user_id: @user.id, product: @product_attributes }
      end

      it { should respond_with 401 }
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
    end

    context 'when the product is successfully updated' do
      before(:each) do
        api_authorization_header @user.auth_token
        put :update, { user_id: @user.id, id: @product.id, product: { title: 'Updated title', price: '2.22' }}
      end

      it 'renders an JSON representation of the updated product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql 'Updated title'
      end

      it { should respond_with 200 }
    end

    context 'when the product could not be updated' do
      before(:each) do
        api_authorization_header @user.auth_token
        put :update, { user_id: @user.id, id: @product.id, product: { title: 'Awesome title updated', price: 'A price' }}
      end

      it 'renders an error JSON object' do
        expect(json_response).to have_key :errors
      end

      it 'renders the errors json on why the product cannot be updated' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end

    context 'when the product could not be updated because no authorization header sent' do
      before(:each) do
        put :update, { user_id: @user.id, id: @product.id, product: { title: 'Updated article', price: '2.22' }}
      end

      it { should respond_with 401 }
    end
  end

  describe 'DELETE #destroy' do

    context 'when the product is successfully deleted from the database' do
      before(:each) do
        @user = FactoryGirl.create :user
        @product = FactoryGirl.create :product, user: @user
        api_authorization_header @user.auth_token
        delete :destroy, { user_id: @user.id, id: @product.id }
      end

      it { should respond_with 204 }

    end

    context 'when the product cannot be deleted because header authorization is missing' do
      before(:each) do
        @user = FactoryGirl.create :user
        @product = FactoryGirl.create :product, user: @user
        delete :destroy, { user_id: @user.id, id: @product.id }
      end
      it { should respond_with 401 }

    end
  end
end
