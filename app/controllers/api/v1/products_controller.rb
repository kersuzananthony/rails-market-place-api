class Api::V1::ProductsController < ApplicationController

  respond_to :json

  def index
    respond_with Product.all
  end

  def show
    @product = Product.find(params[:id])
    # render json: @product = respond_with @product
    respond_with @product
  end

end
