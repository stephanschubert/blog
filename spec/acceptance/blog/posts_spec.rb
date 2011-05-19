require 'acceptance/acceptance_helper'

feature "Posts", %q{
  In order to have an awesome blog
  As an author
  I want to create and manage posts
} do

  background do
    @one = F("blog/post", :title => "One", :body => "This is a body")
    @two = F("blog/post", :title => "Two", :body => "Second body")

    # FIXME Add real users/accounts
    basic_auth "baktinet", "6bd5069e47fc68f2"
  end

  scenario "Posts index" do # --------------------------------------------------
    visit '/blog/backend/posts'

    page.html.should have_tag ".post" do
      with_tag ".title", :text => "One"
      with_tag ".body", :text => "This is a body"
    end
  end

  scenario "Create post" do # --------------------------------------------------
    visit "/blog/backend/posts"
    click_on t("backend.actions.create_post")

    within "form#new_blog_post" do
      fill_in "post_title", :with => "A new post"
      fill_in "post_body",  :with => "The real content"

      find("*[type='submit']").click
    end

    page.should have_content t("post.created")
  end

  scenario "Update post" do # --------------------------------------------------
    visit "/blog/backend/posts"

    within ".posts li:first-child" do
      click_on t("backend.post_actions.edit")
    end

    within "form[id^='edit_blog_post']" do
      fill_in "post_body",  :with => "Updated content"

      find("*[type='submit']").click
    end

    page.should have_content t("post.updated")
  end

end
