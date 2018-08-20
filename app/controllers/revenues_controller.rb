class RevenuesController < ApplicationController

  def index
  	@clients = Client.where({:status =>'active'}).search(search_params).paginate(page: params[:page], per_page: 10)

    render "index"
  end

  def show
    @client = Client.find(params[:id])
    
    @revenues = Revenue.where({:client_id => @client.id}).map
  end

  def create
  	@client = Client.find(params[:id])
    
    @revenues = Revenue.where({:client_id => @client.id}).map
  end

  def update
  	@client = Client.find(params[:id])
    
    @revenues = Revenue.where({:client_id => @client.id}).map
  end

  def start
    @client = Client.find(params[:id])
    Revenue.create({:client_id => @client.id})

    redirect_to revenue_path(@client.id)
  end
end