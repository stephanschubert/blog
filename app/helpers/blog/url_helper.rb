module Blog
  module UrlHelper

    def parameters_for_post_path(post, options = {})
      options.reverse_merge! \
      :year  => post.published_at.year.to_s,
      :month => post.published_at.month.to_s.rjust(2, '0'),
      :id    => post.to_param
    end

    def public_post_path(post, options = {})
      main_app.slug_path(post)
    rescue
      blog.post_path parameters_for_post_path(post, options)
    end

    def public_post_url(post, options = {})
      main_app.slug_url(post)
    rescue
      blog.post_url parameters_for_post_path(post, options)
    end

    def public_tag_path(tag, options = {})
      main_app.slug_path(tag)
    rescue
      blog.posts_by_tag_path(tag, options)
    end

    def public_tag_url(tag, options = {})
      main_app.slug_url(tag)
    rescue
      blog.posts_by_tag_url(tag, options)
    end

  end
end