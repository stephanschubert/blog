require 'spec_helper'

describe Blog::TwitterHelper do

  describe "#tweet_button" do

    it "should return least valid markup" do
      url  = "http://test.de"
      text = "Test"
      html = helper.tweet_button(url, text)

      expect(html).to have_tag "a.twitter-share-button[data-url='#{url}'][data-text='#{text}']"
    end

  end

  describe "#tweet_button_for_post" do

    it "should return valid markup for tweeting a post" do
      post = F("blog/post", :title => "A *new* post", :published_at => 1.day.ago)
      path = public_post_path(post)
      text = untextilize(post.title)
      html = helper.tweet_button_for_post(post)

      expect(html).to have_tag "a.twitter-share-button[data-url$='#{path}'][data-text='#{text}']"
    end

  end

  describe "#twitter_follow_button" do

    it "should return valid markup" do
      user = "Matt"
      url  = "http://twitter.com/#{user}"
      html = helper.twitter_follow_button(user)
      expect(html).to have_tag "a.twitter-follow-button[href='#{url}']", :text => "Follow #{user}"
    end
  end
end
