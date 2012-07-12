module Blog
  module BlogsHelper

    def canonical_link_tag(url, options = {})
      options.reverse_merge! \
      :rel  => :canonical,
      :href => url

      tag :link, options
    end

    def noindex_meta_tag
      tag :meta, name: "robots", content: "noindex"
    end

    def latest_posts(max = 5)
      Blog::Post.published.latest(max)
    end

    def all_tags
      Blog::Tag.all.sort_by(&:name)
    end

  end
end
