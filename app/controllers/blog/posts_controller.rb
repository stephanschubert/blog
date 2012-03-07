module Blog
  class PostsController < ProtectedController
    respond_to :html

    before_filter :find_post, :only => %w(edit show update destroy)

    def index
      @posts = Post.order_by(:published_at.desc)
    end

    def new
      @post = Post.new.tap do |p|
        p.published_at = Time.now
      end
    end

    def edit
    end

    def show
    end

    def create
      @post = Post.new incoming_changes

      if @post.save
        flash[:notice] = t("post.created")
        respond_with :backend, @post
      else
        flash[:error] = t("post.invalid")
        render :new
      end
    end

    def update
      if @post.update_attributes incoming_changes
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

    private # ----------------------------------------------

    def find_post
      @post = Post.find params[:id]
    end

    def incoming_changes
      params[:post]
    end

  end
end
