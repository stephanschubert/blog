# -*- coding: utf-8 -*-
require 'spec_helper'

describe Blog::PostsHelper do

  describe "#link_to_post" do # ----------------------------

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

    it "should accept a block" do
      post = F("blog/post", :tag_list => "a,b")

      html = helper.link_to_post(post) do
        "test"
      end

      html.should have_tag "a" do
        with_tag "span", :text => /test/
      end
    end

  end

  describe "#link_to_tag" do # -----------------------------

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

  describe "#pretty_date" do # -----------------------------

    it "should return a date w/ hAtom markup" do
      date      = Time.parse("2011/04/02 13:37:42")
      iso8601   = date.iso8601 # 2011-04-02T13:37:42+02:00
      humanized = l(date, :format => "%d.%m.%Y")
      html      = helper.pretty_date(date)

      html.should have_tag("abbr[title='#{iso8601}']", :text => humanized)
    end

  end

  describe "#pretty_author" do # ---------------------------

    it "should return an author w/ hAtom markup" do
      user = F("blog/user", :name => "Stephan Schubert")
      html = helper.pretty_author(user)

      html.should have_tag("span[class='author vcard']") do
        with_tag "span[class='fn']", :text => "Stephan Schubert"
      end
    end

  end

  describe "#most_viewed_posts" do # -----------------------

    it "should return published posts sorted by views" do
      p0 = F("blog/post", :views => 3,  :published_at => 1.day.ago)
      p1 = F("blog/post", :views => 23, :published_at => 2.days.ago)
      p2 = F("blog/post", :views => 11, :published_at => 3.days.ago)
      p3 = F("blog/post", :views => 48, :published_at => nil)

      posts = helper.most_viewed_posts.to_a
      posts.should == [ p1, p2, p0 ]
    end

  end

  describe "#excerpt_from_post" do # -----------------------

    it "should create a nice readable text-only excerpt" do
      body = <<-TXT

!figure{"class": "photo", "src": "http://dl.dropbox.com/u/12633787/stevepavlina/steve-pavlina-wie-man-ein-superheld-wird.jpg", "author": "zigazou76", "caption": "Wie man ein Superheld wird"}

<figure class="book amazon">
  <div class="img"><a href="http://www.amazon.de/gp/product/0452285755/ref=as_li_ss_il?ie=UTF8&tag=stevepavlina-21&linkCode=as2&camp=1638&creative=19454&creativeASIN=0452285755"><img border="0" src="http://ws.assoc-amazon.de/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=0452285755&MarketPlace=DE&ID=AsinImage&WS=1&tag=stevepavlina-21&ServiceVersion=20070822" ></a><img src="http://www.assoc-amazon.de/e/ir?t=stevepavlina-21&l=as2&o=3&a=0452285755" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /></div>
  <figcaption>
    <p>"How to Be a Superhero":http://www.amazon.de/gp/product/0452285755/ref=as_li_ss_tl?ie=UTF8&tag=stevepavlina-21&linkCode=as2&camp=1638&creative=19454&creativeASIN=0452285755 von Barry Neville</p>
    <p>Nur in Englisch verf¸gbar</p>
  </figcaption>
</figure>

Wenn man mal wirklich lachen will, sollte man sich das Buch "How to Be a Superhero":http://www.amazon.de/gp/product/0452285755/ref=as_li_ss_tl?ie=UTF8&tag=stevepavlina-21&linkCode=as2&camp=1638&creative=19454&creativeASIN=0452285755 von Dr. Metropolis (Barry Neville) anschauen. Ich fand es vor einigen Monaten in einem Buchladen. Der Untertitel ist: "Your Complete Guide to Finding a Secret HQ, Hiring a Sidekick, Thwarting the Forces of Evil, and Much More!!" ("Der vollständige Führer, um geheime Hauptquartiere zu finden, einen Handlanger anzustellen, die Mächte des Bösen auszubremsen und vieles mehr!!")
TXT

      post    = F("blog/post", title: "Wie man ein Superheld wird", body: body)
      excerpt = helper.excerpt_from_post(post, length: 350)

      excerpt.should == (<<-TXT
Wenn man mal wirklich lachen will, sollte man sich das Buch How to Be a Superhero von Dr. Metropolis (Barry Neville) anschauen. Ich fand es vor einigen Monaten in einem Buchladen. Der Untertitel ist: &#8220;Your Complete Guide to Finding a Secret HQ, Hiring a Sidekick, Thwarting the Forces of Evil, and Much More!!&#8221; (&#8220;Der ...
TXT
).strip
    end

  end

end
