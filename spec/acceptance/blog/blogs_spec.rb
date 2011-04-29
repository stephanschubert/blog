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

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "One"
      with_tag ".body",  :text => "This is a body"
    end

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "Two"
      with_tag ".body",  :text => "Second body"
    end
  end

  scenario "View single post" do # ---------------------------------------------
    visit '/blog/one'

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "One"
      with_tag ".body",  :text => "This is a body"
    end
  end

end
