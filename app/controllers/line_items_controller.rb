class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    #@line_item = LineItem.new(line_item_params)
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    session[:counter] = nil
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url}
        format.js {@current_item = @line_item}
        format.json { render json: @line_item, status: :created, location: @line_item }
        session[:counter] = nil
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
     if @line_item.quantity >1
       @line_item.update_attributes(:quantity => @line_item.quantity - 1)
     else
       @line_item.destroy
     end

    respond_to do |format|
        format.html { redirect_to store_url }
        format.json { head :ok }
    end
  end

  def decrement
    @cart = current_cart

    # 1st way: decrement through method in @cart
    @line_item = @cart.decrease(set_line_item) # passing in line_item.id

    # 2nd way: decrement through method in @line_item
    #@line_item = @cart.line_items.find_by_id(params[:id])
    #@line_item = @line_item.decrement_quantity(@line_item.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js {@current_item = @line_item}
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js {@current_item = @line_item}
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
