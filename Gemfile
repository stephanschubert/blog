source "http://rubygems.org"
gemspec

gem 'sprockets',    '~> 2.0'
gem 'rack',         '~> 1.3.0'
gem 'rails',        '~> 3.1'

gem 'mongoid',      '~> 2.4.3' # git: 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext',     '>= 1.3.0'

gem 'haml',         git: 'git://github.com/nex3/haml.git'
gem 'sass',         '~> 3.1.10'
gem 'jquery-rails', git: 'git://github.com/rails/jquery-rails.git'

gem 'RedCloth',     require: 'redcloth'
gem 'formtastic',   git: 'git://github.com/justinfrench/formtastic.git'

if `hostname` =~ /local/
  gem 'scss', require: "scss", path: '../scss'
  gem 'santas-little-helpers', path: '../santas-little-helpers'
  gem 'mongoid-plugins', require: "mongoid-plugins", path: '../mongoid-plugins'
else
  gem 'scss', require: "scss", git: 'git@github.com:jazen/scss.git'
  gem 'santas-little-helpers', git: 'git@github.com:jazen/santas-little-helpers.git'
  gem 'mongoid-plugins', require: "mongoid-plugins", git: 'git://github.com/jazen/mongoid-plugins.git'
end

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

group :test, :development do
  gem 'database_cleaner', '>= 0.6.6'

  gem 'rspec', '>= 2.5.0'
  gem 'rspec-rails', '>= 2.5.0'
  gem 'mongoid-rspec', '>= 1.4.1' # :git => 'git://github.com/evansagge/mongoid-rspec.git'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'

  gem 'fabrication'
  gem 'timecop', '>= 0.3.5'

  # Blazin' fast, continous testing
  gem 'watchr'
  gem 'spork', '0.9.0.rc4'
end
