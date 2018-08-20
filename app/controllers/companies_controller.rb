class CompaniesController < ApplicationController

	def new
		@company = Company.new
		@company.cnpj = Cnpj.new
	end

	def edit
		@company = Company.first
	end

	def create
		cnpj = Cnpj.where(cnpj_params.slice(:id)).first_or_initialize
		cnpj.attributes = cnpj_params
		cnpj.save

		company = Company.where(company_params).first_or_initialize
		company.cnpj_id = cnpj.id
		
		if company.save
			flash[:success] = "Cadastro efetuado com sucesso."
      redirect_to clients_path
		else
			flash[:danger] = "Erro de validação, verifique o preenchimento dos campos."
      redirect_to edit_companies_path
		end
	end	

	def update
		cnpj = Cnpj.where(cnpj_params.slice(:id)).first_or_initialize
		cnpj.attributes = cnpj_params
		cnpj.save

		company = Company.where(company_params).first_or_initialize
		company.cnpj_id = cnpj.id
		
		if company.save
			flash[:success] = "Cadastro efetuado com sucesso."
      redirect_to clients_path
		else
			flash[:danger] = "Erro de validação, verifique o preenchimento dos campos."
      redirect_to edit_companies_path
		end
	end

	def cnpj_permit
    [
      :id,
      :vat_number,
      :company_name,
      :trading_name,
      :street_address,
      :number_address,
      :detail_address,
      :cep_address,
      :neighborhood_address,
      :city_address,
      :uf_address,
      :email,
      :phone
    ]
  end

  def cnpj_params
    params.require(:cnpj).permit(cnpj_permit)
  end

  def company_params
  	params.require(:company).permit(:id)
  end
end
