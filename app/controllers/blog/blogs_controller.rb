module Blog
  class BlogsController < SessionsController

    def index
      @posts = Post.all
    end

    def post
      @post = Post.find_by_slug(params[:id])
    end

    def posts_by_date
      year   = params[:year]
      month  = params[:month]
      @posts = Post.published(year, month)
    end

  end
end
