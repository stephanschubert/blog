require 'spec_helper'

describe Blog::Post do

  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_field(:title).of_type(String) }
  it { should validate_presence_of(:title) }
  it { should have_slug(:title) }

  it { should have_field(:body).of_type(String) }
  it { should validate_presence_of(:body) }

  it { should have_field(:published_at).of_type(DateTime) }

  it { should have_and_belong_to_many(:tags) }

  it "should be valid using the factory" do # ----------------------------------
    F.build("blog/post").should be_valid
  end

  describe "#tags" do # --------------------------------------------------------

    it "should be convertable into a string of names" do
      post = F("blog/post")
      post.tags << F("blog/tag", :name => "A")
      post.tags << F("blog/tag", :name => "B")
      post.tags.to_s.should == "A,B"
    end

  end

  describe "#published" do # ---------------------------------------------------

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
