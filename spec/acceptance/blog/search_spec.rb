require 'acceptance/acceptance_helper'

feature "Search" do

  scenario "Requesting partial slug triggers search" do
    one = F("blog/post", published_at: 3.days.ago, title: "10 Reasons to switch jobs")
    two = F("blog/post", published_at: 2.days.ago, title: "10 Reasons to do laundry")

    visit "/blog/10"

    expect(page).to have_link_to_post(one)
    expect(page).to have_link_to_post(two)
  end

end
