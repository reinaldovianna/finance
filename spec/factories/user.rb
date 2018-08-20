FactoryGirl.define do
  factory :user, :class => 'User' do
  	id 1
  	first_name 'User Name'
  	last_name 'Last Name'
    email 'user@example.com'
    password '12345678'
    password_confirmation '12345678'
    sector 'ti'
  end
end