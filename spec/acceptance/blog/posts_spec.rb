require 'acceptance/acceptance_helper'

feature "Posts", %q{
  In order to have an awesome blog
  As an author
  I want to create and manage posts
} do

  background do
    @one = F("blog/post", :title => "One", :body => "This is a body")
    @two = F("blog/post", :title => "Two", :body => "Second body")
  end

  scenario "Posts index" do
    visit '/blog/posts'

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "One"
      with_tag ".body", :text => "This is a body"
    end
  end

end
