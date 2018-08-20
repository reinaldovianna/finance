FactoryGirl.define do
  factory :cnpj do
		id 1
    vat_number '126.456.789-10'
    company_name 'Razão social'
    trading_name 'Nome fantasia'
    street_address 'Rua Urapuru'
    number_address '120'
    detail_address 'bloco A'
    cep_address '25070-080'
    neighborhood_address ''
    city_address 'Duque de Caxias'
    uf_address 'RJ'
    email 'reinaldo@domain.com'
    phone '(21)999999999'
  end
end