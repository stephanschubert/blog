# -*- coding: utf-8 -*-
module Blog
  class BlogsController < SessionsController
    include Blog::UrlHelper

    layout :determine_layout

    respond_to :html, :except => %w(feed)
    respond_to :rss, :atom, :only => %w(feed)

    caches_page \
      :index,
      :slug,
      :archive,
      :posts_by_date,
      :posts_by_tag

    helper_method \
      :paginated?,
      :view_all?,
      :canonical_url

    before_filter \
      :redirect_slug_with_comma,
      :redirect_slug_with_post_id,
      :redirect_mixed_case_slug

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

    # Some websites are pretty stupid and shorten links randomly (adding ".." to the end).
    # Lets try to fix this shit by removing the broken stuff and looking for a post whose
    # slug's beginning matches.
    #
    # Example: /a-fresh-new-po.. should redirect to the post with slug /a-fresh-new-post
    #
    # NOTE:
    # An URL like this generates an ActionController::RoutingError so we have to handle it
    # with a catch-all route at the bottom of config/routes.rb

    def routing_error
      broken_pattern = /\.{1,3}$/

      if params[:shit] =~ broken_pattern
        partial_slug = params[:shit].split("/").last.gsub(broken_pattern, '')
        if post = posts.where(slug: /^#{partial_slug}/).first
          redirect_to public_post_path(post), status: :moved_permanently
        end
      end
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

    # No idea where Google got them from but the bot is trying to access posts using
    # their internal IDs. This is annoying.

    def redirect_slug_with_post_id
      if BSON::ObjectId.legal?(params[:slug]) and post = posts.find(params[:slug])
        redirect_to public_post_path(post), status: :moved_permanently
      end
    end

    # Ensure we always using lowercased slugs.
    # Some people linking manually will mix it up for sure.

    def redirect_mixed_case_slug
      if params[:slug] =~ /[A-Z]/
        redirect_to request.fullpath.downcase, status: :moved_permanently
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
      proto = request.scheme + "://"
      path  = request.fullpath.split("/page/").first
      host  = request.host_with_port
      url   = proto + host + path

      if paginated? or view_all? or @tag
        url << "/page/all"
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
      params[:page] == "all"
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
