require './spec/helpers/view_spec_helper.rb'

describe "client/index", :type => :view do
  include ViewSpecHelper

  before do
    login
  end

  it "should list clients" do
    visit clients_path
    expect(page.find('.page-header h1')).to have_content("Clientes")
  end
    
end