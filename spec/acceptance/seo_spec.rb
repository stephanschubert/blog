require 'acceptance/acceptance_helper'

feature "SEO" do

  scenario "Redirect slug with comma" do
    post = F("blog/post", title: "A new, fresh post", published_at: 1.day.ago)
    visit "/blog/a-new,-fresh-post"
    page.current_path.should == "/blog/a-new-fresh-post"
  end

  scenario "Redirect slug which is a post's ID" do
    post = F("blog/post", title: "A new, fresh post", published_at: 1.day.ago)
    visit "/blog/#{post.id}"
    page.current_path.should match(/a-new-fresh-post$/)
  end

end
