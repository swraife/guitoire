source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.1.0'

gem 'aasm'
gem 'active_model_serializers'
gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on'
gem 'annotate'
gem 'autoprefixer-rails'
gem 'aws-sdk', '~> 2'
gem 'cancancan'
gem 'devise', github: 'plataformatec/devise'
gem 'featherlight'
gem 'flutie'
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'
gem 'haml', git: 'https://github.com/haml/haml'
gem 'hopscotch-rails'
gem 'jquery-fileupload-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari', '~> 0.17'
gem 'normalize-rails', '~> 3.0.0'
gem 'paperclip'
gem 'pg'
gem 'pg_search'
gem 'public_activity'
gem 'puma'
gem 'rack-canonical-host'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails'
gem 'sendgrid-ruby'
gem 'sprockets', '>= 3.0.0'
gem 'title'
gem 'uglifier'
gem 'webpacker'
gem 'youtube_rails'

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet', '~> 5.5.1'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails', github: 'bkeepers/dotenv'
  gem 'factory_girl_rails'
  gem 'guard-rails', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5.0.beta4'
end

group :development, :staging do
  gem 'rack-mini-profiler', require: false
end

group :test do
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

gem 'high_voltage'
gem 'bourbon', '~> 5.0.0.beta.7'
gem 'neat', '~> 2.0.0.beta.1'
gem 'refills', group: [:development, :test]