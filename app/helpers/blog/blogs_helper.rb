module Blog
  module BlogsHelper

    def latest_posts(max = 5)
      Blog::Post.published.latest(max)
    end

  end
end
