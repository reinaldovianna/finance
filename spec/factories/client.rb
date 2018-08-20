FactoryGirl.define do
  factory :client do
    status 'active'
    id 1

    after(:create) do |cli|
      cnpj = FactoryGirl.create(:cnpj)
      cli.cnpj = cnpj
      
      store = FactoryGirl.create(:store, client_id: cli.id )
      cli.stores = [store]

      channel_store = FactoryGirl.create(:channel_store, client_id: cli.id, store_id: store.id, cnpj_id: cnpj.id )
      cli.channel_stores = [channel_store]
    end
  end
end