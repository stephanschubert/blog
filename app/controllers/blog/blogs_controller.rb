module Blog
  class BlogsController < SessionsController

    def index
      @posts = Post.all
    end

  end
end
