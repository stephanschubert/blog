module Blog
  module PostsHelper

    def link_to_post(post, options = {}, &block)
      options.reverse_merge! \
      :backend => false

      url = if options.pluck(:backend)
              blog.backend_post_path(post)
            else
              public_post_path(post)
            end

      options.reverse_merge! \
      :text  => untextilize(post.title),
      :url   => url,
      :title => untextilize(post.title)

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

    def excerpt_from_post(post, options = {})
      options.reverse_merge! \
      :length => 350,
      :words_only => true

      excerpt  = truncate(post.body, options)
      excerpt  = textilize(excerpt)

      link = link_to_post(post, :text => t("blog.excerpt_from_post.read_on"), :class => "read-on")

      excerpt = excerpt.sub /<\/p>\Z/, " #{link}</p>"
      excerpt.html_safe
    end

  end
end
