source 'http://rubygems.org'

ruby "2.3.3"

gem 'rails', '~> 5.0.0.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'pg', '0.18.4'
gem 'puma', '~> 3.0'

gem 'devise', '4.2.0'
gem 'rails_admin', '~> 1.0'
gem 'kaminari'

gem 'bootstrap', '~> 4.0.0.alpha4'
gem 'jasny-bootstrap-rails'
gem 'chosen-rails'

gem 'wicked', '1.3.1'

gem 'will_paginate-bootstrap'

gem 'holidays', '5.3.0'

gem 'whenever', :require => false

group :development, :test do
  gem 'byebug', platform: :mri
	gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara', '~> 2.11'
  gem 'selenium-webdriver', '~> 3.0.3'
  gem "factory_girl_rails", '~> 4.8'
end

group :production do
	gem 'rails_serve_static_assets'
	gem 'rails_stdout_logging'
  gem 'puma_worker_killer'
  gem 'newrelic_rpm'
  gem 'scout_apm', '~> 2.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]