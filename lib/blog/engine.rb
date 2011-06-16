require "mongoid/slug"
require "redcloth"

module Blog
  class Engine < Rails::Engine
    isolate_namespace Blog

    config.generators do |g|
      g.orm             :mongoid
      g.template_engine :haml
      g.test_framework  :rspec
    end

    initializer "blog.include_main_app_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        require app.root + 'app/helpers/application_helper'
        include ApplicationHelper
      end
    end

  end
end
