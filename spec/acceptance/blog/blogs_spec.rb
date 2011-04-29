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
  end

  scenario "View home page" do # -----------------------------------------------
    visit '/blog'

    page.should have_post @one
    page.should have_post @two
  end

  scenario "View single post" do # ---------------------------------------------
    visit '/blog/one'

    page.should have_post @one
    page.should_not have_post @two
  end

  scenario "View single post w/ date" do # -------------------------------------
    visit '/blog/2011/04/one'

    page.should have_post @one
    page.should_not have_post @two
  end

  scenario "View all posts published in a month" do # --------------------------
    visit 'blog/2011/04'

    page.should have_post @one
    page.should have_post @two
  end

  scenario "View all posts published in a year" do # ---------------------------
    three = F("blog/post", :published_at => Time.parse("2010/12/28"))

    visit 'blog/2011'

    page.should have_post @one
    page.should have_post @two
    page.should_not have_post three
  end

end
