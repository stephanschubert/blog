module Blog
  module PostsHelper

    def link_to_post(post, options = {})
      backend = options.pluck(:backend)

      options.reverse_merge! \
      :text => post.title,
      :url  => backend ? blog.backend_post_path(post) : blog.post_path(post)

      text, url = options.pluck(:text, :url)

      link_to text, url, options
    end

  end
end
