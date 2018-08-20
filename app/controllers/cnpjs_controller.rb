class CnpjsController < ApplicationController

  def new_cnpj
    @cnpj = Cnpj.create

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_cnpj
    @cnpj = Cnpj.find(params[:id])    

    client = Client.find_by_cnpj(@cnpj)
    @client_cnpjs = client_cnpjs(client)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_cnpj_partial
    @cnpj = Cnpj.find(params[:id])

    render :json => { :form => render_to_string('/cnpjs/_form_edit', :layout => false, :locals => { :cnpj => @cnpj }) }
  end

  def create
    @cnpj = Cnpj.where(cnpj_params.slice(:id)).first_or_initialize
    @cnpj.attributes = cnpj_params

    respond_to do |format|
      if @cnpj.save
        format.json { render json: {}, :status => :ok }
      else
        format.json { render json: {}, :status => 400 }
      end
    end
  end

private
  def cnpj_params
    params.require(:cnpj).permit(cnpj_permit)
  end

  def cnpj_permit
    [
      :id,
      :vat_number,
      :company_name,
      :trading_name,
      :street_address,
      :number_address,
      :detail_address,
      :cep_address,
      :neighborhood_address,
      :city_address,
      :uf_address,
      :email,
      :phone
    ]
  end

  def client_cnpjs client
    client_cnpj = client.channel_stores.map do |channel| 
                    [channel.cnpj.vat_number, channel.cnpj.id ] if channel.cnpj.id != client.cnpj.id 
                  end.compact.uniq
    client_cnpj << ["#{client.cnpj.vat_number} | PRINCIPAL", client.cnpj.id]
    client_cnpj
  end
end