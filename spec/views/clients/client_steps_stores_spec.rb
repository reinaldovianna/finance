require './spec/helpers/view_spec_helper.rb'

describe 'client/client_steps/stores', :type => :view do
  include ViewSpecHelper

  before do
    login

    visit clients_path
  end

  context 'Wizard' do
    before do
      page.find(:xpath, "//a[contains(@class, 'new-client')]").click

      @client = Client.first
    end

    context 'Stores' do
      before do
        visit client_stores_path({:id => @client.id})
        expect(page.find('.page-header h1')).to have_content("Adicionar lojas")
      end

      it 'should to do contein one store with status new for client' do
        expect(@client.stores.count).to eq(1)
        expect(@client.stores.last.status).to eq('new')
      end

      it 'should record store as active' do
        loja_nome = "Nome Loja"
        loja_email = "email@loja.com"
        loja_token = "Token Fake"

        within all('.content-store').last do
          fill_in "stores_#{@client.stores.last.id}_name", with: loja_nome
          fill_in "stores_#{@client.stores.last.id}_email", with: loja_email
          fill_in "stores_#{@client.stores.last.id}_token", with: loja_token
        end

        page.find(:xpath, "//input[contains(@class, 'client-step-submit')]").click

        expect(@client.stores.last.active?).to eq(true)
        expect(@client.stores.last.name).to eq(loja_nome)
        expect(@client.stores.last.email).to eq(loja_email)
        expect(@client.stores.last.token).to eq(loja_token)
      end

      it 'should record store as draft' do
        loja_email = "email@loja.com"
        loja_token = "Token Fake"

        within all('.content-store').last do
          fill_in "stores_#{@client.stores.last.id}_email", with: loja_email
          fill_in "stores_#{@client.stores.last.id}_token", with: loja_token
        end

        page.find(:xpath, "//input[contains(@class, 'client-step-submit')]").click

        expect(@client.stores.last.draft?).to eq(true)
        expect(@client.stores.last.email).to eq(loja_email)
        expect(@client.stores.last.token).to eq(loja_token)
      end

      it 'should add new record store with status new' do
        expect(@client.stores.count).to eq(1)

        within all('#content-stores').last do
          find(:xpath, "//a[contains(@id, 'add-store')]").click
        end
        
        expect(@client.stores.count).to eq(2)        
      end

      it 'should remove record stores with status new' do
        within '#content-stores' do
          find(:xpath, "//a[contains(@id, 'add-store')]").click
  
          expect(@client.stores.count).to eq(2)
          
          last_store = @client.stores.last

          within all('.content-store').last do
            find(:xpath, "//a[contains(@class, 'remove-store')]").click
            expect(@client.stores.count).to eq(1)
          end
        end
      end
    end
  end
end