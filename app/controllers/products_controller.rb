class ProductsController < ApplicationController

	def index
		@products = Product.includes(:user).first(20)
		@sum_price = Product.sum(:price).to_f
	end

	def create
		@product = Product.new(params[:product])

		respond_to do |format|
  		if @product.save
   		 format.html { render :action => "create" }
   		 format.json { render :json => @product }
 			else
    		 format.html { render :action => "new" }
  		 format.json { render :json => @product.errors, :status => :unprocessable_entity }
 			end
		end  
	end

	def new
		@product = Product.new
	end

	def show
 		@product = Product.where(:id => params[:id]).first
	end

	def edit
 		@product = Product.where(:id => params[:id]).first
	end

	def update
  	@product = Product.where(:id => params[:id]).first

 		respond_to do |format|
      if @product.update_attributes(params[:product])
    		format.html { redirect_to :back, :notice => 'Product was successfully updated.' }
    		format.json { render json: @product }
      else
      	format.html { render action: "edit" }
      	format.json { render json: @product.errors, :status => :unprocessable_entity }
      end
  	end
	end

	def destroy
 		@product = Product.where(:id => params[:id]).first
		@product.destroy

		respond_to do |format|
  		format.html { redirect_to products_url }
  		format.json { head :no_content }
		end
	end
end
