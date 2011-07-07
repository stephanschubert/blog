require 'spec_helper'

describe Blog::BlogsHelper do

  describe "#latest_posts" do # ----------------------------

    before :each do
      @one   = F("blog/post", :published_at => Time.parse("2011/04/01"))
      @two   = F("blog/post", :published_at => Time.parse("2011/04/03"))
      @draft = F("blog/post", :published_at => nil)
    end

    it "should return the latest published posts" do
      posts = helper.latest_posts
      posts.should == [ @two, @one ]
    end

    it "should support an integer-argument as count" do
      posts = helper.latest_posts(1)
      posts.should == [ @two ]
    end

  end

end
