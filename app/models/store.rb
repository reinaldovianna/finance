class Store < ApplicationRecord
  belongs_to :client

  validates :name, :email, :token, :presence => true, :if => :active?
  
  before_destroy :removal_enabled?
  
  def active?
    self.status == 'active'
  end

  def draft?
  	self.status == 'draft'
  end

  def removal_enabled?
    self.client.channel_stores.detect{|c| c.store && c.store.id == self.id}.blank?
  end

  def valid_fields?
  	old_status = self.status
  	self.status = 'active'

  	valid_fields = self.valid?

  	self.status = old_status
  	valid_fields
  end
end
