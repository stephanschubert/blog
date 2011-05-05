module Blog
  module BlogsHelper

    def latest_posts(max = 5)
      Blog::Post.published.latest(max)
    end

    def all_tags
      Blog::Tag.all
    end

  end
end
