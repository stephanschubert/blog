require 'spec_helper'

describe Blog::TagsHelper do

  describe "#linked_tags_as_sentence" do # -----------------

    it "should seperate linked tags with commata and the last one with 'and'" do
      post = F("blog/post", tag_list: "a")
      html = helper.linked_tags_as_sentence(post.tags)
      html = helper.strip_tags(html)
      expect(html).to eq("a")

      post = F("blog/post", tag_list: "a,b")
      html = helper.linked_tags_as_sentence(post.tags)
      html = helper.strip_tags(html)
      expect(html).to eq("a und b")

      post = F("blog/post", tag_list: "a,b,c")
      html = helper.linked_tags_as_sentence(post.tags)
      html = helper.strip_tags(html)
      expect(html).to eq("a, b und c")
    end
  end

end
