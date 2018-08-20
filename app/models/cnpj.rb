class Cnpj < ApplicationRecord
  has_one :client
  has_one :channel_store

  validates :vat_number, :company_name, :trading_name, :street_address, :number_address, :detail_address, :cep_address, :neighborhood_address, :city_address, :uf_address, :email, :phone, :presence => true, :if => :validate_fields?

  def validate_fields?
  	(client.present? && client.active?) || (channel_store.present? && channel_store.active?)
  end
end