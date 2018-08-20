class PendenciesController < ApplicationController
	def clients
		@clients = Client.pending
		@clients = @clients.paginate(page: params[:page], per_page: 10)
		
		render 'clients'
	end
end
