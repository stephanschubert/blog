require 'spec_helper'

describe Blog::BlogsController do

  describe "#slug" do # --------------------------------------------------------

    def view(post)
      get :slug, :slug => post.slug
    end

    # TODO Route does not match!?
    # it "should increase the post's 'views' counter" do
    #   post = F("blog/post", :published_at => 1.day.ago)
    #   lambda { view(post) }.should change(post, :views).from(0).to(1)
    # end

  end

end
