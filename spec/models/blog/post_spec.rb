# -*- coding: utf-8 -*-
require 'spec_helper'

describe Blog::Post do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_timestamped_document }
  it { is_expected.to be_slugged_document }

  it { is_expected.to belong_to(:user).as_inverse_of(:posts) }

  it { is_expected.to have_field(:title).of_type(String) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_slug(:title) }

  it { is_expected.to have_field(:body).of_type(String) }
  it { is_expected.to validate_presence_of(:body) }

  it { is_expected.to have_field(:published_at).of_type(Time) }

  # it { should have_and_belong_to_many(:tags) }
  it { is_expected.to embed_many(:tags) }

  it { is_expected.to have_field(:views).of_type(Integer).with_default_value_of(0) }

  it "should be valid using the factory" do # --------------
    expect(F.build("blog/post")).to be_valid
  end

  describe "#published?" do # ------------------------------

    it "should return true if the post's publication date is in the past" do
      post = F.build("blog/post")
      expect(post).not_to be_published

      post.published_at = 1.day.from_now
      expect(post).not_to be_published

      post.published_at = 1.day.ago
      expect(post).to be_published
    end

  end

  describe "#slug" do # ------------------------------------

    it "should convert umlauts and other special chars to ASCII" do
      post = F("blog/post", :title => "Ä ö Ü ß")
      expect(post.slug).to eq("ae-oe-ue-ss")
    end

    it "should remove any textile formatting" do
      post = F("blog/post", :title => "A *nice*\n _post_")
      expect(post.slug).to eq("a-nice-post")
    end

    it "should produce nice-looking URLs" do
      post = F("blog/post", :title => "Schmidt & Söhne 3€")
      expect(post.slug).to eq("schmidt-und-soehne-3-euro")
    end

  end

  describe "#tags" do # ------------------------------------

    it "should be convertable into a string of names" do
      post = F("blog/post")
      post.tags.create(:name => "A")
      post.tags.create(:name => "B")

      expect(post.tags.to_s).to eq("A, B")
      expect(post.tag_list).to eq("A, B")
    end

  end

  describe "#tag_list" do # --------------------------------

    it "should accept a list of tags" do
      post = F("blog/post")
      expect(post.tag_list).to eq("")

      post.tag_list = "General, Updates"
      post.save

      post.reload
      expect(post.tags.size).to eq(2)
      expect(post.tag_list).to eq("General, Updates")
    end

  end

  describe "#tagged_with" do # -----------------------------

    it "should return all posts tagged w/ given tag" do
      post = F("blog/post")
      tag  = post.tags.create(:name => "A")

      expect(Blog::Post.tagged_with(tag)).to eq([ post ])
    end

    it "should return all posts tagged w/ given tags" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "A")
      tag1 = post.tags.create(:name => "B")

      expect(Blog::Post.tagged_with(tag0,tag1)).to eq([ post ])
    end

    it "should return all posts tagged w/ given tag name" do
      post = F("blog/post")
      tag  = post.tags.create(:name => "A")

      expect(Blog::Post.tagged_with("A")).to eq([ post ])
    end

    it "should return all posts tagged w/ given tag names" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "A")
      tag1 = post.tags.create(:name => "B")

      expect(Blog::Post.tagged_with("A", "B")).to eq([ post ])
    end

    it "should return all posts tagged w/ given tag (by slug)" do
      post = F("blog/post")
      tag0 = post.tags.create(:name => "It's me")
      tag1 = post.tags.create(:name => "And me")

      expect(Blog::Post.tagged_with("and-me", "its-me", :slug => true)).to eq([ post ])
    end

  end

  describe "#related_posts" do # ---------------------------

    it "should return all posts which share at least one tag" do
      post = F("blog/post", :tag_list => "a, b, c")
      p1   = F("blog/post", :tag_list => "a, d")
      p2   = F("blog/post", :tag_list => "b, c")
      p3   = F("blog/post", :tag_list => "x")

      expect(post.related_posts).to eq([ p1, p2 ])
    end

    it "should take a 'limit' parameter" do
      post = F("blog/post", :tag_list => "a, b, c")
      p1   = F("blog/post", :tag_list => "a, d")
      p2   = F("blog/post", :tag_list => "b, c")
      p3   = F("blog/post", :tag_list => "x")

      expect(post.related_posts(1)).to eq([ p1 ])
    end
  end

  describe "#published" do # -------------------------------

    it "should return all posts published if no date is given" do
      one   = F("blog/post", :published_at => 10.days.ago)
      two   = F("blog/post", :published_at => nil)
      three = F("blog/post", :published_at => 2.days.ago)

      expect(Blog::Post.published).to eq([ one, three ])
    end

    it "should return all posts published before a given date" do
      one   = F("blog/post", :published_at => 10.days.ago)
      two   = F("blog/post", :published_at => 7.days.ago)
      three = F("blog/post", :published_at => 2.days.ago)

      expect(Blog::Post.published(3.days.ago)).to eq([ one, two ])
    end

    it "should return all posts published in a given year" do
      one   = F("blog/post", :published_at => Time.parse("2010/11/25"))
      two   = F("blog/post", :published_at => Time.parse("2011/04/01"))
      three = F("blog/post", :published_at => Time.parse("2012/05/03"))

      expect(Blog::Post.published("2011")).to eq([ two ])
    end

    it "should return all posts published in a given month" do
      one   = F("blog/post", :published_at => Time.parse("2011/04/01"))
      two   = F("blog/post", :published_at => Time.parse("2011/04/03"))
      three = F("blog/post", :published_at => Time.parse("2011/05/03"))

      expect(Blog::Post.published(2011, 4)).to eq([ one, two ])
    end

  end

  describe "#preferred_title" do # -------------------------

    it "should return the 'title' if 'page_title' is not set" do
      post = F("blog/post", :title => "A title", :page_title => nil)
      expect(post.preferred_title).to eq("A title")
    end

    it "should return the 'page_title' if set" do
      post = F("blog/post", :title => "A title", :page_title => "A better title")
      expect(post.preferred_title).to eq("A better title")
    end

  end

  describe "#previous_post" do # ---------------------------

    it "should return the previous post" do
      a = F("blog/post", :published_at => 3.days.ago)
      b = F("blog/post", :published_at => 2.days.ago)
      c = F("blog/post", :published_at => 1.days.ago)

      expect(a.previous_post).to be_nil
      expect(b.previous_post).to eq(a)
      expect(c.previous_post).to eq(b)
    end

  end

  describe "#next_post" do # ---------------------------

    it "should return the next post" do
      a = F("blog/post", :published_at => 3.days.ago)
      b = F("blog/post", :published_at => 2.days.ago)
      c = F("blog/post", :published_at => 1.days.ago)

      expect(a.next_post).to eq(b)
      expect(b.next_post).to eq(c)
      expect(c.next_post).to be_nil
    end

  end

end
