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

      @page_title = page_title(@post)
      @meta_description = @post.meta_description
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

    def page_title(post)
      title = post.page_title
      title = post.title if title.blank?
      title
    end

  end
end
