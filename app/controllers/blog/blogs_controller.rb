module Blog
  class BlogsController < SessionsController

    def index
      @posts = posts.all
    end

    def post
      @post = posts.find_by_slug(params[:id])
    end

    def posts_by_date
      year   = params[:year]
      month  = params[:month]
      @posts = posts.published(year, month)
    end

    private # ------------------------------------------------------------------

    def posts
      Post.published
    end

  end
end
