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

  scenario "Posts index" do # --------------------------------------------------
    visit '/blog'

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "One"
      with_tag ".body", :text => "This is a body"
    end
  end

  scenario "Create post" do # --------------------------------------------------
    visit "/blog/backend/posts/new"

    within "form#new_post" do
      fill_in "post_title", :with => "A new post"
      fill_in "post_body",  :with => "The real content"
    end

    click_button "post_submit"

    page.should have_content t("post.created")
  end

end
