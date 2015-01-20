# TODO
# * How to test existance of rel=canonical if the main app is responsible for rendering it?
#   -> Put into presenter and test at least him?

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
    expect(page).to have_selector ".post-preview", count: 3

    # There should be 3 links to pages 2, 3 and 4 (and optional a 'next' link)
    within ".pagination" do
      expect(page).to have_selector "a", minimum: 3
    end
  end

  scenario "View posts by tag and custom page" do
    visit "/blog/tags/success/page/2"
    expect(page).to have_selector ".post-preview", count: 3
    expect(page).to have_selector ".pagination"
  end

  scenario "View all posts by tag" do
    visit "/blog/tags/success/page/all"
    expect(page).to have_selector ".post-preview", count: 10
    expect(page).not_to have_selector ".pagination"
  end

  scenario "View posts by date" do
    visit "/blog/#{Time.now.year}"
    expect(page).to have_selector ".post-preview", count: 3
    expect(page).to have_selector ".pagination"
  end

  scenario "View posts by date and custom page" do
    visit "/blog/#{Time.now.year}/page/2"
    expect(page).to have_selector ".post-preview", count: 3
    expect(page).to have_selector ".pagination"
  end

  scenario "View all posts by date" do
    visit "/blog/#{Time.now.year}/page/all"
    expect(page).to have_selector ".post-preview", count: 10
    expect(page).not_to have_selector ".pagination"
  end

  scenario "View posts by slug" do
    visit "/blog/success"
    expect(page).to have_selector ".post-preview", count: 3
    expect(page).to have_selector ".pagination"
  end

  scenario "View posts by slug and custom page" do
    visit "/blog/success/page/2"
    expect(page).to have_selector ".post-preview", count: 3
    expect(page).to have_selector ".pagination"
  end

  scenario "View all posts by slug" do
    visit "/blog/success/page/all"
    expect(page).to have_selector ".post-preview", count: 10
    expect(page).not_to have_selector ".pagination"
  end

end
