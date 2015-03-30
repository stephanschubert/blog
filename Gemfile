source "http://rubygems.org"
gemspec

gem 'sprockets'
gem 'rack'
gem 'rails', '~> 3.2'
gem 'mongoid'
gem 'bson_ext'
gem 'haml'
gem 'haml-rails'
gem 'sass'
gem 'jquery-rails'
gem 'RedCloth', require: 'redcloth'
gem 'formtastic'
gem 'will_paginate_mongoid'

#if `hostname` =~ /local/
#  gem 'scss', require: "scss", path: '../scss'
#  gem 'santas-little-helpers', path: '../santas-little-helpers'
#  gem 'mongoid-plugins', require: "mongoid-plugins", path: '../mongoid-plugins'
#else
  gem 'scss', require: "scss", git: 'git@github.com:jazen/scss'
  gem 'santas-little-helpers', git: 'git@github.com:jazen/santas-little-helpers'
  gem 'mongoid-plugins', require: "mongoid-plugins", git: 'git@github.com:jazen/mongoid-plugins'
#end

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

group :test, :development do
  # TODO. Use 1.3 series because 1.4 got an issue with mongoid/truncation strategy.
  gem 'database_cleaner', '~> 1.3.0'
  gem 'fivemat'
  gem 'pry-rails'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'test-unit', '~> 3.0'
  gem 'mongoid-rspec'
  gem 'capybara'

  gem 'fabrication'
  gem 'timecop'

  # Blazin' fast, continous testing
  gem 'watchr'
  gem 'spork'
end
