source "http://rubygems.org"
gemspec

gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem 'arel',      :git => 'git://github.com/rails/arel.git'
gem 'rack',      :git => 'git://github.com/rack/rack.git'
gem 'sprockets', :git => "git://github.com/sstephenson/sprockets.git"
gem 'mongoid',   :git => 'git://github.com/mongoid/mongoid.git'

gem 'bson_ext', '>= 1.3.0'
gem 'haml', '>= 3.1.0'
gem 'sass', '>= 3.1.0'
gem 'RedCloth', :require => 'redcloth'

# FIXME
#gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git'
gem 'formtastic', :path => '../formtastic'
gem 'scss', :path => '../scss'

# FIXME
gem 'santas-little-helpers', :path => '../santas-little-helpers'

if RUBY_VERSION < '1.9'
  gem "ruby-debug", ">= 0.10.3"
end

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
