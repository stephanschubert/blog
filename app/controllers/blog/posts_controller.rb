module Blog
  class PostsController < SessionsController
    respond_to :html

    #before_filter :require_login, :except => %w(index)
    before_filter :find_post, :only => %w(edit show update)

    def index
      @posts = Post.all
    end

    def new
      @post = Post.new
    end

    def edit
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

    def update
      if @post.update_attributes(params[:post])
        flash[:notice] = t("post.updated")
        respond_with @post
      else
        flash[:error] = t("post.invalid")
        render :edit
      end
    end

    private # ------------------------------------------------------------------

    def find_post
      @post = Post.find_by_slug(params[:id])
    end

  end
end
