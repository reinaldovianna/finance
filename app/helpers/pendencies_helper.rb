module PendenciesHelper

	def replace_if_null(value)
		value.present? ? value : "Não informado"
	end

	def list_pendencies(client)
		list_pendency = []
		list_pendency << {:path => edit_client_path(client.id), :step => 'Cadastrar CNPJ'} if !client.cnpj_valid?
		list_pendency << {:path => client_stores_path(client.id), :step => 'Cadastrar lojas'} if client.stores.blank? || client.has_store_invalid?
		list_pendency << {:path => client_channel_stores_path(client.id), :step => 'Cadastrar canais'} if client.channel_stores.blank? || client.has_channel_store_invalid?
		list_pendency << {:path => client_table_taxes_path(client.id), :step => 'Associar tributos'} if client.table_taxes.blank? || client.has_taxes_by_channels_invalid?
		list_pendency
	end
end
