module Blog
  class BlogsController < SessionsController
    include Blog::UrlHelper

    layout :determine_layout

    respond_to :html, :except => %w(feed)
    respond_to :rss, :atom, :only => %w(feed)

    caches_page :index, :slug, :archive, :posts_by_date, :posts_by_tag

    helper_method \
    :paginated?,
    :view_all?,
    :canonical_url

    def index
      @posts = posts.latest(10)
      @page_title = t("blog.index.page_title")
      @meta_description = t("blog.index.page_title")
    end

    def feed
      @posts = posts.latest(10)
    end

    def slug
      if @post = posts.find_by_slug(params[:slug])
        @page_title = t("blog.slug.post.page_title", :title => @post.preferred_title)
        @meta_description = t("blog.slug.post.meta_description", :description => @post.meta_description)
        @post.inc(:views, 1)
      elsif @post = posts.any_in(slug_aliases: [ params[:slug] ]).first
        redirect_to public_post_path(@post), :status => :moved_permanently
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

      @page_title = t("blog.archive.page_title")
      @meta_description = t("blog.archive.meta_description")
    end

    def posts_by_date
      year   = params[:year]
      month  = params[:month]
      @posts = posts.published(year, month)
      @date  = formatted_date(year, month)

      @page_title = t("blog.posts_by_date.page_title", :date => @date)
      @meta_description = t("blog.posts_by_date.meta_description", :description => enumerate_titles(@posts))
    end

    def posts_by_tag
      @posts = posts.desc(:published_at).tagged_with(params[:slug], :slug => true)
      # TODO Ugly
      @tag = Blog::Tag.all.select { |t| t.slug == params[:slug] }.first

      @page_title = t("blog.posts_by_tag.page_title", :title => @tag.name)
      @meta_description = t("blog.posts_by_tag.meta_description", :description => enumerate_titles(@posts))
    end

    private # ----------------------------------------------

    def enumerate_titles(posts, limit = 5)
      posts.slice(0,limit).map { |post|
        '"' + post.title + '"'
      }.join(", ") + ", ..."
    end

    def determine_layout(default = "application")
      Settings.blog.layout || default
    rescue
      default
    end

    def canonical_url
      if paginated? or view_all?
        protocol = request.scheme + "://"
        path = request.fullpath.split("?").first
        host = request.host_with_port

        protocol + host + path + "?all"
      end
    end

    def paginated?
      params.include?(:page)
    end

    def view_all?
      params.include?(:all)
    end

    def posts
      posts = Post.published
      posts = posts.page(params[:page]) unless view_all?
      posts
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
