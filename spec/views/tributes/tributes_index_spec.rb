require './spec/helpers/view_spec_helper.rb'

describe "tributes/index", :type => :view do
  include ViewSpecHelper

  before do
    login
  end

  it "should list tributes" do
    visit tributes_path
    expect(page.find('.page-header h1')).to have_content("Tributos")
  end
    
end