require 'spec_helper'

describe Blog::Tag do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_timestamped_document }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_slug(:name) }

  # it { should have_and_belong_to_many(:posts) }
  it { is_expected.to be_embedded_in(:post) }

  it "should be valid using the factory" do
    expect(F.build("blog/tag")).to be_valid
  end

  describe ".separator" do # ---------------------------------------------------

    it "should be configurable and have a default" do
      expect(Blog::Tag.separator).to eq(',')
      Blog::Tag.separator = ';'
      expect(Blog::Tag.separator).to eq(';')
    end

  end

  describe ".all" do # ---------------------------------------------------------

    it "should return all unique tags" do
      one = F("blog/post")
      a   = one.tags.create :name => "A"

      two = F("blog/post")
      a2  = one.tags.create :name => "A"
      b   = two.tags.create :name => "B"
      c   = two.tags.create :name => "C"

      expect(Blog::Tag.all).to eq([ a, b, c ])
    end

  end

end
