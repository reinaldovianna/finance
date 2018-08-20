class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!
  protect_from_forgery with: :exception, prepend: true

  def health
  	render text: 'ok', status: 200
  end

  def search_params
    params.permit(:is_search, :trading_name, :company_name, :vat_number, :store_id, :marketplace_id)
  end
end
