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

  describe "#link_to_tag" do # -------------------------------------------------

    it "should return a valid link" do
      post = F("blog/post")
      tag  = post.tags.create(:name => "A tag")
      html = helper.link_to_tag(tag)

      html.should have_tag "a[href$='/a-tag']" do
        with_tag "span", :text => tag.name
      end
    end

    it "should accept a block" do
      post = F("blog/post", :tag_list => "a,b")
      tag  = post.tags.first

      html = helper.link_to_tag(tag) do
        "test"
      end

      html.should have_tag "a" do
        with_tag "span", :text => /test/
      end
    end

  end

  describe "#pretty_date" do # -------------------------------------------------

    it "should return a date w/ hAtom markup" do
      date      = Time.parse("2011/04/02 13:37:42")
      iso8601   = date.iso8601 # 2011-04-02T13:37:42+02:00
      humanized = l(date, :format => "%d.%m.%Y")
      html      = helper.pretty_date(date)

      html.should have_tag("abbr[title='#{iso8601}']", :text => humanized)
    end

  end

  describe "#pretty_author" do # -----------------------------------------------

    it "should return an author w/ hAtom markup" do
      user = F("blog/user", :name => "Stephan Schubert")
      html = helper.pretty_author(user)

      html.should have_tag("span[class='author vcard']") do
        with_tag "span[class='fn']", :text => "Stephan Schubert"
      end
    end

  end

  describe "#most_viewed_posts" do # -------------------------------------------

    it "should return published posts sorted by views" do
      p0 = F("blog/post", :views => 3,  :published_at => 1.day.ago)
      p1 = F("blog/post", :views => 23, :published_at => 2.days.ago)
      p2 = F("blog/post", :views => 11, :published_at => 3.days.ago)
      p3 = F("blog/post", :views => 48, :published_at => nil)

      posts = helper.most_viewed_posts.to_a
      posts.should == [ p1, p2, p0 ]
    end

  end

end
