module Blog
  module PostsHelper

    def parameters_for_post_path(post, options = {})
      options.reverse_merge! \
      :year  => post.published_at.year.to_s,
      :month => post.published_at.month.to_s.rjust(2, '0'),
      :id    => post.to_param
    end

    def public_post_path(post, options = {})
      blog.post_path parameters_for_post_path(post, options)
    end

    def public_post_url(post, options = {})
      blog.post_url parameters_for_post_path(post, options)
    end

    def link_to_post(post, options = {}, &block)
      options.reverse_merge! \
      :backend => false

      url = if options.pluck(:backend)
              blog.backend_post_path(post)
            else
              public_post_path(post)
            end

      options.reverse_merge! \
      :text  => post.title,
      :url   => url,
      :title => post.title

      text, url = options.pluck(:text, :url)
      text = capture(&block) if block_given?

      link_to url, options do
        # The extra <span> is just for styling purposes.
        content_tag :span, text
      end
    end

    # Returns a link to tag/category according to the hAtom spec.
    def link_to_tag(tag, options = {}, &block)
      options.reverse_merge! \
      :rel   => "tag",
      :title => tag.name,
      :text  => tag.name,
      :url   => blog.posts_by_tag_path(tag)

      text, url = options.pluck(:text, :url)
      text = capture(&block) if block_given?

      link_to url, options do
        # The extra <span> is just for styling purposes.
        content_tag :span, text
      end
    end

    # Returns an <abbr>-markup'd date according to the hAtom spec.
    def pretty_date(date, options = {})
      options.reverse_merge! \
      :title  => date.iso8601,
      :format => :standard

      format = options.pluck(:format)

      content_tag :abbr, options do
        l(date, :format => format)
      end
    end

    # Returns markup'd information about a post's author (user).
    def pretty_author(user, options = {})
      content_tag :span, :class => "author vcard" do
        content_tag :span, :class => "fn" do
          user.name rescue "Admin"
        end
      end
    end

    def most_viewed_posts(options = {})
      options.reverse_merge! \
      :limit => 10

      limit = options.pluck(:limit)

      Blog::Post.published.order_by(:views.desc).limit(limit)
    end

  end
end
