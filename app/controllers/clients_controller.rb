class ClientsController < ApplicationController
  
  def index
    @clients = Client.where({:status =>'active'}).search(search_params).paginate(page: params[:page], per_page: 10)

    render "index"
  end

  def create
    @client = Client.new({:status => 'new'})

    if @client.save
      session[:client_id] = @client.id
      redirect_to client_steps_path
    else
      render :index, notice: "Erro ao criar novo cliente: #{@client.errors.message.to_s}"
    end
  end

  def edit
    session[:client_id] = params[:id]
    redirect_to client_steps_path
  end

  def show
    @client = Client.find(params[:id])
  end

  def destroy
    @client = Client.find(params[:id])
  end

  def stores
    session[:client_id] = params[:id]
    redirect_to(client_steps_path + "/stores")
  end

  def channel_stores
    session[:client_id] = params[:id]
    redirect_to(client_steps_path + "/channel_stores")
  end

  def table_taxes
    session[:client_id] = params[:id]
    redirect_to(client_steps_path + "/table_taxes")
  end

  def add_table_tax
    client = Client.find(params[:id])

    table_tax_hash = {:client_id => client.id, :status => 'new'}
    table_tax = TableTax.create(table_tax_hash)
    
    render :json => { :form => render_to_string('/channel_stores/_channel_table_tax', :layout => false, :locals => { :table_tax => table_tax }) }
  end

  def add_channel_store
    client = Client.find(params[:id])

    channel_hash = {:client_id => client.id, :status => 'new'}
    ChannelStore.fallback_client_params(channel_hash, client)

    channel_hash.merge!({:cnpj_id => client.cnpj.id}) if client.cnpj

    channel_store = ChannelStore.create(channel_hash)
    
    render :json => { :form => render_to_string('/channel_stores/_form', :layout => false, :locals => { :channel_store => channel_store }) }
  end

  def add_store
    store = Store.create({:client_id => params[:id], :status => 'new'})
  
    render :json => { :form => render_to_string('/stores/_form', :layout => false, :locals => { :store => store }) }
  end

  def add_contact
    client_contact = ClientContact.create({:client_id => params[:id]})
  
    render :json => { :form => render_to_string('/clients/_client_contact', :layout => false, :locals => { :client_contact => client_contact }) }
  end

  def remove_table_tax
    table_tax = TableTax.find_by({:id => params[:table_tax_id], :client_id => params[:id]})

    respond_to do |format|
      if table_tax && table_tax.remove_allowed? && table_tax.delete
        format.json { render json: message_json("Tabela de tributos removido com sucesso"), :status => :ok }
      elsif table_tax.nil?
        format.json { render json: message_json("Tabela de tributos não encontrado para o cliente."), :status => 401 }
      elsif table_tax.channel_linked?
        format.json { render json: message_json("Tabela de tributos vinculada a um canal ativo não pode ser removida."), :status => 402 }
      elsif table_tax.active?
        format.json { render json: message_json("A tabela de tributos encontra-se ativa e não pode ser removida."), :status => 403 }
      elsif table_tax.errors.full_messages.present?
        format.json { render json: message_json(table_tax.errors.full_messages.join("; ")), :status => 404 }
      else
        format.json { render json: message_json("Erro inesperado. Não foi possível excluir a tabela de tributos."), :status => 405 }
      end
    end
  end

  def remove_channel_store
    channel_store = ChannelStore.find_by({:id => params[:channel_id], :client_id => params[:id]})

    respond_to do |format|
      if channel_store && !channel_store.active? && channel_store.delete
        format.json { render json: message_json("Canal removido com sucesso"), :status => :ok }
      elsif channel_store.nil?
        format.json { render json: message_json("Canal não encontrado para o cliente."), :status => 400 }
      elsif channel_store.active?
        format.json { render json: message_json("O canal encontra-se ativo e não pode ser removido."), :status => 400 }
      elsif channel_store.errors.full_messages.present?
        format.json { render json: message_json(channel_store.errors.full_messages.join("; ")), :status => 400 }
      else
        format.json { render json: message_json("Erro inesperado. Não foi possível excluir o canal."), :status => 400 }
      end
    end
  end

  def remove_store
    store = Store.find_by({:id => params[:store_id], :client_id => params[:id]})
  
    respond_to do |format|
      format.html do
        redirect_to clients_path
      end

      if store && store.destroy
        format.json { render json: message_json("Loja removida com sucesso"), :status => :ok }
      elsif store.nil?
        format.json { render json: message_json("Loja não encontrada para o cliente"), :status => 400 }
      elsif store.removal_enabled?
        format.json { render json: message_json("A loja encontra-se ativa e não pode ser removida"), :status => 400 }
      elsif store.errors.full_messages.present?
        format.json { render json: message_json(store.errors.full_messages.join("; ")), :status => 400 }
      else
        format.json { render json: message_json("Erro inesperado. Não foi possível excluir a loja."), :status => 400 }
      end
    end
  end  

  def remove_contact
    contact = ClientContact.find_by({:id => params[:contact_id], :client_id => params[:id]})
  
    respond_to do |format|
      if contact && contact.delete
        format.json { render json: message_json("Contato removido com sucesso"), :status => :ok }
      elsif contact.nil?
        format.json { render json: message_json("Contato não encontrado para o cliente"), :status => 400 }
      elsif contact.errors.full_messages.present?
        format.json { render json: message_json(contact.errors.full_messages.join("; ")), :status => 400 }
      else
        format.json { render json: message_json("Erro inesperado. Não foi possível excluir o contato."), :status => 400 }
      end
    end
  end

  private
  
  def message_json message
    {:message => message}.to_json
  end
end