# -*- coding: utf-8 -*-
require 'spec_helper'

describe Blog::Post do

  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should belong_to(:user).as_inverse_of(:posts) }

  it { should have_field(:title).of_type(String) }
  it { should validate_presence_of(:title) }
  it { should have_slug(:title) }

  it { should have_field(:body).of_type(String) }
  it { should validate_presence_of(:body) }

  it { should have_field(:published_at).of_type(DateTime) }

  # it { should have_and_belong_to_many(:tags) }
  it { should embed_many(:tags) }

  it "should be valid using the factory" do # ----------------------------------
    F.build("blog/post").should be_valid
  end

  describe "#slug" do # --------------------------------------------------------

    it "should convert umlauts and other special chars to ASCII" do
      post = F("blog/post", :title => "Ä ö Ü ß")
      post.slug.should == "ae-oe-ue-ss"
    end

    it "should produce nice-looking URLs" do
      post = F("blog/post", :title => "Schmidt & Söhne 3€")
      post.slug.should == "schmidt-und-soehne-3-euro"
    end

  end

  describe "#tags" do # --------------------------------------------------------

    it "should be convertable into a string of names" do
      post = F("blog/post")
      post.tags.create(:name => "A")
      post.tags.create(:name => "B")

      post.tags.to_s.should == "A, B"
      post.tag_list.should == "A, B"
    end

  end

  describe "#tagged_with" do # -------------------------------------------------

    it "should return all posts tagged w/ given tag" do
      post = F("blog/post")
      tag  = post.tags.create(:name => "A")

      Blog::Post.tagged_with(tag).should == [ post ]
    end

    it "should return all posts tagged w/ given tags" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "A")
      tag1 = post.tags.create(:name => "B")

      Blog::Post.tagged_with(tag0,tag1).should == [ post ]
    end

    it "should return all posts tagged w/ given tag name" do
      post = F("blog/post")
      tag  = post.tags.create(:name => "A")

      Blog::Post.tagged_with("A").should == [ post ]
    end

    it "should return all posts tagged w/ given tag names" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "A")
      tag1 = post.tags.create(:name => "B")

      Blog::Post.tagged_with("A", "B").should == [ post ]
    end

    it "should return all posts tagged w/ given tag (by slug)" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "It's me")
      tag1 = post.tags.create(:name => "And me")

      Blog::Post.tagged_with("and-me", "its-me", :slug => true).should == [ post ]
    end

  end

  describe "#published" do # ---------------------------------------------------

    it "should return all posts published if no date is given" do
      one   = F("blog/post", :published_at => 10.days.ago)
      two   = F("blog/post", :published_at => nil)
      three = F("blog/post", :published_at => 2.days.ago)

      Blog::Post.published.should == [ one, three ]
    end

    it "should return all posts published before a given date" do
      one   = F("blog/post", :published_at => 10.days.ago)
      two   = F("blog/post", :published_at => 7.days.ago)
      three = F("blog/post", :published_at => 2.days.ago)

      Blog::Post.published(3.days.ago).should == [ one, two ]
    end

    it "should return all posts published in a given year" do
      one   = F("blog/post", :published_at => Time.parse("2010/11/25"))
      two   = F("blog/post", :published_at => Time.parse("2011/04/01"))
      three = F("blog/post", :published_at => Time.parse("2012/05/03"))

      Blog::Post.published("2011").should == [ two ]
    end

    it "should return all posts published in a given month" do
      one   = F("blog/post", :published_at => Time.parse("2011/04/01"))
      two   = F("blog/post", :published_at => Time.parse("2011/04/03"))
      three = F("blog/post", :published_at => Time.parse("2011/05/03"))

      Blog::Post.published(2011, 4).should == [ one, two ]
    end

  end

end
