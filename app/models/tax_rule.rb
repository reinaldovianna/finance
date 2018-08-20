class TaxRule < ApplicationRecord
	belongs_to :table_tax

	def self.operator_options
		['>','<','=','>=','<=','><']
	end

	def self.measurement_options
		['R$', '%']
	end

	def rows
		TableTaxRow.where({"id" => self.row_ids}).to_a
	end
end