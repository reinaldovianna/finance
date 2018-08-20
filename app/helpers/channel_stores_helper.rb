module ChannelStoresHelper

	def list_store channel_store
		store_list = Store.where({client_id: channel_store.client_id, :status => 'active'})

		store_list.map do |store| 
			[store.name, store.id]
		end
	end

  	def store_prompt_text list_stores
		list_stores.blank? ? 'Nenhuma loja conectada' : '-- Selecione --'
	end

	def list_marketplace
		@list_marketplace ||= Marketplace.all.map{|mkp| [mkp.name, mkp.id] }
	end
end