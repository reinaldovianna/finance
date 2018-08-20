class Client < ApplicationRecord
  belongs_to :cnpj
  has_many :channel_stores, :dependent => :destroy
  has_many :stores, :dependent => :destroy
  has_many :table_taxes, :dependent => :destroy
  has_many :client_contacts

  def taxes_by_channels
  	table_taxes.select{|tax| channel_stores.map(&:table_tax_id).include?(tax.id) }
  end

  def active?
  	self.status == 'active'
  end

  def draft?
    self.status == 'draft'
  end

  def self.search(search_params)
    if search_params[:is_search]
      joins(:cnpj).where("cnpjs.trading_name LIKE '%#{search_params[:trading_name]}%' AND cnpjs.company_name LIKE '%#{search_params[:company_name]}%' AND cnpjs.vat_number LIKE '%#{search_params[:vat_number]}%'")
    else
      all
    end
  end

  def fill_search_query params

  end
  
  def cnpj_valid?
    old_status = self.status
    self.status = 'active'
    
    valid_cnpj = self.cnpj.valid?
    self.status = old_status
    
    valid_cnpj
  end

  def has_store_valid?
    self.stores.detect{|store| store.valid_fields? }.present?
  end

  def has_channel_store_valid?
    self.channel_stores.detect{|channel_store| channel_store.valid_fields? }.present?
  end

  def has_table_taxe_valid?
    self.table_taxes.detect{|table_taxe| table_taxe.valid_fields? }.present?
  end

  def has_store_invalid?
    self.stores.detect{|store| !store.valid_fields? }.present?
  end

  def has_channel_store_invalid?
    self.channel_stores.detect{|channel_store| !channel_store.valid_fields? }.present?
  end

  def has_taxes_by_channels_invalid?
    self.taxes_by_channels.detect{|table_taxe| !table_taxe.valid_fields? }.present?
  end

  def has_object_blank?
    self.stores.blank? || self.channel_stores.blank? || self.table_taxes.blank?
  end

  def has_invalid_object?
    !cnpj_valid? || has_store_invalid? || has_channel_store_invalid? || has_taxes_by_channels_invalid?
  end

  def verify_and_active
    return true if self.status == 'active'

    self.reload

    if cnpj_valid? && has_store_valid? && has_channel_store_valid? && has_table_taxe_valid?
      self.status = 'active'
      self.save
    end
  end

  def verify_and_active_object(string_object)
    self.send(string_object).each do |object|
      if object.status != 'active'
        object.status = 'active'
        object.save
      end
    end
  end

  def all_valid? objects = [:stores, :channel_stores, :table_taxes]
    cnpj_valid? && objects.map{|obj_str| self.send(obj_str).present? && all_valid_object?(obj_str)}.all?
  end

  def all_valid_object?(string_object)
    self.send(string_object).map{|object| object.valid_fields? }.all?
  end

  def self.pending
    Client.all.select do |client|
                  ['draft', 'active'].include?(client.status) &&
                  (client.has_object_blank? || client.has_invalid_object?)
                end
  end

  def self.find_by_cnpj cnpj
    client = Client.find_by({:cnpj_id => cnpj.id})
    client = ChannelStore.find_by({:cnpj_id => cnpj.id}).client unless client
    client
  end
end