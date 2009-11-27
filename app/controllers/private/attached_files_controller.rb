class Private::AttachedFilesController < PrivateController	
	# GET /news_items/:news_item_id/attached_files/new
	def new
		@attached_file = AttachedFile.new(:news_item_id => params[:news_item_id])
	end
	
	# POST /news_items/:news_item_id/attached_files
	def create
		@attached_file = AttachedFile.new(params[:attached_file])
		
		if @attached_file.save
			flash[:notice] = "Attached file #{@attached_file.file_name}!"
			redirect_to new_private_news_item_attached_file_url(@attached_file.news_item)
		else
			flash[:error] = 'Couldn\'t make attachment.'
			render 'new'
		end
	end
	
	# DELETE /news_items/:news_item_id/attached_files/:id
	def destroy
		@attachment = AttachedFile.find(params[:id])
		@attachment.destroy
		flash[:notice] = "Destroyed attachment '#{@attachment.data_file_name}.'"
		redirect_to @attachment.news_item
	end
end
