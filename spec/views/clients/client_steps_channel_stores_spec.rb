require './spec/helpers/view_spec_helper.rb'

describe 'client/client_steps/channel_stores', :type => :view do
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

    context 'Channel Stores' do
      before do
        visit client_channel_stores_path({:id => @client.id})
        expect(page.find('.page-header h1')).to have_content("Adicionar canais")
      end

      it 'should to do contein one channel store with status new for client' do
        expect(@client.channel_stores.count).to eq(1)
        expect(@client.channel_stores.last.status).to eq('new')
      end

      it 'should record channel store as active' do
        cnpj_id = @client.cnpj_id
        store_id = Store.create.id
        marketplace_id = Marketplace.create({:name => 'B2W'}).id
        monthly_payment = 100.99
        order_payment = 1.99
        payday = 5
        additional_time_day = 10
        additional_time_day_based = 'Úteis'

        within all('.content-channel-store').last do
          # fill_in "channel_stores_#{@client.channel_stores.last.id}_cnpj_id", with: cnpj_id
          # fill_in "channel_stores_#{@client.channel_stores.last.id}_store_id", with: store_id
          # fill_in "channel_stores_#{@client.channel_stores.last.id}_marketplace_id", with: marketplace_id
          fill_in "channel_stores_#{@client.channel_stores.last.id}_monthly_payment", with: monthly_payment
          fill_in "channel_stores_#{@client.channel_stores.last.id}_order_payment", with: order_payment
          fill_in "channel_stores_#{@client.channel_stores.last.id}_payday", with: payday
          fill_in "channel_stores_#{@client.channel_stores.last.id}_additional_time_day", with: additional_time_day
          fill_in "channel_stores_#{@client.channel_stores.last.id}_additional_time_day_based", with: additional_time_day_based
        end

        page.find(:xpath, "//input[contains(@class, 'client-step-submit')]").click

        expect(@client.channel_stores.last.active?).to eq(true)
        # expect(@client.channel_stores.last.name).to eq(loja_nome)
        # expect(@client.channel_stores.last.email).to eq(loja_email)
        # expect(@client.channel_stores.last.token).to eq(loja_token)
      end

      it 'should record store as draft' do
        loja_email = "email@loja.com"
        loja_token = "Token Fake"

        within all('.content-channel-store').last do
          fill_in "channel_stores_#{@client.channel_stores.last.id}_email", with: loja_email
          fill_in "channel_stores_#{@client.channel_stores.last.id}_token", with: loja_token
        end

        page.find(:xpath, "//input[contains(@class, 'client-step-submit')]").click

        expect(@client.channel_stores.last.draft?).to eq(true)
        expect(@client.channel_stores.last.email).to eq(loja_email)
        expect(@client.channel_stores.last.token).to eq(loja_token)
      end

      it 'should add new record store with status new' do
        expect(@client.channel_stores.count).to eq(1)

        within all('#content-channel-stores').last do
          find(:xpath, "//a[contains(@id, 'add-channel-store')]").click
        end
        
        expect(@client.channel_stores.count).to eq(2)        
      end

      it 'should remove record channel_stores with status new' do
        within '#content-channel-stores' do
          find(:xpath, "//a[contains(@id, 'add-channel-store')]").click
  
          expect(@client.channel_stores.count).to eq(2)
          
          last_store = @client.channel_stores.last

          within all('.content-channel-store').last do
            find(:xpath, "//a[contains(@class, 'remove-channel-store')]").click
            expect(@client.channel_stores.count).to eq(1)
          end
        end
      end
    end
  end
end