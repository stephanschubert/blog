module Blog
  class PostsController < SessionsController
    respond_to :html

    #before_filter :require_login, :except => %w(index)
    before_filter :find_post, :only => %w(show)

    def index
      @posts = Post.all
    end

    def new
      @post = Post.new
    end

    def show
    end

    def create
      @post = Post.new(params[:post])

      if @post.save
        flash[:notice] = t("post.created")
        respond_with @post
      else
        flash[:error] = t("post.invalid")
        render :new
      end
    end

    private # ------------------------------------------------------------------

    def find_post
      @post = Post.find_by_slug(params[:id])
    end

  end
end
