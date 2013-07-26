class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	@time = Time.now
  	@count = increment_counter
  end
end
