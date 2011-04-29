require 'spec_helper'

describe Blog::PostsHelper do

  describe "#link_to_post" do # ------------------------------------------------

    it "should return a valid link" do
      post = F("blog/post", :title => "First post")
      html = helper.link_to_post(post)

      html.should have_tag "a[href$='/first-post']"
    end

  end

end
