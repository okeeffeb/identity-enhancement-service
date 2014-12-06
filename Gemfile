source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '~> 4.1.8'
gem 'sass-rails', '~> 4.0.3'
gem 'mysql2'
gem 'redis'
gem 'redis-rails'
gem 'audited-activerecord'
gem 'rapid-rack'
gem 'accession'
gem 'aaf-service-base', git: 'https://github.com/ausaccessfed/aaf-service-base',
                        branch: 'feature/email-message'
gem 'rails-assets-semantic-ui', '~> 1.0'
gem 'rails-assets-jquery', '~> 1.11'

gem 'unicorn', require: false
gem 'god', require: false

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'capybara'
  gem 'capybara-webkit'

  gem 'pry', require: false
  gem 'brakeman', '~> 2.6', require: false
  gem 'simplecov', require: false

  gem 'guard', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'guard-brakeman', require: false
  gem 'guard-unicorn', require: false, ref: 'ca5177dd',
                       github: 'andreimaxim/guard-unicorn'
  gem 'terminal-notifier-guard', require: false
end
