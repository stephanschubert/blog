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
  end

  scenario "View home page" do # -----------------------------------------------
    visit '/blog'

    page.html.should have_tag(".post", :count => 2)
    page.should have_post @one
    page.should have_post @two
  end

  scenario "View single post" do # ---------------------------------------------
    visit '/blog/one'

    page.html.should have_tag(".post", :count => 1)
    page.should have_post @one
    page.should_not have_post @two
  end

  scenario "View single post w/ date" do # -------------------------------------
    visit '/blog/2011/04/one'

    page.html.should have_tag(".post", :count => 1)
    page.should have_post @one
    page.should_not have_post @two
  end

  scenario "View all posts published in a month" do # --------------------------
    visit '/blog/2011/04'

    page.html.should have_tag(".post", :count => 2)
    page.should have_post @one
    page.should have_post @two
  end

  scenario "View all posts published in a year" do # ---------------------------
    three = F("blog/post", :published_at => Time.parse("2010/12/28"))

    visit '/blog/2011'

    page.html.should have_tag(".post", :count => 2)
    page.should have_post @one
    page.should have_post @two
    page.should_not have_post three
  end

  scenario "View all posts tagged with ..." do # -------------------------------
    @one.tags.create(:name => "General")
    @one.tags.create(:name => "Updates")
    @two.tags.create(:name => "General")

    visit '/blog/tags/general'

    page.html.should have_tag(".post", :count => 2)
    page.should have_post @one
    page.should have_post @two

    visit '/blog/tags/updates'

    page.html.should have_tag(".post", :count => 1)
    page.should have_post @one
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

    within "#feeds" do
      %w(rss atom).each do |type|
        with_tag "a[href$='/feed.#{type}']"
      end
    end
  end

end
