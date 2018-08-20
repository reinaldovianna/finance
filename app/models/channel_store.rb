class ChannelStore < ApplicationRecord
  belongs_to :cnpj
  belongs_to :store
  belongs_to :marketplace
  belongs_to :client
  belongs_to :table_tax

  has_and_belongs_to_many :bank_slips

  validates :client_id, :cnpj_id, :store_id, :marketplace_id, :table_tax_id, :monthly_payment, :order_payment, :payday, :additional_time_day, :additional_time_day_based, :presence => true, :if => :active?

  def active?
  	self.status == 'active'
  end

  def draft?
    self.status == 'draft'
  end

  def valid_fields?
  	old_status = self.status
  	self.status = 'active'

  	valid_fields = self.valid? && cnpj_valid? && !duplicate_name?

  	self.status = old_status
  	valid_fields
  end

  def cnpj_valid?
    old_status = self.status
    self.status = 'active'
    
    valid_cnpj = self.cnpj.valid?
    self.status = old_status
    
    valid_cnpj
  end

  def duplicate_name?
    other_channels.detect{|c| c.name == self.name }.present?
  end

  def other_channels
    self.client.channel_stores.select{|c| c.active? && c.id != self.id}
  end

  def name
    "#{self.store.name} - #{self.marketplace.name}" if self.store && self.marketplace
  end

  def self.fallback_client_params channel_hash, client
    channel_hash.merge!({:payday => client.payday,
                    :additional_time_day => client.additional_time_day,
                    :additional_time_day_based => client.additional_time_day_based
                   })
    channel_hash.merge!({:cnpj_id => client.cnpj.id}) if client.cnpj
    channel_hash
  end

  def has_bank_slip? revenue
    bank_slips.detect{|bs| bs.revenue.id == revenue.id}.present?
  end

  def additional_time_unabbreviated
    if self.additional_time_day > 1
      dia = 'dias'
      additional_time_day_based = self.additional_time_day_based.mb_chars.downcase.to_s
    else
      dia = 'dia'
      additional_time_day_based = 'corrido' if self.additional_time_day_based == 'Corridos'
      additional_time_day_based = 'útil' if self.additional_time_day_based == 'Úteis'
    end

    "#{self.additional_time_day} #{dia} #{additional_time_day_based}"
  end

  def date_payment
    (Date.current.beginning_of_month + 1.month).change(day: self.payday)
  end

  def additional_time_working_days?
    self.additional_time_day_based.parameterize == 'util'
  end

  def additional_time_date
    return date_payment if self.additional_time_day == 0

    add_time_day = self.additional_time_day
    @add_time_date = date_payment.dup

    loop do
      @add_time_date += 1.day
      add_time_day -= 1 if consider_date?(@add_time_date)
      break if add_time_day == 0
    end

    @add_time_date
  end

  def consider_date? date
    return true unless additional_time_working_days?
    working_days?(date)
  end

  def self.working_days? date
    (1..5).include?(date.wday)
  end
end