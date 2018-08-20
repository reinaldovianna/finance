class TributesController < ApplicationController
  def index
    @clients = Client.where({:status =>'active'}).search(search_params).paginate(page: params[:page], per_page: 10)

    render "index"
  end

  def show
    @client = Client.find(params[:id])
  end
end
