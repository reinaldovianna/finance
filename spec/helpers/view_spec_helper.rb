require 'rails_helper'

module ViewSpecHelper
  def login
  	password = "123456789"
    u = create( :user, password: password, password_confirmation: password )

    visit new_user_session_path

    within "#new_user" do
      fill_in "user_email", with: u.email
      fill_in "user_password", with: password
    end

    click_button "Entrar"
  end
end