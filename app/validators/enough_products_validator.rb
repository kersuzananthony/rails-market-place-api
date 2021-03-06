class EnoughProductsValidator < ActiveModel::Validator

  def validate(record)
    record.placements.each do |placement|
      product = placement.product
      if placement.is_a?(Placement) && product.is_a?(Product)
        if placement.quantity > product.quantity
          record.errors["#{product.title}"] << "Is out of stock, just #{product.quantity} left"
        end
      end
    end
  end

end