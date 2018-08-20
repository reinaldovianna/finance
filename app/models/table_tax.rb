class TableTax < ApplicationRecord
	belongs_to :client

  has_many :channel_stores
  	
	validates :name, :row_ids, :presence => true, :if => :active?
  
  def active?
    self.status == 'active'
  end

  def draft?
    self.status == 'draft'
  end

  def is_global?
    self.table_scope.upcase == 'GLOBAL'
  end

  def rows
    TableTaxRow.where({"id" => self.row_ids}).to_a
  end

  def rules
    TaxRule.where({"id" => self.tax_rule_ids}).to_a
  end

  def rows_options
    rows.map{ |row| [row.row_name, row.id] }
  end

  def valid_fields?
  	old_status = self.status
  	self.status = 'active'

  	valid_fields = self.valid?

  	self.status = old_status
  	valid_fields
  end

  def channel_linked?
    self.client && self.client.taxes_by_channels.detect{|tax| tax.id == self.id }.present?
  end

  def remove_allowed?
    (self.client && !self.channel_linked?) ||
    !self.active?
  end
end