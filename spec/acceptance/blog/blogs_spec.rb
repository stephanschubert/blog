require 'acceptance/acceptance_helper'

feature "Default blog behavior", %q{

  In order to have a great time
  As an user
  I want to read the blog

} do

  background do
    @one = F("blog/post", :title => "One", :body => "This is a body")
    @two = F("blog/post", :title => "Two", :body => "Second body")
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

end
