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

    before_filter :redirect_slug_with_comma

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

        if view_all?
          @page_title = t("blog.slug.posts.page_title", title: @tag.name)
        else
          @page_title = t("blog.slug.posts.paginated_page_title", title: @tag.name, page: page)
        end

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

      if view_all?
        @page_title = t("blog.posts_by_date.page_title", date: @date)
      else
        @page_title = t("blog.posts_by_date.paginated_page_title", date: @date, page: page)
      end

      @meta_description = t("blog.posts_by_date.meta_description", :description => enumerate_titles(@posts))
    end

    def posts_by_tag
      @posts = posts.desc(:published_at).tagged_with(params[:slug], :slug => true)
      # TODO Ugly
      @tag = Blog::Tag.all.select { |t| t.slug == params[:slug] }.first

      if view_all?
        @page_title = t("blog.posts_by_tag.page_title", title: @tag.name)
      else
        @page_title = t("blog.posts_by_tag.paginated_page_title", title: @tag.name, page: page)
      end

      @meta_description = t("blog.posts_by_tag.meta_description", :description => enumerate_titles(@posts))
    end

    private # ----------------------------------------------

    # There was a time when commata where not removed from a post's slug. Even months
    # after this issue was fixed GoogleBot is still trying to access them which leads
    # to crawl errors in Google Webmasters Tools.

    def redirect_slug_with_comma
      if params[:slug] =~ /,/
        redirect_to request.fullpath.gsub(',', ''), status: :moved_permanently
      end
    end

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
      protocol = request.scheme + "://"
      path = request.fullpath.split("?").first
      host = request.host_with_port
      url  = protocol + host + path

      if paginated? or view_all? or @tag
        url << "?all"
      end

      url
    end

    def page
      (params[:page] || 1).to_i
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
