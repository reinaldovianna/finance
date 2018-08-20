class TableTaxRow < ApplicationRecord

  def self.row_type_options
  	['Provento','Desconto']
  end

  def self.row_measurement_options
  	[['( % ) Porcentagem', '%'],['( R$ ) Monetário', 'R$']]
  end
end
