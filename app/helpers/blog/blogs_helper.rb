module Blog
  module BlogsHelper

    def canonical_link_tag(url, options = {})
      options.reverse_merge! \
      :rel  => :canonical,
      :href => url

      tag :link, options
    end

    def latest_posts(max = 5)
      Blog::Post.published.latest(max)
    end

    def all_tags
      Blog::Tag.all
    end

  end
end
