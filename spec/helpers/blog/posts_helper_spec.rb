require 'spec_helper'

describe Blog::PostsHelper do

  describe "#link_to_post" do # ------------------------------------------------

    it "should return a valid link" do
      post = F("blog/post", :title => "First post")
      html = helper.link_to_post(post)

      html.should have_tag "a[href$='/first-post']"
    end

    it "should return a link to the public post w/ date as default" do
      post = F("blog/post",
               :title => "First post",
               :published_at => Time.parse("2011/04/02"))

      html = helper.link_to_post(post)
      html.should have_tag "a[href='/blog/2011/04/first-post']"
    end

  end

end
