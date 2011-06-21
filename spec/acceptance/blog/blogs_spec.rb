require 'acceptance/acceptance_helper'

feature "Default blog behavior", %q{

  In order to have a great time
  As an user
  I want to read the blog

} do

  background do
    @one = F("blog/post",
             :title => "One",
             :body => "This is a body",
             :published_at => Time.parse("2011/04/01"))

    @two = F("blog/post",
             :title => "Two",
             :body => "Second body",
             :published_at => Time.parse("2011/04/03"))

    @draft = F("blog/post", :published_at => nil)

    # Annoying.
    @host = "example.com"
  end

  scenario "View home page" do # -----------------------------------------------
    visit '/blog'

    page.html.should have_tag(".post", :count => 2)
    page.html.should have_post @one
    page.html.should have_post @two
  end

  scenario "View single post" do # ---------------------------------------------
    visit '/blog/one'

    page.html.should have_tag(".post", :count => 1)
    page.html.should have_post @one
    page.html.should_not have_post @two
  end

  scenario "View single post w/ date" do # -------------------------------------
    visit '/blog/2011/04/one'

    page.html.should have_tag(".post", :count => 1)
    page.html.should have_post @one
    page.html.should_not have_post @two
  end

  scenario "View all posts published in a month" do # --------------------------
    visit '/blog/2011/04'

    page.html.should have_tag(".post", :count => 2)
    page.html.should have_post @one
    page.html.should have_post @two
  end

  scenario "View all posts published in a year" do # ---------------------------
    three = F("blog/post", :published_at => Time.parse("2010/12/28"))

    visit '/blog/2011'

    page.html.should have_tag(".post", :count => 2)
    page.html.should have_post @one
    page.html.should have_post @two
    page.html.should_not have_post three
  end

  scenario "View all posts tagged with ..." do # -------------------------------
    @one.tags.create(:name => "General")
    @one.tags.create(:name => "Updates")
    @two.tags.create(:name => "General")

    visit '/blog/tags/general'

    page.html.should have_tag(".post", :count => 2)
    page.html.should have_post @one
    page.html.should have_post @two

    visit '/blog/tags/updates'

    page.html.should have_tag(".post", :count => 1)
    page.html.should have_post @one
  end

  scenario "Textilized post content" do # --------------------------------------
    post = F("blog/post",
             :title => "One",
             :body => "This is a body",
             :published_at => Time.parse("2011/04/01"))

    visit '/blog'

    within ".entry-content" do
      page.html.should match(/<p>This is a body<\/p>/)
    end
  end

  scenario "Latest posts" do # -------------------------------------------------
    visit '/blog'

    page.html.should have_tag("#latest-posts") do
      path = post_path(:year  => @one.published_at.year.to_s,
                       :month => @one.published_at.month.to_s.rjust(2, '0'),
                       :id    => @one.slug)

      with_tag "a[href$='#{path}']"

      path = post_path(:year  => @two.published_at.year.to_s,
                       :month => @two.published_at.month.to_s.rjust(2, '0'),
                       :id    => @two.slug)

      with_tag "a[href$='#{path}']"
    end
  end

  scenario "Tags overview" do # ------------------------------------------------
    post = F("blog/post", :published_at => 1.day.ago)
    post.tags.create :name => "General"
    post.tags.create :name => "Updates"

    visit '/blog'

    page.html.should have_tag("#all-tags") do
      with_tag "a[href$='/general']"
      with_tag "a[href$='/updates']"
    end
  end

  scenario "Auto-Discovery Links" do # -----------------------------------------
    visit '/blog'

    %w(rss atom).each do |type|
      page.html.should have_tag \
      "link[type='application/#{type}+xml'][rel='alternate'][href$='/feed.#{type}']"
    end
  end

  scenario "Visible Feed Links" do # -------------------------------------------
    visit '/blog'

    page.html.should have_tag "#feeds" do
      %w(rss atom).each do |type|
        with_tag "a[href$='/feed.#{type}']"
      end
    end
  end

  scenario "View RSS Feed" do # ------------------------------------------------
    visit '/blog/feed.rss'

    page.html.should have_tag "rss[version='2.0']" do
      with_tag "channel" do
        with_tag "title"
        with_tag "description"
        with_tag "link"

        [ @one, @two ].each do |post|
          with_tag "item" do
            with_tag "title", :text => post.title
            with_tag "description" # TODO

            with_tag "link" #, :text => public_post_url(post, :host => @host)
            with_tag "guid", :text => public_post_url(post, :host => @host)

            with_tag "pubdate", :text => post.published_at.to_s(:rfc822)

            post.tags.each do |tag|
              with_tag "category", :text => tag.name
            end
          end
        end
      end
    end
  end

  scenario "View ATOM Feed" do # -----------------------------------------------
    visit '/blog/feed.atom'

    page.html.should have_tag "feed" do
      with_tag "id"
      with_tag "title"
      with_tag "updated"

      [ @one, @two ].each do |post|
        with_tag "entry" do
          with_tag "id"
          with_tag "published", :text => post.published_at.iso8601
          with_tag "updated", :text => post.published_at.iso8601

          with_tag "title", :text => post.title
          with_tag "content[type='html']" # TODO

          url = public_post_url(post, :host => @host)
          with_tag "link[href='#{url}']"

          post.tags.each do |tag|
            with_tag "category", :text => tag.name
          end
        end
      end
    end
  end

  scenario "View archive" do # -------------------------------------------------
    visit '/blog/archive'

    page.html.should have_link_to_post(@one)
    page.html.should have_link_to_post(@two)
  end

end
