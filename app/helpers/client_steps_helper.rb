module ClientStepsHelper

  def step_default_class
    "col-xs-3 bs-wizard-step"
  end

  def default_a 
    "bs-wizard-dot"
  end

  def a_current step_cur
    "-current" if step == step_cur
  end

  def list_channels client
		client.channel_stores.map do |channel|
			next if channel.name.blank?
			["#{channel.cnpj.vat_number} | #{channel.name}", channel.id]
		end.compact
  end

  def status_object object
    case object.status.downcase
    when 'new'
      'NOVO'
    when 'draft'
      'RASCUNHO'
    when 'active'
      'ATIVO'
    end
  end

  def status_label_class object
    case object.status.downcase
    when 'new'
      'label-default'
    when 'draft'
      'label-warning'
    when 'active'
      'label-success'
    end
  end
  
  def selected_channels client, table_tax
    return [client.channel_stores.first.id] if client.channel_stores.count == 1
    
		client.channel_stores.map do |channel|
			channel.id if channel.table_tax_id == table_tax.id
		end.compact
  end

  def channel_tax_selected(table_tax)
    table_tax.name.present? ? table_tax.name : 'Selecione a tabela de tributos'
  end
end