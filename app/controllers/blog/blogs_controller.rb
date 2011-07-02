module Blog
  class BlogsController < SessionsController
    layout "application"

    respond_to :html, :except => %w(feed)
    respond_to :rss, :atom, :only => %w(feed)

    def index
      @posts = posts.latest(10)
    end

    def feed
      @posts = posts.latest(10)
    end

    def slug
      if @post = posts.find_by_slug(params[:slug])
        @page_title = t("blog.slug.post.page_title", :title => @post.preferred_title)
        @meta_description = t("blog.slug.post.meta_description", :description => @post.meta_description)
        @post.inc(:views, 1)
      else
        @posts = posts.desc(:published_at).tagged_with(params[:slug], :slug => true)
        # TODO Ugly
        @tag = Blog::Tag.all.select { |t| t.slug == params[:slug] }.first
        @page_title = t("blog.slug.posts.page_title", :title => @tag.name)

        some_post_titles = @posts.slice(0,5).map(&:title).join(", ")
        @meta_description = t("blog.slug.posts.meta_description", :title => @tag.name, :description => some_post_titles)
      end
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
      @posts = posts.desc(:published_at).tagged_with(params[:id], :slug => true)
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
