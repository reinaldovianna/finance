module ClientsHelper

  def active_stores client
    client.stores.select{|store| store.active? && client.channel_stores.find{|c| c.store.id == store.id}.present? }
  end

  def marketplaces_by_store client, store 
    client.channel_stores.map do |channel|
        next unless channel.active?
        if channel.marketplace && channel.store_id == store.id
            channel.marketplace
        end
    end.compact
  end

  def marketplace_list
    Marketplace.all.map do |marketplace|
      [marketplace.name, marketplace.id]
    end
  end
end
