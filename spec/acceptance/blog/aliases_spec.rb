# -*- coding: utf-8 -*-
require 'acceptance/acceptance_helper'

feature "Aliases", %q{
  I want to be able to change a post´s slug (for SEO purposes) after it has
  been in use for quite some time. So we need some feature to setup an alias
  (new slug) and redirect from the old to the new one.
} do

  context "Post with updated slug" do

    scenario "Redirect from the old permalink to the new one" do
      post = F("blog/post", title: "One", published_at: Time.parse("2012/02/03"))
      post.update_attribute :slug, "two"

      visit "/blog/2012/02/one"
      expect(current_path).to eq("/blog/2012/02/two")
    end
  end
end
