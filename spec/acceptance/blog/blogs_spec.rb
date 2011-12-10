require 'acceptance/acceptance_helper'

feature "Default blog behavior", %q{

  In order to have a great time
  As an user
  I want to read the blog

} do

  background do
    @one = F("blog/post",
             title: "One",
             body: "This is a body",
             published_at: Time.parse("2011/04/01"))

    @two = F("blog/post",
             title: "Two",
             body: "Second body",
             published_at: Time.parse("2011/04/03"))

    @draft = F("blog/post", published_at: nil)

    # Annoying.
    @host = "www.example.com"
  end

  scenario "View home page" do # ---------------------------
    visit '/blog'

    page.should have_selector ".post-preview", count: 2
    page.should have_post_preview @one
    page.should have_post_preview @two
  end

  scenario "View single post" do # -------------------------
    # Should increase 'views' counter.
    @one.views.should == 0
    visit '/blog/one'
    @one.reload
    @one.views.should == 1

    page.should have_selector ".post", count: 1
    page.should have_post @one
    page.should have_no_post @two
  end

  scenario "View single post w/ date" do # -----------------
    visit '/blog/2011/04/one'

    page.should have_selector ".post", count: 1
    page.should have_post @one
    page.should have_no_post @two
  end

  scenario "View all posts published in a month" do # ------
    visit '/blog/2011/04'

    page.should have_selector ".post-preview", count: 2
    page.should have_post_preview @one
    page.should have_post_preview @two
  end

  scenario "View all posts published in a year" do # -------
    three = F("blog/post", published_at: Time.parse("2010/12/28"))

    visit '/blog/2011'

    page.should have_selector ".post-preview", count: 2
    page.should have_post_preview @one
    page.should have_post_preview @two
    page.should have_no_post_preview three
  end

  scenario "View all posts tagged with ..." do # -----------
    @one.tags.create(:name => "General")
    @one.tags.create(:name => "Updates")
    @two.tags.create(:name => "General")

    visit '/blog/tags/general'

    page.should have_selector ".post-preview", count: 2
    page.should have_post_preview @one
    page.should have_post_preview @two

    visit '/blog/tags/updates'

    page.should have_selector ".post-preview", count: 1
    page.should have_post_preview @one
  end

  scenario "Textilized post content" do # ------------------
    post = F("blog/post",
             :title => "One",
             :body => "This is a body",
             :published_at => Time.parse("2011/04/01"))

    visit '/blog/one'

    within :css, ".entry-content" do
      page.html.should match(/<p>This is a body<\/p>/)
    end
  end

  scenario "Latest posts" do # -----------------------------
    visit '/blog'

    within :css, "#latest-posts" do
      path = public_post_path(@one)
      page.should have_selector "a[href$='#{path}']"

      path = public_post_path(@two)
      page.should have_selector "a[href$='#{path}']"
    end
  end

  scenario "Tags overview" do # ----------------------------
    post = F("blog/post", :published_at => 1.day.ago)
    post.tags.create :name => "General"
    post.tags.create :name => "Updates"

    visit '/blog'

    within :css, "#all-tags" do
      page.should have_selector "a[href$='/general']"
      page.should have_selector "a[href$='/updates']"
    end
  end

  scenario "Auto-Discovery Links" do # ---------------------
    visit '/blog'

    %w(rss atom).each do |type|
      page.should have_selector \
      "link[type='application/#{type}+xml'][rel='alternate'][href$='/feed.#{type}']"
    end
  end

  scenario "Visible Feed Links" do # -----------------------
    visit '/blog'

    within :css, "#feeds" do
      %w(rss atom).each do |type|
        page.should have_selector "a[href$='/feed.#{type}']"
      end
    end
  end

  scenario "View RSS Feed" do # ----------------------------
    visit '/blog/feed.rss'

    within :css, "rss[version='2.0']" do
      within :css, "channel" do
        page.should have_selector "title"
        page.should have_selector "description"
        page.should have_selector "link"

        [ @two, @one ].each_with_index do |post, index|
          within :css, "item:#{index == 0 ? 'first' : 'last'}" do

            within :css, "title" do
              page.should have_content(post.title)
            end

            page.should have_selector "description" # TODO
            page.should have_selector "link" #, :text => public_post_url(post, :host => @host)

            within :css, "guid" do
              page.should have_content(public_post_url(post, host: @host))
            end

            within :css, "pubdate" do
              page.should have_content(post.published_at.to_s(:rfc822))
            end

            post.tags.each do |tag|
              page.should have_selector "category", text: tag.name
            end
          end
        end
      end
    end
  end

  scenario "View ATOM Feed" do # ---------------------------
    visit '/blog/feed.atom'

    within :css, "feed" do
      page.should have_selector "id"
      page.should have_selector "title"
      page.should have_selector "updated"

      [ @two, @one ].each_with_index do |post, index|
        within :css, "entry:#{index == 0 ? 'first' : 'last'}" do
          page.should have_selector "id"

          within :css, "published" do
            page.should have_content(post.published_at.iso8601)
          end

          within :css, "updated" do
            page.should have_content(post.updated_at.iso8601)
          end

          within :css, "title" do
            page.should have_content(post.title)
          end

          page.should have_selector "content[type='html']" # TODO

          url = public_post_url(post, host: @host)
          page.should have_selector "link[href='#{url}']"

          post.tags.each do |tag|
            page.should have_selector "category", text: tag.name
          end
        end
      end
    end
  end

  scenario "View archive" do # -----------------------------
    visit '/blog/archive'

    page.should have_link_to_post(@one)
    page.should have_link_to_post(@two)
  end

  # FIXME Not working - see spec/acceptance/support/capybara/caching for details.
  # scenario "View updated post" do # ------------------------
  #   post = F("blog/post", body: "First draft.", published_at: 1.day.ago)

  #   visit public_post_path(post)
  #   page.should have_content "First draft."

  #   post.body = "Second draft."
  #   post.save

  #   visit public_post_path(post)
  #   page.should have_content "Second draft."
  # end

end
