require "active_support/configurable"
require "action_controller/caching"

module Blog
  class PostSweeper < Mongoid::Observer
    include ActiveSupport::Configurable
    include ActionController::Caching

    self.page_cache_directory   = Rails.application.config.action_controller.page_cache_directory
    self.page_cache_directory ||= ''

    self.page_cache_extension   = Rails.application.config.action_controller.page_cache_extension
    self.page_cache_extension ||= '.html'

    observe "blog/post"

    def after_create(post)
      sweep(post)
    end

    def after_update(post)
      sweep(post)
    end

    def after_destroy(post)
      sweep(post)
    end

    private # ----------------------------------------------

    def blog
      Blog::Engine.routes.url_helpers
    end

    def sweep(post)
      expire_page blog.root_path
      expire_page blog.archive_path
      expire_page blog.slug_path(slug: post.slug)

      # TODO What if post went offline?
      if post.published_at
        year  = post.published_at.year.to_s
        month = post.published_at.month.to_s.rjust(2, "0")

        expire_page blog.posts_by_date_path(year: year)
        expire_page blog.posts_by_date_path(year: year, month: month)
      end

      # TODO What if tags got removed?
      post.tags.each do |tag|
        expire_page blog.posts_by_tag_path(slug: tag.slug)
      end

      %w(rss atom).each do |fmt|
        expire_page blog.feed_path(format: fmt)
      end

      ActiveSupport::Notifications.publish("blog.sweep_cache", post)
    end

  end
end
