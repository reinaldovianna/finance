FactoryGirl.define do
  factory :table_tax do
    id 1
    name 'Simples nacional'

    after(:create) do |tax|
      tax.row_ids = [FactoryGirl.create(:table_tax_row).id] if tax.row_ids.blank?
      tax.status = 'active'
    end
  end

	factory :table_tax_row do
  	id 1
  	row_type 'Provento'
  	row_name 'COFINS'
  	row_measurement '%'
  	row_value 5.5
  end
end