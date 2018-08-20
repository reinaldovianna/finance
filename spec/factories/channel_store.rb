FactoryGirl.define do
  factory :channel_store do
    id 1
    monthly_payment 100.50
    order_payment 1.99
    payday 5
    additional_time_day 3
    additional_time_day_based 'Úteis'

    after(:create) do |channel|
      channel.marketplace_id = FactoryGirl.create(:marketplace).id unless channel.marketplace_id
      channel.client_id = FactoryGirl.create(:client, client_id: channel.id ).id unless channel.client_id
      channel.cnpj_id = channel.client.cnpj.id unless channel.cnpj_id
      channel.store = FactoryGirl.create(:store, client_id: channel.id ).id unless channel.store_id
      channel.table_tax_id = FactoryGirl.create(:table_tax, client_id: channel.id ) unless channel.table_tax_id
      channel.status = 'active'
    end
  end
end