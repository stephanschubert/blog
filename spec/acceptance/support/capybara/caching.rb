# TODO I have no fucking idea how to temporarily activate Rails' caching
#
# RSpec.configure do |c|

#   c.before :each do
#     if example.metadata[:caching]
#       cache_dir = (Rails.root + "public/cache").to_s

#       Dummy::Application.configure do
#         config.action_controller.perform_caching = true
#         config.action_controller.page_cache_directory = cache_dir
#       end

# #      Rails.application.config.action_controller.perform_caching = true
# #      Rails.application.config.action_controller.page_cache_directory = cache_dir
#     end
#   end

#   c.after :each do
#     if example.metadata[:caching]
#       cache_dir = (Rails.root + "public/cache").to_s
#       Rails.application.config.action_controller.perform_caching = false
# #      `rm -rf #{cache_dir}`
#     end
#   end

# end

# RSpec.configure do |c|

#   c.around :each do |example|
#     # begin
#     #   caching   = example.metadata[:caching]
#     #   cache_dir = (Rails.root + "public/cache").to_s

#     #   if caching
#     #     Rails.configuration.action_controller.perform_caching = true
#     #     Rails.configuration.action_controller.page_cache_directory = cache_dir
#     #   end

#     #   example.run
#     # ensure
#     #   Rails.configuration.action_controller.perform_caching = false
#     #   #`rm -rf #{cache_dir}`
#     # end

#     Capybara.enable_caching(example.metadata[:caching]) { example }
#   end

# end

# module Capybara

#   def self.enable_caching(caching)
#     cache_dir = (Rails.root + "public/cache").to_s

#     if caching
#       Rails.configuration.action_controller.perform_caching = true
#       Rails.configuration.action_controller.page_cache_directory = cache_dir
#     end

#     yield
#   ensure
#     Rails.configuration.action_controller.perform_caching = false
#     `rm -rf #{cache_dir}`
#   end

# end
