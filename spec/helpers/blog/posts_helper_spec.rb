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

end
