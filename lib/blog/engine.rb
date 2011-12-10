require "redcloth"

module Blog
  class Engine < Rails::Engine
    isolate_namespace Blog

    config.generators do |g|
      g.orm             :mongoid
      g.template_engine :haml
      g.test_framework  :rspec
    end

    # On the other hand, the engine should be able to use at least
    # some of the main app's helpers to ensure basic support for
    # rendering a single layout for both.

    initializer "blog.include_main_app_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        require app.root + 'app/helpers/application_helper'
        include ApplicationHelper
      end
    end

    # The main app should be able to use the engine's helpers.

    initializer "blog.grant_helper_access" do |app|
      ActiveSupport.on_load(:action_controller) do
        helper Blog::Engine.helpers
      end
    end

    initializer "blog.mongoid.install_observers" do |app|
      app.config.mongoid.observers = 'blog/post_sweeper'
    end

  end
end
