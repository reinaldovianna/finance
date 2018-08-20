Rails.application.routes.draw do
  get '/health', to: 'application#health'

  mount RailsAdmin::Engine => '/admins', as: 'rails_admin'
  devise_for :admin, except: [:new]
  
  devise_for :users

  root to: 'clients#index'

  resources :tributes
  resources :companies
  resources :settings

  resources :revenues
  resources :revenues

  get "revenue/:id/start" => 'revenues#start', :as => :revenues_start
  
  resources :clients, only: [:index, :create, :edit, :show]
  get "client/:id/add_store" => 'clients#add_store', :as => :client_add_store
  get "client/:id/add_channel_store" => 'clients#add_channel_store', :as => :client_add_channel_store
  get "client/:id/add_table_tax" => 'clients#add_table_tax', :as => :client_add_table_tax
  get "client/:id/add_contact" => 'clients#add_contact', :as => :client_add_contact
  get "client/:id/remove_store/:store_id" => 'clients#remove_store', :as => :client_remove_store
  get "client/:id/remove_channel_store/:channel_id" => 'clients#remove_channel_store', :as => :client_remove_channel_store
  get "client/:id/remove_table_tax/:table_tax_id" => 'clients#remove_table_tax', :as => :client_remove_table_tax
  get "client/:id/remove_contact/:contact_id" => 'clients#remove_contact', :as => :client_remove_contact

  get "client/:id/stores" => 'clients#stores', :as => :client_stores
  get "client/:id/channel_stores" => 'clients#channel_stores', :as => :client_channel_stores
  get "client/:id/table_taxes" => 'clients#table_taxes', :as => :client_table_taxes

  resources :pendencies, except: [:show]
  get "pendencies/clients" => 'pendencies#clients', :as => :pendencies_client

  resources :client_steps

  resources :cnpjs, :only => ['new', 'create']
  get "cnpjs/new_cnpj" => 'cnpjs#new_cnpj', :as => :new_cnpj_modal
  get "cnpjs/edit_cnpj/:id" => 'cnpjs#edit_cnpj', :as => :edit_cnpj_modal
  get "cnpjs/edit_cnpj_partial/:id" => 'cnpjs#edit_cnpj_partial', :as => :edit_cnpj_partial

  resources :stores, :only => ['new', 'create', 'edit']

  resources :channel_stores, :only => ['new', 'create']

  resources :table_taxes, :only => ['new', 'create']
  get "table_taxes/new_table_tax" => 'table_taxes#new_table_tax', :as => :new_table_tax_modal
  get "table_taxes/clone_table_tax/:id" => 'table_taxes#clone_table_tax', :as => :clone_table_tax
  get "table_taxes/show_table_tax/:id" => 'table_taxes#show_table_tax', :as => :show_table_tax
  post "table_taxes/create_row" => 'table_taxes#create_row', :as => :create_row
  post "table_taxes/remove_row" => 'table_taxes#remove_row', :as => :remove_row  
  post "table_taxes/create_rule" => 'table_taxes#create_rule', :as => :create_rule
  post "table_taxes/remove_rule" => 'table_taxes#remove_rule', :as => :remove_rule
  post "table_taxes/remove_unsaved_instance" => 'table_taxes#remove_unsaved_instance', :as => :remove_unsaved_instance
end
