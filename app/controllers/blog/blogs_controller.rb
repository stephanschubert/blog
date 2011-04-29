module Blog
  class BlogsController < SessionsController

    def index
      @posts = Post.all
    end

    def post
      @post = Post.find_by_slug(params[:id])
    end

  end
end
