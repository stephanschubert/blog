source "http://rubygems.org"
gemspec

gem 'sprockets', '= 2.0.0.beta.10'
gem 'rack', '= 1.3.0'
gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mongoid',   :git => 'git://github.com/mongoid/mongoid.git'
gem 'jquery-rails', :git => 'git://github.com/rails/jquery-rails.git'

gem 'bson_ext', '>= 1.3.0'
gem 'haml', :git => 'git://github.com/nex3/haml.git'

gem 'sass', :git => 'git://github.com/nex3/sass.git'
gem 'sass-rails', :git => 'git://github.com/rails/sass-rails.git'

gem 'RedCloth', :require => 'redcloth'

# FIXME
#gem 'formtastic', :path => '../formtastic'
#gem 'scss', :require => "scss", :path => '../scss'
#gem 'santas-little-helpers', :path => '../santas-little-helpers'

gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git'
gem 'scss', :require => "scss", :git => 'git@github.com:jazen/scss.git'
gem 'santas-little-helpers', :git => 'git@github.com:jazen/santas-little-helpers.git'

group :test, :development do
  gem 'database_cleaner', '>= 0.6.6'

  gem 'rspec', '>= 2.5.0'
  gem 'rspec-rails', '>= 2.5.0'
  gem 'mongoid-rspec', :git => 'git://github.com/evansagge/mongoid-rspec.git'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'

  gem 'fabrication'
  gem 'timecop', '>= 0.3.5'

  # Blazin' fast, continous testing
  gem 'watchr'
  gem 'spork', '0.9.0.rc4'
end
