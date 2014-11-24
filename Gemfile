source 'https://rubygems.org'

gem 'rails', '~> 4.1.8'
gem 'mysql2'
gem 'redis'
gem 'redis-rails'
gem 'audited-activerecord'
gem 'rapid-rack'
gem 'accession'

gem 'unicorn', require: false
gem 'god', require: false

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'timecop'

  gem 'pry', require: false
  gem 'brakeman', '~> 2.6', require: false
  gem 'simplecov', require: false

  gem 'guard', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'guard-brakeman', require: false
  gem 'terminal-notifier-guard', require: false
end
