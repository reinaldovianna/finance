class Tribute

	def self.calc channel_store, sum_payment_base = []
		payment_base = channel_store.monthly_payment + sum_payment_base.sum
		
		channel_store.table_tax.rows.inject(payment_base) do |sum, row|
			if row.row_type == 'Provento'
				sum += measurement_calc(payment_base, row)
			elsif row.row_type == 'Desconto'
				sum -= measurement_calc(payment_base, row)
			end

			sum.round(2)
		end
	end

	def self.measurement_calc payment_base, row
		if row.row_measurement == '%'
			percent_of(payment_base, row.row_value)
		elsif row.row_measurement == 'R$'
			row.row_value 
		end
	end

	def self.percent_of base, percente
    base.to_f * (percente.to_f / 100.0)
	end
end