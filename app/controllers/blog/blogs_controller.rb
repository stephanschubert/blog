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

    def archive
      @posts_by_year = posts.desc(:published_at).group_by do |post|
        post.published_at.year
      end
    end

    def posts_by_date
      year   = params[:year]
      month  = params[:month]
      @posts = posts.published(year, month)
      @date  = formatted_date(year, month)
    end

    def posts_by_tag
      @posts = posts.tagged_with(params[:id], :slug => true)
    end

    private # ------------------------------------------------------------------

    def posts
      Post.published
    end

    def formatted_date(year, month)
      if month.blank?
        date = Time.parse("#{year}/01")
        l(date, :format => "%Y")
      else
        month = month.to_s.rjust(2, "0")
        date  = Time.parse("#{year}/#{month}")
        l(date, :format => "%B %Y")
      end
    end

  end
end
