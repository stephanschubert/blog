require 'spec_helper'

describe Blog::TwitterHelper do

  describe "#tweet_button" do # ------------------------------------------------

    it "should return least valid markup" do
      url  = "http://test.de"
      text = "Test"
      html = helper.tweet_button(url, text)

      html.should have_tag "a.twitter-share-button[data-url='#{url}'][data-text='#{text}']"
    end

  end

  describe "#tweet_button_for_post" do # ---------------------------------------

    it "should return valid markup for tweeting a post" do
      post = F("blog/post", :title => "A *new* post", :published_at => 1.day.ago)
      path = public_post_path(post)
      text = untextilize(post.title)
      html = helper.tweet_button_for_post(post)

      html.should have_tag "a.twitter-share-button[data-url$='#{path}'][data-text='#{text}']"
    end

  end

end