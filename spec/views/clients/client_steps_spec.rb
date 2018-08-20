require './spec/helpers/view_spec_helper.rb'

describe 'client/client_steps', :type => :view do
  include ViewSpecHelper

  before do
    login

    visit clients_path
  end

  it { expect(page.find('.page-header h1')).to have_content("Clientes") }
  
  it { expect(Client.count).to eq(0) }

  context 'Wizard' do
    before do
      page.find(:xpath, "//a[contains(@class, 'new-client')]").click
    end

    it { expect(page.find('.page-header h1')).to have_content("Adicionar novo cliente") }
    
    it { expect(Client.count).to eq(1) }

    it 'should navegate between steps skiping validation' do
      page.find(:xpath, "//a[contains(@class, 'skip-next')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar lojas")

      page.find(:xpath, "//a[contains(@class, 'skip-next')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar canais")

      page.find(:xpath, "//a[contains(@class, 'skip-next')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar tabela de tributos")

      page.find(:xpath, "//a[contains(@class, 'skip-pred')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar canais")

      page.find(:xpath, "//a[contains(@class, 'skip-pred')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar lojas")

      page.find(:xpath, "//a[contains(@class, 'skip-pred')]").click
      expect(page.find('.page-header h1')).to have_content("Adicionar novo cliente")
    end
  end
end