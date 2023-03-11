source 'https://rubygems.org'

gem 'bundler', '~> 2.4'
gem 'rake'

group :test do
  gem 'database_cleaner-active_record'
  gem 'rspec', '~> 3.10'
  gem 'simplecov', '~> 0.22', require: false
  gem 'timecop', '~> 0.9.6'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rails', '~> 7.0'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop', '~> 1.48'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'sqlite3'
end

# Specify your gem's dependencies in simple-metric.gemspec
gemspec
