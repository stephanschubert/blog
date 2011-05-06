module Blog
  class BlogsController < SessionsController

    respond_to :html, :rss, :atom

    def index
      @posts = posts.latest(10)
    end

    def feed
      @posts = posts.latest(10)

      respond_to do |wants|
        wants.rss
        wants.atom
      end
    end

    def post
      @post = posts.find_by_slug(params[:id])
    end

    def posts_by_date
      year   = params[:year]
      month  = params[:month]
      @posts = posts.published(year, month)
    end

    def posts_by_tag
      @posts = posts.tagged_with(params[:id], :slug => true)
    end

    private # ------------------------------------------------------------------

    def posts
      Post.published
    end

  end
end
