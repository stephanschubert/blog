module Blog
  class PostsController < ProtectedController
    respond_to :html

    before_filter :find_post, :only => %w(edit show update destroy)

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
        respond_with :backend, @post
      else
        flash[:error] = t("post.invalid")
        render :new
      end
    end

    def update
      if @post.update_attributes(params[:post])
        flash[:notice] = t("post.updated")
        respond_with :backend, @post
      else
        flash[:error] = t("post.invalid")
        render :edit
      end
    end

    def destroy
      @post.destroy
      flash[:notice] = t("post.destroyed")
      redirect_to :back
    end

    private # ------------------------------------------------------------------

    def find_post
      @post = Post.find_by_slug(params[:id])
    end

  end
end
