require './spec/helpers/view_spec_helper.rb'

describe "sign_in", :type => :view do
  include ViewSpecHelper

  it "should to do sign_in" do
    password = "123456789"
    u = create( :user, password: password, password_confirmation: password )

    visit new_user_session_path

    within "#new_user" do
      fill_in "user_email", with: u.email
      fill_in "user_password", with: password
    end

    click_button "Entrar"

    expect(page.find('.alert-info')).to have_content("Info! Signed in successfully.")
  end
end