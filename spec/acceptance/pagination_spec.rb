require 'acceptance/acceptance_helper'

feature "Pagination" do

  background do
    (1..10).each do |n|
      F("blog/post", tag_list: "Success", published_at: n.days.ago)
    end

    WillPaginate.per_page = 3
  end

  scenario "View posts by tag" do
    visit '/blog/tags/success'
    page.should have_selector ".post-preview", count: 3

    # There should be 3 links to pages 2, 3 and 4 (and optional a 'next' link)
    within ".pagination" do
      page.should have_selector "a", minimum: 3
    end
  end

  scenario "View posts by tag and custom page" do
    visit "/blog/tags/success/page/2"
    page.should have_selector ".post-preview", count: 3
    page.should have_selector ".pagination"
  end

  scenario "View posts by date" do
    visit "/blog/#{Time.now.year}"
    page.should have_selector ".post-preview", count: 3
    page.should have_selector ".pagination"
  end

  scenario "View posts by date and custom page" do
    visit "/blog/#{Time.now.year}/page/2"
    page.should have_selector ".post-preview", count: 3
    page.should have_selector ".pagination"
  end

  scenario "View posts by slug" do
    visit "/blog/success"
    page.should have_selector ".post-preview", count: 3
    page.should have_selector ".pagination"
  end

  scenario "View posts by slug and custom page" do
    visit "/blog/success/page/2"
    page.should have_selector ".post-preview", count: 3
    page.should have_selector ".pagination"
  end

end
