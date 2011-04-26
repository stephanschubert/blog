module Blog
  class PostsController < SessionsController

    #before_filter :require_login, :except => %w(index)

    def index
      @posts = Post.all
    end

    def new
      @post = Post.new
    end

  end
end
