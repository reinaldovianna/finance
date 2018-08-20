FactoryGirl.define do
  factory :store do
    id 1
    name 'Reinaldo'
    email 'reinaldo@domain.com'
    token 'Ua39a3ee5e6b4b0d3255bfef95601890afd80709'
    status 'active'

    after(:create) do |store|
      store.client_id = FactoryGirl.create(:client).id unless store.client_id
      store.status = 'active'
    end
  end
end