class FansController < ApplicationController
	# GET /fans/new
	# GET /fans/new.xml
	def new
		@fan = Fan.new
		
		respond_to do |format|
			format.html # new.html.erb
		end
	end
	
	# POST /fans
	# POST /fans.xml
	def create
		@fan = Fan.new(params[:fan])
		
		respond_to do |format|
			if @fan.save
				flash[:notice] = 'Thanks for signing up! Hope to see you at our next concert.'
				format.html { redirect_to(news_items_url) }
			else
				format.html { render :action => :new }
			end
		end
	end
	
	# DELETE /fans/1
	# DELETE /fans/1.xml
	def destroy
		@fan = Fan.find(params[:id])
		@fan.destroy
		flash[:notice] = 'We\'ll miss you. Thanks for being a great fan!'
		
		respond_to do |format|
			format.html { redirect_to(news_items_url) }
		end
	end
end
