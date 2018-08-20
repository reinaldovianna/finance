module TributesHelper

  def channel_by_tribute client, tribute
    client.channel_stores.map{|c| c if c.active? && c.table_tax_id == tribute.id}
    					 .compact.sort_by{|c| c.cnpj.vat_number }
    					 .group_by{|c| c.cnpj.vat_number }
  end
end