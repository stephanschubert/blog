module Blog
  class BlogsController < SessionsController
    layout "application"

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

      @page_title = t("blog.post.page_title", :title => @post.preferred_title)
      @meta_description = t("blog.post.meta_description", :description => @post.meta_description)
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
