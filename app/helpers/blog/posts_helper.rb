module Blog
  module PostsHelper

    def link_to_post(post, options = {})
      options.reverse_merge! \
      :text => post.title,
      :url  => blog.backend_post_path(post)

      link_to options[:text], options[:url]
    end

  end
end
