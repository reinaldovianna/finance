class ClientStepsController < ApplicationController
  include Wicked::Wizard
  
  helper_method :step_is_last?, :step_is_first?
  before_action :load_client, only: [:show, :update]

  steps :client, :stores, :channel_stores, :table_taxes
  
  def show
    remove_unsaved_instances
    init_step_objects
    render_wizard
  end

  def update
    update_objects

    render_wizard @client
  end

private
  def load_client
    begin
      @client = Client.find(session[:client_id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to clients_url
    end
  end

  def redirect_to_finish_wizard options = nil
    remove_unsaved_instances
    @client.verify_and_active

    if @client.all_valid?([:stores, :channel_stores]) && !has_invalid_table_tax_associated?
      flash[:success] = "Cadastro efetuado com sucesso."
      redirect_to client_path(@client.id)
    else
      flash[:danger] = "Erro de validação, verifique o preenchimento dos campos."
      redirect_to wizard_path(invalid_step)
    end
  end

  def invalid_step
    if !@client.cnpj_valid?
      @client_step = :client
    elsif @client.stores.blank? || @client.has_store_invalid?
      @client_step = :stores
    elsif @client.channel_stores.blank? || @client.has_channel_store_invalid?
      @client_step = :channel_stores
    elsif @client.table_taxes.blank? || @client.has_taxes_by_channels_invalid?
      @client_step = :table_taxes
    end

    @client_step
  end

  def has_invalid_table_tax_associated?
    @client.taxes_by_channels.present? && @client.has_taxes_by_channels_invalid?
  end

  def remove_unsaved_instances
    @client.stores.map{|store| store.destroy if store.status == 'new' }
    @client.channel_stores.map{|channel_store| channel_store.destroy if channel_store.status == 'new' }
    @client.table_taxes.map{|table_taxe| table_taxe.destroy if table_taxe.status == 'new' }
  end

  def init_step_objects
    case step
    when :client
      @client.cnpj ||= Cnpj.new
      @client.client_contacts << ClientContact.new if @client.client_contacts.blank?
    when :stores
      @client.stores << Store.create({:status => 'new'}) if @client.stores.blank?
    when :channel_stores
      channel_hash = {}
      ChannelStore.fallback_client_params(channel_hash, @client)
      channel_hash.merge!({:status => 'new'})

      @client.channel_stores << ChannelStore.create(channel_hash) if @client.channel_stores.blank?
    when :table_taxes
      @table_taxes_global = TableTax.where({:status => 'active', :table_scope => "GLOBAL"}).to_a
      @taxe_channels = @client.taxes_by_channels.present? ? @client.taxes_by_channels : [TableTax.create({:client_id => @client.id, :status => 'new'})]
      @client_taxes_list = @client.table_taxes.select{|table_tax| table_tax.status != 'new' }
      @client.table_taxes << TableTax.create({:status => 'new'}) if @client.table_taxes.blank?
    end

    @client.save
  end

  def update_objects
    query_params = {:client_id => @client.id}
    status_params = {:status => 'draft'}

    @client.status = 'draft' if @client.status == 'new'

    case step
    when :client
      @client.cnpj = Cnpj.where(cnpj_params.slice(:id)).first_or_initialize
      @client.cnpj.attributes = cnpj_params
      @client.cnpj.save

      upsert_attributes('client_contacts', query_params)

      @client.attributes = client_params
    when :stores
      upsert_attributes(step.to_s, query_params, status_params)
      @client.verify_and_active_object(:stores)
    when :channel_stores
      upsert_attributes(step.to_s, query_params, status_params)
      @client.verify_and_active_object(:channel_stores)
    when :table_taxes
      update_table_tax_channel
      @client.verify_and_active_object(:table_taxes)
    end

    @client.save
  end

  def upsert_attributes request_name, query_params = {}, status_params = {}
    self.send("#{request_name}_params").each do |id, request_params|
      current_object = request_name.classify.constantize.where({:id => id}.merge(query_params)).first_or_initialize
      update_attributes = request_params.permit(self.send("#{request_name}_permit"))
      update_attributes = update_attributes.merge(status_params) if status_params.present? && !current_object.active?
      current_object.attributes = update_attributes
      current_object.save
    end
  end

  def update_table_tax_channel
    table_tax = TableTax.where(table_tax_params.slice(:id)).first_or_initialize
    table_tax.attributes = table_tax_params.except(:id)

    if table_tax.row_ids.present? && table_tax_params[:name]
      table_tax.name = table_tax_params[:name]
      table_tax.client_id = @client.id
      table_tax.status = 'active'
      # update_table_tax_rules(table_tax)
      table_tax.save
      update_channel(table_tax)
    end
  end

  def update_table_tax_rules table_tax
    table_tax.tax_rules
  end

  def update_channel table_tax
    return if params[:channels].blank?

    channels = @client.channel_stores.select{ |channel| params[:channels].include?(channel.id.to_s)  }
    channels.each do |channel|
      channel.table_tax_id = table_tax.id
      channel.save
    end
  end

  def client_permit
    [
      :monthly_payment,
      :payday,
      :additional_time_day,
      :additional_time_day_based
    ]
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

  def client_contacts_permit
    [
      :name,
      :email,
      :phone
    ]
  end

  def channel_stores_permit
    [
      :client_id,
      :cnpj_id,
      :store_id,
      :marketplace_id,
      :monthly_payment,
      :order_payment,
      :payday,
      :additional_time_day,
      :additional_time_day_based
    ]
  end

  def stores_permit
    [
      :name,
      :email,
      :token
    ]
  end

  def table_taxes_permit
    [
      :id,
      :name,
      {:row_ids => []}
    ]
  end

  def table_tax_rules_permit
    [
      {:row_ids => []}
    ]
  end


  def client_contacts_params
    params.require(:client_contacts)
  end

  def stores_params
    params.require(:stores)
  end

  def channel_stores_params
    params.require(:channel_stores)
  end

  def table_tax_params
    params.require(:table_tax).permit(table_taxes_permit)
  end

  def table_tax_rules_params
    params.require(:table_tax_rules).permit(table_tax_rules_permit)
  end

  def cnpj_params
    params.require(:cnpj).permit(cnpj_permit)
  end
  
  def client_params
    params.require(:client).permit(client_permit)
  end
  
  def step_is_last?
    steps.last == step
  end

  def step_is_first?
    steps.first == step
  end
end